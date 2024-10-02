{ pkgs, ... }:
let
  lsp = with pkgs; [
    # lua
    lua-language-server
    stylua
    # nix
    nixd
    nixfmt-rfc-style
  ];
  # tree-sitter parsers
  parsers =
    p: with p; [
      c
      css
      lua
      make
      markdown
      markdown_inline
      nix
      python
      rust
      toml
      tsx
      typescript
      tree-sitter-typst
      yaml
    ];
  plugins = import ./plugins.nix { inherit pkgs; };
  configFile = file: {
    "nvim/${file}".source = pkgs.substituteAll {
      src = ./. + "/${file}";
      env = {
        ts_parser_dirs = pkgs.lib.pipe (pkgs.vimPlugins.nvim-treesitter.withPlugins parsers).dependencies [
          (map builtins.toString)
          (builtins.concatStringsSep ",")
        ];
      } // plugins;
    };
  };
  configFiles = files: builtins.foldl' (x: y: x // y) { } (map configFile files);
in
{
  programs.neovim = {
    enable = true;
    withRuby = false;
    extraPackages = lsp;
  };
  xdg.configFile = configFiles [
    "./init.lua"
    "./lua/plugins/treesitter.lua"
    "./lua/plugins/lsp.lua"
  ];
}
