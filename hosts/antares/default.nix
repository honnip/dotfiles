{
  imports = [
    ./hardware-configuration.nix

    ../modules/global
    ../modules/users/honnip

    ../modules/tailscale-exit-node.nix
    ../modules/node-exporter.nix
    ../modules/syncthing.nix
    ../modules/remote-build.nix

    ./services
  ];

  services.syncthing.guiAddress = "0.0.0.0:8384";

  nix.settings.max-jobs = 2;

  networking.hostName = "antares";
}
