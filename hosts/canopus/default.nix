{
  imports = [
    ./hardware-configuration.nix

    ../modules/global
    ../modules/users/honnip

    ../modules/tailscale-exit-node.nix

    ./services
  ];

  networking.hostName = "canopus";

  system.stateVersion = "24.05";
}
