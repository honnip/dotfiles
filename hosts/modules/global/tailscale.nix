{ config, lib, ... }: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
  };

  networking.firewall = {
    checkReversePath = "loose";
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
