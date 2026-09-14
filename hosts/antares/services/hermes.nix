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
      "hindsight"
    ];
    extraPackages = with pkgs; [
      legalize
    ];
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
          auto_thread = false;
          dm_auto_thread = false;
          dm_mention_threads = true;
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
