{ pkgs, ... }:
{
  imports = [
    ./spotify.nix
    ./discord.nix
    ./firefox.nix
    ./thunderbird.nix
    ./gnome.nix
  ];

  home.packages = with pkgs; [
    obs-studio

    fractal
    paper-plane

    libreoffice
    planify
    varia
    obsidian

    vscode
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
  };
}
