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

    bottles

    # josm wayland
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
  ];

  xdg.mimeApps.defaultApplications = {
    "text/csv" = "calc.desktop";
  };
}
