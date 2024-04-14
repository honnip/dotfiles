{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "browser.shell.checkDefaultBrowser" = false;
        # experimental support for fractional scaling
        "widget.wayland.fractional-scale.enabled" = true;
        # vaapi
        "media.ffmpeg.vaapi.enabled" = true;
        # firefox-gnome-theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };

      userChrome = ''
        @import "${pkgs.firefox-gnome-theme}/userChrome.css";
      '';

      userContent = ''
        @import "${pkgs.firefox-gnome-theme}/userContent.css"
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
