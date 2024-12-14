# home-manager.users.honnip =
{
  imports = [
    ./modules/global
    ./modules/cli
    ./modules/syncthing.nix
  ];

  services.syncthing.guiAddress = "0.0.0.0:8384";
}
