{ inputs, pkgs, ... }: {
  firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme {
    src = inputs.firefox-gnome-theme;
  };
}
