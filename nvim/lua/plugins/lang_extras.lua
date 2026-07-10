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
    "ellisonleao/glow.nvim",
    ft = "markdown",
    cmd = "Glow",
    opts = {
      width = 120,
      height = 80,
      border = "rounded",
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    lazy = false,
    version = "1.*",
    opts = {},
  },
}
