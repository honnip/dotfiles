{ pkgs, ... }: {
  imports = [ ./discord.nix ./firefox.nix ./gnome.nix ];

  home.packages = with pkgs; [
    libreoffice

    obs-studio

    fractal
    tdesktop
    thunderbird
  ];

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/mailto" = "thunderbird.desktop";
    "text/calendar" = "thunderbird.desktop";
    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
  };
}
