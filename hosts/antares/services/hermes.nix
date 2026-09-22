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
    environment = {
      # https://github.com/NousResearch/hermes-agent/pull/96039
      MATRIX_DM_AUTO_THREAD = "true";
    };
    extraDependencyGroups = [
      "matrix"
      "firecrawl"
      "hindsight"
    ];
    extraPackages = with pkgs; [
      legalize
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
          default = "deepseek/deepseek-v4.1-flash";
        };
        terminal.cwd = config.services.hermes-agent.workingDirectory;
        compression = {
          enabled = true;
          threshold = 0.85;
        };
        memory = {
          memory_enabled = true;
          provider = "hindsight";
        };
        display = {
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
        checkpoints.enabled = true;
        security.allow_lazy_installs = false;
        mcp_servers = {
          legalize = {
            command = "legalize-mcp";
            env.GITHUB_TOKEN = "\${GITHUB_TOKEN}";
            timeout = 30;
          };
        };
        plugins.enabled = [ "superpowers" ];
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
