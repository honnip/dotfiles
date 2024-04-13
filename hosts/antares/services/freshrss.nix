{ config, ... }:
let
  base = "${config.networking.hostName}.capybara-ide.ts.net";
  subpath = "/feed/";
in {
  services = {
    freshrss = {
      enable = true;
      baseUrl = "https://" + base + subpath;
      authType = "none";
      language = "ko";
    };
    nginx.defaultHTTPListenPort = 8080;
  };
}
