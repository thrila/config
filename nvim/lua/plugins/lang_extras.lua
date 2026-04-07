return {
  {
    "preservim/vim-markdown",
    ft = "markdown",
    init = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_conceal = 2
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.tex_conceal = ""
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_theme = "dark"
    end,
  },
  {
    "kaarmu/typst.vim",
    ft = "typst",
  },
}
