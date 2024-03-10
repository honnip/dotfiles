{
  imports = [ ./global/tailscale.nix ]; # depends on global tailscale module
  services.tailscale.userRoutingFeatures = "both";
}
