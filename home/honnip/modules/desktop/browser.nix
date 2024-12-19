{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "ko" ];
    profiles.default = {
      settings = {
        "browser.shell.checkDefaultBrowser" = false;
        # experimental support for fractional scaling
        "widget.wayland.fractional-scale.enabled" = true;
        # vaapi
        "media.ffmpeg.vaapi.enabled" = true;
        # always use the DE's file picker
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        # firefox-gnome-theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };

      userChrome = ''
        @import "${pkgs.firefox-gnome-theme}/userChrome.css";

        #TabsToolbar {
          display: none;
        }

        #sidebar-header {
          display: none;
        }
      '';

      userContent = ''
        @import "${pkgs.firefox-gnome-theme}/userContent.css"
      '';
    };
  };

  systemd.user.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 0;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
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
