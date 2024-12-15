{
  imports = [
    ./hardware-configuration.nix

    ../modules/global
    ../modules/users/honnip

    ../modules/tailscale-exit-node.nix
    ../modules/node-exporter.nix
    ../modules/syncthing.nix

    ./services
  ];

  services.syncthing.guiAddress = "0.0.0.0:8384";

  networking.hostName = "antares";
}
