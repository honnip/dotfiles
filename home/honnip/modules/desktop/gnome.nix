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
  # Disable gnome-keyring ssh-agent
  xdg.configFile = {
    "autostart/gnome-keyring-ssh.desktop".text = ''
      ${lib.fileContents "${pkgs.gnome.gnome-keyring}/etc/xdg/autostart/gnome-keyring-ssh.desktop"}
      Hidden=true
    '';
  };

  home.packages =
    extensions
    ++ (with pkgs; [
      wl-clipboard
      smile
    ]);

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      # gsettings get org.gnome.shell asdf
      enabled-extensions = builtins.map (x: x.extensionUuid) extensions;
    };
    "org/gnome/mutter" = {
      "experimental-features" = [
        "scale-monitor-framebuffer"
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
      "text/csv" = "org.gnome.TextEditor.desktop";
      "text/markdown" = "org.gnome.TextEditor.desktop";
      "text/xml" = "org.gnome.TextEditor.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      # video & audio
      "audio/mp4" = "org.gnome.Totem.desktop";
      "video/mp4" = "org.gnome.Totem.desktop";
      "video/webm" = "org.gnome.Totem.desktop";
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
