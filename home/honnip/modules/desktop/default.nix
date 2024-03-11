{ pkgs, ... }: {
  imports = [ ./discord.nix ./firefox.nix ./thunderbird.nix ./gnome.nix ];

  home.packages = with pkgs; [
    libreoffice

    obs-studio

    fractal
    tdesktop
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
  };
}
