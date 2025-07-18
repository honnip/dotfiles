{ pkgs, lib, ... }:
let
  extensions = with pkgs.gnomeExtensions; [
    alphabetical-app-grid
    appindicator
    blur-my-shell
    dock-from-dash
    just-perfection
    pano
    smile-complementary-extension
    tailscale-qs
  ];
in
{
  home.packages =
    extensions
    ++ (with pkgs; [
      wl-clipboard
      smile # emoji picker
      packet # quick share client
    ]);

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = builtins.map (x: x.extensionUuid) extensions;
    };
    "org/gnome/mutter" = {
      "experimental-features" = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
        "variable-refresh-rate"
      ];
    };
    "org/gnome/desktop/input-sources" = {
      "sources" = [
        (lib.hm.gvariant.mkTuple [
          "ibus"
          "hangul"
        ])
      ];
      "xkb-options" = [ "korean:ralt_hangul" ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>semicolon";
      command = "smile";
      name = "Smile; emoji picker";
    };
    "org/freedesktop/ibus/engine/hangul" = {
      "switch-keys" = "Hangul";
      "use-event-forwarding" = false;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # document
      "text/plain" = "org.gnome.TextEditor.desktop";
      "text/markdown" = "org.gnome.TextEditor.desktop";
      "text/xml" = "org.gnome.TextEditor.desktop";
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      # video & audio
      "audio/mp4" = "org.gnome.Showtime.desktop";
      "video/mp4" = "org.gnome.Showtime.desktop";
      "video/webm" = "org.gnome.Showtime.desktop";
      "video/x-matroska" = "org.gnome.Showtime.desktop";
      # image
      "image/avif" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/heic" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/jxl" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
      "image/svg_xml-compressed" = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/vnd-microsoft.icon" = "org.gnome.Loupe.desktop";
      "image/vnd-ms.dds" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/x-dds" = "org.gnome.Loupe.desktop";
      "image/x-exr" = "org.gnome.Loupe.desktop";
      "image/x-portable-bitmap" = "org.gnome.Loupe.desktop";
      "image/x-portable-graymap" = "org.gnome.Loupe.desktop";
      "image/x-portable-pixmap" = "org.gnome.Loupe.desktop";
      "image/x-portable-anymap" = "org.gnome.Loupe.desktop";
      "image/x-qoi" = "org.gnome.Loupe.desktop";
      "image/x-tga" = "org.gnome.Loupe.desktop";
    };
  };
}
