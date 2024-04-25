{ lib, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-inlay-hints = true;
        color-modes = true;
        indent-guides.render = true;
      };
      keys.normal = {
        "C-j" = [
          "delete_selection"
          "move_line_down"
          "paste_before"
        ];
        "C-k" = [
          "delete_selection"
          "move_line_up"
          "paste_before"
        ];
        "C-h" = [
          "delete_selection"
          "move_char_left"
          "paste_before"
        ];
        "C-l" = [
          "delete_selection"
          "move_char_right"
          "paste_before"
        ];
      };
    };
    languages = {
      language-server = {
        nixd = {
          command = lib.getExe pkgs.nixd;
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter = {
            command = lib.getExe pkgs.nixfmt-rfc-style;
          };
        }
      ];
    };
  };
}
