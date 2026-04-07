# Neovim Spec Sheet

## Purpose

This config is a standard Neovim setup structured like `igmrrf/dotfiles/.config/nvim`, but tuned around your brief:

- Gruvbox only
- transparent UI
- coding plus prose writing
- which-key and Telescope for discovery
- dashboard start screen
- Harpoon for fast file switching
- PowerShell on Windows, Fish on Linux
- Markdown and Typst comfort settings
- no JavaScript debugging stack

## Layout

- `init.lua`: loads the core config modules
- `lua/config`: options, keymaps, LSP, autocmds, commands, logo, lazy bootstrap
- `lua/plugins`: plugin specs grouped by purpose
- `after/ftplugin`: filetype-specific reading/writing behavior

## Core Plugins

- `lazy.nvim`: plugin manager
- `gruvbox.nvim`: colorscheme
- `which-key.nvim`: discover mappings with `<leader>`
- `telescope.nvim`: find files, grep, symbols, commands, keymaps
- `dashboard-nvim`: startup screen with the ASCII logo
- `harpoon`: pinned file jumping
- `no-neck-pain.nvim`: always-on centered layout for a permanent zen feel
- `venv-selector.nvim`: Python virtual environment switching and activation
- `nvim-treesitter`: highlighting and folding
- `mason.nvim` + `mason-lspconfig.nvim` + `nvim-lspconfig`: language servers
- `nvim-cmp` + `LuaSnip`: completion and snippets
- `conform.nvim`: formatting
- `vim-markdown` + `markdown-preview.nvim`: Markdown workflow
- `typst.vim`: Typst support
- `neotest`: test runner
- `Comment.nvim`: comment toggling
- `nvim-notify`: notifications
- `vim-wakatime`: activity tracking

## First Boot

1. Open Neovim in the real config location.
2. `lazy.nvim` will install missing plugins.
3. Run `:Mason` and install anything you want available locally.
4. If you use Markdown preview, trigger it once with `<leader>mp` so its install step can complete.
5. Make sure these external tools exist if you want the related features:

- `lazygit`
- `rg`
- `fd`
- `uv`
- `clangd`
- `rust-analyzer`
- `intelephense`
- `pyright`
- `typescript-language-server` or Mason-managed `ts_ls`
- `tinymist`
- `prettier` or `prettierd`
- `black` or `ruff`
- `stylua`
- `typstyle`

## How To Drive It

- Press `<leader>` and wait for which-key if you forget a mapping.
- Press `<leader>?` for buffer-local keymaps.
- Use `<leader>;` to return to the dashboard.
- Use `<leader>ff` to find files and `<leader>fg` to grep text.
- Use `<leader>fc` for the command board.
- Use Harpoon when you are bouncing between a small set of files.
- Use `<leader>gg` for Git through your installed `lazygit` binary.
- Use `<leader>tt` for a fresh split terminal.
- Use `<leader>tn` to toggle the always-centered layout.
- Use `<leader>zz` for an extra temporary focus mode on top.
- Use `:NvimSpec` or `<leader>Ls` to reopen this sheet.
- `:term` and `:terminal` are routed to the same split-terminal helper as `<leader>tt`.

## LunarVim-Style Keys

These now match the common LunarVim defaults closely:

- `K`: hover information
- `gd`: go to definition
- `gD`: go to declaration
- `gr`: references
- `gI`: implementation
- `gs`: signature help
- `gl`: line diagnostics
- `<leader>h`: clear search highlight
- `<leader>sh`: search help
- `<leader>sr`: recent files
- `<leader>sk`: search keymaps
- `<leader>e`: file explorer
- `<leader>pS`: plugin manager
- `<leader>th`: previous tab
- `<leader>tl`: next tab
- `<leader>to`: new tab
- `<leader>tx`: close tab
- `<leader>vs`: select Python env
- `<leader>vp`: activate project `.venv`
- `<leader>vc`: activate cached Python env
- `<leader>vi`: show current Python env
- `<leader>vu`: run `uv sync`
- `<C-h/j/k/l>`: window navigation
- `<C-Up/Down/Left/Right>`: resize windows
- `<leader>/`: toggle comment
- `<A-j>` / `<A-k>`: move lines or selections
- `<Esc><Esc>` in terminal mode: leave terminal insert mode

