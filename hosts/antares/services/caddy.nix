{ config, ... }:
let
  base = "${config.networking.hostName}.capybara-ide.ts.net";
in {
  services = {
    caddy = {
      enable = true;
      virtualHosts = {
        ${base}.extraConfig = ''
          handle_path /feed/* {
            reverse_proxy 127.0.0.1:${toString config.services.nginx.defaultHTTPListenPort} {
              header_up Host {host}
              header_up X-Real-IP {remote}
              header_up X-Forwarded-Ssl {on}
              header_up X-Forwarded-Prefix "/feed/"
            }
          }
          handle_path /vault/* {
            reverse_proxy 127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT} {
              header_up X-Real-IP {remote_host}
            }
          }
        '';
      };
    };
    tailscale.permitCertUid = "caddy";
  };
}
