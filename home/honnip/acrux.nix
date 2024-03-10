# home-manager.users.honnip =
{ lib, ... }: {
  imports = [
    ./modules/global
    ./modules/cli
    ./modules/desktop
    ./modules/syncthing.nix
  ];
}
