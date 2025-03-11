{
  imports = [
    ./hardware-configuration.nix

    ../modules/global
    ../modules/users/honnip

    ../modules/tailscale-exit-node.nix
    ../modules/node-exporter.nix
    ../modules/remote-build.nix

    ./services
  ];

  nix.settings.max-jobs = 1;

  networking.hostName = "canopus";
}
