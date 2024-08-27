{
  config,
  lib,
  pkgs,
  ...
}:
let
  hasFlatpak = config.services.flatpak.enable;
in
{
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
  };

  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-tour
      geary # email reader
      yelp # help view
      tali # pocker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
    ]
  );

  environment.systemPackages = [
    pkgs.gnome-tweaks
  ] ++ (lib.optionals hasFlatpak [ pkgs.gnome-software ]);

  i18n = {
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };
}
