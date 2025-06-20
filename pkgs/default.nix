{ inputs, pkgs, ... }:
{
  firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { src = inputs.firefox-gnome-theme; };
  thunderbird-gnome-theme = pkgs.callPackage ./thunderbird-gnome-theme {
    src = inputs.thunderbird-gnome-theme;
  };
  hollo = pkgs.callPackage ./hollo { };
}
