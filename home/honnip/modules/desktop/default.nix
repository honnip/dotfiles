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
    paper-plane

    libreoffice
    obsidian

    vscode
    zed-editor.fhs

    fragments
    rquickshare

    (josm.override {
      jre = jdk21.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "openjdk";
          repo = "wakefield";
          rev = "16cb66c24910f24be44ac19949a8933c8afba848";
          hash = "sha256-sQ63/zPKOk2d0hBt5uVVaZT1RZKOaBwuXp/b8DVa5mI=";
        };
      };
      extraJavaOpts = "-Djosm.restart=true -Djava.net.useSystemProxies=true -Dawt.toolkit.name=WLToolkit -Dsun.java2d.vulkan=true";
    })

    bottles
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
    "text/csv" = "calc.desktop";
  };
}
