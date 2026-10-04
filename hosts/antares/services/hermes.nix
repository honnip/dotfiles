{
  inputs,
  config,
  pkgs,
  ...
}:
{
  services.hermes-agent = {
    enable = true;
    package = inputs.hermes.packages.${pkgs.system}.minimal;
    addToSystemPackages = true;
    environmentFiles = [ config.sops.secrets.hermes.path ];
    extraDependencyGroups = [
      "matrix"
      "firecrawl"
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
    extraPlugins = [ pkgs.superpowers ];
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
    hermesHomeFiles = {
      "hindsight/config.json" = pkgs.writeText "config.json" (
        builtins.toJSON {
          mode = "local_external";
          api_url = "http://localhost:8888";
        }
      );
    };
  };
  sops.secrets.hermes = {
    sopsFile = ../secrets.yaml;
    restartUnits = [ "hermes-agent.service" ];
  };
  systemd.services.hermes-agent.restartTriggers = [
    (builtins.readFile config.services.hermes-agent.configFile)
  ];
}
