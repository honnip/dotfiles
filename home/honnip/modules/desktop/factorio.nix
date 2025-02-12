{ pkgs, ... }:
{
  home.packages = [
    (pkgs.factorio.override {
      username = "";
      token = "";
    })
  ];
}
