# Neovim Notes

## File Explorer

Primary explorer is **nvim-tree**.

Keymaps (global):
- `<leader>e` toggle tree
- `<leader>ef` reveal current file in tree

Keymaps (inside nvim-tree):
- `l` open
- `h` close node
- `v` open vertical split
- `s` open horizontal split
- `a` create
- `d` delete
- `r` rename
- `y` copy name
- `Y` copy relative path
- `C` copy absolute path
- `R` refresh
- `.` toggle hidden
- `?` help

Secondary explorer is **oil.nvim** (float-only).

Keymaps:
- `<leader>O` open Oil float
- `q` or `<Esc>` close float
- `-` parent directory
- `<CR>` open
- `<C-s>` vertical split
- `<C-t>` tab
- `<C-p>` preview
- `g.` toggle hidden
- `g\` toggle trash
- `g?` help

## Obsidian.nvim

Keymaps (buffer-local in vault markdown files):
- `gf` follow wiki/markdown link
- `<leader>ch` toggle checkbox
- `<CR>` smart action (follow link or toggle checkbox)

Common commands (type full command name):
- `:ObsidianNew`
- `:ObsidianOpen`
- `:ObsidianQuickSwitch`
- `:ObsidianSearch`
- `:ObsidianFollowLink`
