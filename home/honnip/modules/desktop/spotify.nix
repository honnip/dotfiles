{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.comfy;
    colorScheme = "rose-pine-moon";
    enabledCustomApps = with spicePkgs.apps; [
      # marketplace
      lyrics-plus
    ];
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      betterGenres
      fullAlbumDate
    ];
  };
}
