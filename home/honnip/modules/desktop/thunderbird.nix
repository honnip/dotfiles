{ pkgs, ... }: {
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        # experimental support for fractional scaling
        "widget.wayland.fractional-scale.enabled" = true;
        # thunderbird-gnome-theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
      };

      userChrome = ''
        @import "${pkgs.thunderbird-gnome-theme}/userChrome.css";
      '';

      userContent = ''
        @import "${pkgs.thunderbird-gnome-theme}/userContent.css"
      '';
    };
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/mailto" = "thunderbird.desktop";
    "text/calendar" = "thunderbird.desktop";
  };
}
