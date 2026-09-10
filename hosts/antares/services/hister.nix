{ config, ... }:
let
  base = "https://${config.networking.hostName}.capybara-ide.ts.net/hister";
in
{
  services.hister = {
    enable = true;
    port = 4433;
    settings = {
      app = {
        search_url = "https://kagi.com/search?q={query}";
      };
      server = {
        base_url = base;
      };
    };
  };
}
