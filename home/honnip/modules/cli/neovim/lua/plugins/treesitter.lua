return {
  {
    name = "nvim-treesitter",
    dir = "@nvim_treesitter@",
    config = function()
      vim.opt.runtimepath:append("@ts_parser_dirs@")
    end,
    event = "BufRead",
  },
}
