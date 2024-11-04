{ config, ... }:
let
  base = "${config.networking.hostName}.capybara-ide.ts.net";
in
{
  services = {
    vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      config = {
        DOMAIN = "https://" + base;
        SIGNUPS_ALLOWED = false;

        DATABASE_URL = "postgresql:///vaultwarden";
        ROCKET_PORT = 8000;
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "vaultwarden" ];
    ensureUsers = [
      {
        name = "vaultwarden";
        ensureDBOwnership = true;
      }
    ];
  };
}
