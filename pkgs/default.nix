{ inputs, pkgs, ... }:
{
  firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { src = inputs.firefox-gnome-theme; };
  thunderbird-gnome-theme = pkgs.callPackage ./thunderbird-gnome-theme {
    src = inputs.thunderbird-gnome-theme;
  };
  legalize-cli = pkgs.callPackage ./legalize-cli { src = inputs.legalize-cli; };
  legalize-skills = pkgs.callPackage ./legalize-skills { src = inputs.legalize-skills; };
  superpowers = pkgs.callPackage ./superpowers { src = inputs.superpowers; };
  humanizer = pkgs.callPackage ./humanizer { src = inputs.humanizer; };
  simple-english = pkgs.callPackage ./simple-english { src = inputs.simple-english; };
}