## Daily Workflow

### Navigation

- `<leader>ff`: files
- `<leader>fb`: open buffers
- `<leader>fg`: live grep
- `<leader>fC`: commands
- `<leader>fs`: document symbols
- `<leader>fS`: workspace symbols
- `<leader>fh`: help tags

### Tabs

- `<leader>th`: previous tab
- `<leader>tl`: next tab
- `<leader>to`: open a new tab
- `<leader>tx`: close the current tab
- `gt`: next tab
- `gT`: previous tab

These work in terminal mode too, so `:term` does not trap you in one tab.

### Harpoon

- `<leader>ha`: add current file
- `<leader>hh`: open Harpoon menu
- `<leader>1` to `<leader>4`: jump to pinned files

### Git

- `<leader>gg`: open LazyGit

This opens LazyGit in a fixed bottom split. Quitting LazyGit closes only that split and returns focus to your previous window.

### Buffers in Terminal Mode

- `<S-h>`: previous buffer
- `<S-l>`: next buffer
- `<leader>bd`: delete current buffer

These terminal-mode mappings first leave terminal insert mode, so terminal buffers do not trap normal buffer navigation.

### Centered Editing

- The layout now uses `no-neck-pain.nvim` to keep the main editing window centered automatically.
- It is configured with safe auto-enable on startup so it does not fight the dashboard during launch.
- `<leader>tn`: toggle the centered layout
- `<leader>zz`: extra temporary Zen Mode when you want even fewer distractions

### Testing

- `<leader>tm`: nearest test
- `<leader>tf`: current file tests
- `<leader>ts`: test summary

### Python and uv

- Open a Python file inside a project with `pyproject.toml` or `uv.lock`.
- If `./.venv` exists, Neovim will auto-activate it for LSP, completion, and new terminal buffers.
- Use `uv sync` in the project root to create or refresh `./.venv`.
- `<leader>vp`: force the project-local `./.venv`
- `<leader>vs`: pick another env manually
- `<leader>vc`: re-activate a cached env you selected earlier
- `<leader>vi`: show the active venv and Python path
- `<leader>vu`: run `uv sync` in a split terminal from the detected project root

Recommended `uv` workflow:

1. `uv init` once for a new project if needed.
2. `uv add ...` to add runtime dependencies or `uv add --dev ...` for dev tools.
3. `uv sync` whenever dependencies or the lockfile change.
4. Open Neovim from the project root or any file inside it and let the local `./.venv` auto-attach.

### Formatting

- `<leader>lf`: format via LSP or Conform
- `:Format`: manual format command

### LSP

- This setup uses Neovim 0.12 native LSP configuration APIs.
- PHP uses `intelephense` for completion, hover, and navigation.
- Rust uses your toolchain `rust-analyzer` from `~/.cargo/bin`, not Mason’s copy.
- `:checkhealth vim.lsp` or `<leader>li`: inspect LSP health
- `<leader>lR`: restart LSP clients

### Markdown and Typst

- Markdown and Typst buffers wrap text and enable spellchecking automatically.
- Their spell language is pinned to `en_gb`, so regional variants are checked as British English.
- `<leader>mp`: Markdown preview toggle

## Shell Behavior

- Windows uses `powershell`, with `cmd` as fallback
- Linux uses `fish` when available
- Interactive terminals are opened explicitly, so `:TermNew` uses `powershell -NoLogo -NoExit` on Windows and does not inherit the `:!` command-shell flags.

## Notes

- The background is intentionally transparent now.
- Full transparency still depends on your terminal emulator allowing window opacity/transparency. Neovim can only clear its own backgrounds.
- The current line still has a subtle Gruvbox tint so the cursor row remains readable.
- `legendary.nvim` was not added even though it appeared in the plan, because its upstream repository was archived on April 17, 2025.
- This config is plain Neovim, not LunarVim. The feel is partially aligned, but the implementation is your own split `lazy.nvim` setup.
