{
  programs.helix = {
    enable = true;
    settings = {
      editor = {
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
  };

  systemd.user.sessionVariables = {
    EDITOR = "hx";
  };
}
