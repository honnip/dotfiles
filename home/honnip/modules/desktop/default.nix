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
    kiwitalk

    libreoffice
    obsidian

    vscode
    zed-editor
    
    fragments
    rquickshare
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
  };
}
