{
  services.tailscale = {
    useRoutingFeatures = "both";
    extraUpFlags = [ "--advertise-exit-node" ];
  };
}
