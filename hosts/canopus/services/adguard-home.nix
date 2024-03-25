{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      dns = {
        bind_hosts = [ "127.0.0.1" "::1" ];
        upstream_dns = [ "1.1.1.1" "9.9.9.9" ];
        bootstrap_dns = [ "1.1.1.1" "9.9.9.9" ];
      };
    };
  };

  networking = {
    firewall = {
      # WEB-UI
      # allowedTCPPorts = [ 3000 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  services.tailscale.extraUpFlags = [ "--accept-dns=false" ];
}
