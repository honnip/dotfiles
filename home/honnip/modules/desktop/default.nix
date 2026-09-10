{ pkgs, ... }:
{
  imports = [
    ./spotify.nix
    ./discord.nix
    ./browser.nix
    ./thunderbird.nix
    ./gnome.nix
  ];

  home.packages = with pkgs; [
    obs-studio
    vlc

    fractal

    libreoffice
    obsidian

    vscode

    fragments
  ];

  xdg.mimeApps.defaultApplications = {
    "text/csv" = "calc.desktop";
  };
}
