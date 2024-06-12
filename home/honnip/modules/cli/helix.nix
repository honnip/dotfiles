{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
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
          command = "nixd";
        };
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = [ "nixd" ];
          formatter = {
            command = "nixfmt";
          };
        }
      ];
    };
  };
}
