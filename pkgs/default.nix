{ inputs, pkgs, ... }:
let
  # Package versions track the flake input tag pins. flake.lock records the
  # original ref of each input, so bumping a tag updates the version for free.
  versionOf =
    name:
    pkgs.lib.removePrefix "v" (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.${name}.original.ref;
in
{
  firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { src = inputs.firefox-gnome-theme; };
  thunderbird-gnome-theme = pkgs.callPackage ./thunderbird-gnome-theme {
    src = inputs.thunderbird-gnome-theme;
  };
  legalize-cli = pkgs.callPackage ./legalize-cli {
    src = inputs.legalize-cli;
    version = versionOf "legalize-cli";
  };
  legalize-skills = pkgs.callPackage ./legalize-skills {
    src = inputs.legalize-skills;
    version = versionOf "legalize-skills";
  };
  superpowers = pkgs.callPackage ./superpowers {
    src = inputs.superpowers;
    version = versionOf "superpowers";
  };
  humanizer = pkgs.callPackage ./humanizer {
    src = inputs.humanizer;
    version = versionOf "humanizer";
  };
  simple-english = pkgs.callPackage ./simple-english {
    src = inputs.simple-english;
    version = versionOf "simple-english";
  };
}
