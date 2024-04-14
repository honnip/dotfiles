{ lib, config, ... }:
let
  inherit (lib) mkIf;
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasEza = hasPackage "eza";
  hasBat = hasPackage "bat";
in
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      ls = mkIf hasEza "eza";
      cat = mkIf hasBat "bat --paging=never";
    };
    shellAliases = {
      clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
    };
    functions = {
      # fish_greeting = "";
    };
  };

  programs.mcfly.enable = true;
}
