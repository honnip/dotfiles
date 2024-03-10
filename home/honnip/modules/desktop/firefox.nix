{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "widget.wayland.fractional-scale.enabled" = true;
        "browser.shell.checkDefaultBrowser" = false;
      };

      userChrome = ''
        @import "${pkgs.firefox-gnome-theme}/share/firefox-gnome-theme/gnome-theme.css";
      '';
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "text/xml" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/chrome" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
    "application/x-extension-htm" = "firefox.desktop";
    "application/x-extension-html" = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht" = "firefox.desktop";
  };
}
