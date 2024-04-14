{ config, ... }:
let
  base = "${config.networking.hostName}.capybara-ide.ts.net";
in
{
  services = {
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://" + base;
        ROCKET_PORT = 8000;
        SIGNUPS_ALLOWED = false;
      };
    };
  };
}
