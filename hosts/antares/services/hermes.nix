{
  inputs,
  config,
  pkgs,
  ...
}:
let
  # The memory-provider lookup (plugins.memory.find_provider_dir) resolves a
  # provider by DIRECTORY NAME under ~/.hermes/plugins/, and extraPlugins only
  # ever links `nix-managed-<name>`, which that lookup never matches. So the
  # plugin files are installed under plugins/hindsight/ — the layout
  # `hermes plugins install hindsight` creates. Keep the file list in sync with
  # the plugin's runtime files. Values must be paths: hermesHomeFiles copies a
  # path and writes a string as the file content, so the flake input (a store
  # path set) is coerced to one here.
  pluginRoot =
    /.
    + builtins.unsafeDiscardStringContext (
      toString inputs.hindsight-plugin + "/hindsight-integrations/hermes"
    );
  pluginFiles = builtins.listToAttrs (
    map
      (file: {
        name = "plugins/hindsight/${file}";
        value = pluginRoot + "/${file}";
      })
      [
        "plugin.yaml"
        "__init__.py"
        "config_schema.py"
        "embedded.py"
        "settings.py"
        "setup.py"
        "templates.py"
      ]
  );
in
{
  services.hermes-agent = {
    enable = true;
    package = inputs.hermes.packages.${pkgs.system}.minimal;
    addToSystemPackages = true;
    environment = {
      MATRIX_DM_AUTO_THREAD = "true";
    };
    environmentFiles = [ config.sops.secrets.hermes.path ];
    extraDependencyGroups = [
      "matrix"
      "firecrawl"
    ];
    # Python deps of the hindsight plugin. The hermes build rejects extra
    # packages whose names already exist in its sealed venv, so these carry no
    # propagated dependencies of their own (see pkgs/hindsight-client).
    extraPythonPackages = with pkgs; [
      hindsight-client
      hindsight-embed
      aiohttp-retry
    ];
    extraPackages = with pkgs; [
      legalize-cli
      git
      gh
      jq
      yq
      unzip
      _7zz
      sqlite
      python3
      uv
      poppler-utils
      pandoc
    ];
    extraPlugins = [
      pkgs.superpowers
    ];
    configFile = pkgs.writeText "config.yaml" (
      builtins.toJSON {
        model = {
          provider = "xiaomi";
          model = "mimo-v2.6-pro";
        };
        fallback_providers = {
          provider = "deepseek";
          model = "deepseek-flash";
        };
        auxiliary = {
          title_generation = {
            provider = "xiaomi";
            model = "mimo-v2.6-flash";
          };
          compression = {
            provider = "xiaomi";
            model = "mimo-v2.6-flash";
          };
          vision = {
            provider = "deepseek";
            model = "deepseek-flash";
          };
          approval = {
            provider = "xiaomi";
            model = "deepseek-flash";
          };
        };
        terminal.cwd = config.services.hermes-agent.workingDirectory;
        approvals = {
          mode = "smart";
        };
        compression = {
          enabled = true;
          threshold = 0.85;
        };
        memory = {
          memory_enabled = true;
          provider = "hindsight";
        };
        display = {
          language = "ko";
          compact = false;
          personality = "kawaii";
        };
        web = {
          search_backend = "firecrawl";
          extract_backend = "firecrawl";
        };
        matrix = {
          require_mention = false;
          dm_auto_thread = true;
        };
        gateway = {
          strict = true;
          media_delivery_allow_dirs = [ config.services.hermes-agent.workingDirectory ];
        };
        checkpoints.enabled = true;
        security.allow_lazy_installs = false;
        skills = {
          external_dirs = with pkgs; [
            legalize-skills
            simple-english
            humanizer
          ];
        };
        mcp_servers = {
          legalize = {
            command = "legalize-mcp";
            env.GITHUB_TOKEN = "\${GITHUB_TOKEN}";
            timeout = 30;
          };
        };
        plugins.enabled = [
          "hindsight"
          "superpowers"
        ];
      }
    );
    # pyproject.toml is left out on purpose so `hermes update` never stops at
    # the plugin's "declares Python dependencies" prompt; its deps are declared
    # above as extraPythonPackages.
    hermesHomeFiles = {
      "hindsight/config.json" = pkgs.writeText "config.json" (
        builtins.toJSON {
          mode = "local_external";
          api_url = "http://localhost:8888";
          # always timeout
          prefetch_waits_for_retain = false;
        }
      );
    }
    // pluginFiles;
  };
  sops.secrets.hermes = {
    sopsFile = ../secrets.yaml;
    restartUnits = [ "hermes-agent.service" ];
  };
  systemd.services.hermes-agent.restartTriggers = [
    config.services.hermes-agent.configFile
  ];
}
