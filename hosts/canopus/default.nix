{
  imports = [
    ./hardware-configuration.nix

    ../modules/global
    ../modules/users/honnip

    ../modules/tailscale-exit-node.nix
    ../modules/remote-build.nix
    ../modules/server.nix

    ./services
  ];

  nix.settings.max-jobs = 1;

  networking.hostName = "canopus";
}
