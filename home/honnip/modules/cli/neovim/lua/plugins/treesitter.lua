return {
  {
    name = "nvim-treesitter",
    dir = "@nvim_treesitter@",
    event = "VeryLazy",
    opts = {
      highlight = { enable = true }
    },
    config = function(_, opts)
      vim.opt.runtimepath:append("@ts_parser_dirs@")
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
