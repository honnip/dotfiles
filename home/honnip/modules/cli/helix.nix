{
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
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
          config = {
            nixpkgs.expr = "import \"\${flake.inputs.nixpkgs}\" { }";
            options = {
              nixos.expr = "(let pkgs = import \"\${inputs.nixpkgs}\" { }; in (pkgs.lib.evalModules { modules = (import \"\${inputs.nixpkgs}/nixos/modules/module-list.nix\") ++ [ ({...}: { nixpkgs.hostPlatform = builtins.currentSystem; }) ]; })).options";
              home_manager.expr = "(let pkgs = import \"\${inputs.nixpkgs}\" { }; lib = import \"\${inputs.home-manager}/modules/lib/stdlib-extended.nix\" pkgs.lib; in (lib.evalModules { modules = (import \"\${inputs.home-manager}/modules/modules.nix\") { inherit lib pkgs; check = false; }; })).options";
            };
          };
        };
      };
      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter = {
            command = "nixfmt";
          };
        }
      ];
    };
  };
}
