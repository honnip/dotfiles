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

  environment.gnome.excludePackages =
    (with pkgs; [ gnome-tour ])
    ++ (with pkgs.gnome; [
      geary # email reader
      tali # pocker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # help view
      gnome-contacts
    ]);

  environment.systemPackages =
    with pkgs.gnome;
    [ gnome-tweaks ] ++ (lib.optionals hasFlatpak [ pkgs.gnome.gnome-software ]);

  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ hangul ];
    };
  };
}
