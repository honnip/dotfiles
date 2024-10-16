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
    vlc

    fractal
    paper-plane

    libreoffice
    obsidian

    vscode
    zed-editor.fhs

    fragments
    rquickshare
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
  };
}
