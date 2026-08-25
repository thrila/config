# Neovim Spec Sheet

## Purpose

Zen-mode Neovim. Transparent, minimal, fast. Coding and prose writing with zero visual noise.

- transparent UI — no backgrounds, just code
- which-key and Telescope for discovery
- dashboard start screen
- Harpoon for fast file switching
- Markdown and Typst comfort settings

## Layout

```
init.lua              → loads config modules
lua/config/           → options, keymaps, LSP, autocmds, commands, terminal, build, logo
lua/plugins/          → plugin specs grouped by purpose
after/ftplugin/       → filetype-specific behavior
```

## Core Plugins

| Purpose                       | Plugin                                        |
| ----------------------------- | --------------------------------------------- |
| Plugin manager                | `lazy.nvim`                                   |
| Colorscheme                   | `guts.nvim` (transparent, zen)                |
| Keybinding hints              | `which-key.nvim`                              |
| Fuzzy search                  | `telescope.nvim`                              |
| Start screen                  | `dashboard-nvim`                              |
| File pinning                  | `harpoon`                                     |
| Centered layout               | `no-neck-pain.nvim`                           |
| Sessions                      | `auto-session`                                |
| Python env switching          | `venv-selector.nvim`                          |
| Syntax highlighting           | `nvim-treesitter`                             |
| Language servers              | `mason.nvim` + `mason-lspconfig.nvim` + `nvim-lspconfig` |
| Completion                    | `nvim-cmp` + `LuaSnip`                        |
| Formatting                    | `conform.nvim`                                |
| Markdown                      | `vim-markdown` + `glow.nvim`                  |
| Typst                         | `typst-preview.nvim`                          |
| Testing                       | `neotest` (Rust, Python, Haskell, Jest)       |
| Comments                      | `Comment.nvim`                                |
| Git UI                        | `gitsigns.nvim` + `lazygit`                   |
| Notifications                 | `nvim-notify`                                 |

## First Boot

1. Open Neovim — `lazy.nvim` installs everything.
2. `:Mason` — install any servers you want locally.
3. Install `glow` for markdown preview: `go install github.com/charmbracelet/glow@latest`
4. External tools for full features:

```
lazygit  rg  fd  uv  gcc  g++  cargo  ghc  cabal  fourmolu  haskell-language-server  nu
stylua  rustfmt  ruff  black  prettierd  typstyle  opencode  glow
```

## How To Drive It

- `<leader>` → wait for which-key popup
- `<leader>?` → buffer-local keymaps
- `<leader>;` → dashboard
- `<leader>ff` / `<leader>fg` → find files / grep
- `<leader>fc` → command board
- `<leader>gg` → LazyGit
- `<leader>oc` → OpenCode
- `<leader>tt` → new terminal (split)
- `<leader>tT` → new terminal (current buffer, no split)
- `<leader>tn` → toggle centered layout
- `<leader>zz` → zen mode
- `<leader>ww` → web search (DuckDuckGo)

## LSP Keys

- `K` → hover (multi-client, accurate, falls back to diagnostics)
- `gd` → definition
- `gD` → declaration
- `gr` → references
- `gI` → implementation
- `gs` → signature help
- `gl` → line diagnostics
- `<leader>lr` → rename
- `<leader>la` → code action
- `<leader>lf` → format
- `[d` / `]d` → prev/next diagnostic

## Build & Run

All build commands run in a bottom terminal and auto-detect your filetype.

**Rust:**
- `<leader>bb` → `cargo build`
- `<leader>br` → `cargo run`
- `<leader>bt` → `cargo test`

**C:**
- `<leader>bb` → compile (auto-detects `clang`/`gcc`)
- `<leader>br` → compile and run

**C++:**
- `<leader>bb` → compile (auto-detects `clang++`/`g++`)
- `<leader>br` → compile and run

**Haskell:**
- `<leader>bb` → build (auto-detects `stack`/`cabal`/`ghc`)
- `<leader>br` → run
- `<leader>bt` → test

**Java (Maven / Gradle):**
- `<leader>bb` → `gradlew build` / `mvnw package` (falls back to `gradle`/`mvn`)
- `<leader>br` → `gradlew run` / `mvnw exec:java` (falls back to single-file `java <File>.java`)
- `<leader>bt` → `gradlew test` / `mvnw test`

## Sessions

Auto-saves when you quit, auto-restores when you open Neovim in the same directory.

- `<leader>sr` → search/restore sessions
- `<leader>sw` → save current session
- `<leader>sd` → delete session

## Terminal

- `<leader>tt` → new split terminal (bottom, 15 lines)
- `<leader>tT` → new terminal in current buffer (no split)
- `:TermNew [cmd]` → same as `<leader>tt`
- `:TermHere [cmd]` → same as `<leader>tT`
- `:term` / `:terminal` → aliased to `:TermNew`
- Terminals auto-close when the process exits — no "Process exited 0" noise.
- `<Esc><Esc>` → leave terminal insert mode
- `<S-h>` / `<S-l>` → switch buffers from terminal mode
- Tab keys work in terminal mode too

## Navigation

- `<leader>ff` → files
- `<leader>fb` → buffers
- `<leader>fg` → live grep
- `<leader>fC` → commands
- `<leader>fs` → document symbols
- `<leader>fS` → workspace symbols
- `<leader>fh` → help tags

## Tabs

- `<leader>th` / `<leader>tl` → prev/next tab
- `<leader>to` / `<leader>tx` → new/close tab
- `gt` / `gT` → next/prev tab (works in terminal mode)

## Harpoon

- `<leader>ha` → add file
- `<leader>hh` → menu
- `<leader>1` to `<leader>4` → jump to pinned files

## Git

- `<leader>gg` → LazyGit (bottom split, auto-closes)

## Web Search

- `<leader>ww` → prompts for a query, opens DuckDuckGo in default browser
- `:WebSearch query` → same, inline

## OpenCode

- `<leader>oc` → opens opencode in a bottom terminal

## Testing

- `<leader>tm` → nearest test
- `<leader>tf` → file tests
- `<leader>ts` → test summary

Adapters: `neotest-rust`, `neotest-python`, `neotest-haskell`, `neotest-jest`

## Python & uv

- Auto-detects `./.venv` and activates on file open
- `<leader>vs` → select env
- `<leader>vp` → project `.venv`
- `<leader>vc` → cached env
- `<leader>vi` → show active env
- `<leader>vu` → `uv sync`

## Formatters

| Filetype     | Formatter            |
| ------------ | -------------------- |
| Rust         | `rustfmt`            |
| C / C++      | `clang_format`       |
| Haskell      | `fourmolu`           |
| Java         | `google-java-format` |
| Python       | `ruff_format`/`black`|
| Lua          | `stylua`             |
| JS/TS/JSON   | `prettierd`/`prettier`|
| Markdown     | `prettierd`/`prettier`|
| Typst        | `typstyle`           |

`<leader>lf` or `:Format` → format current buffer

## Language Servers

`cssls`, `clangd`, `hls`, `denols`, `intelephense`, `jdtls`, `lua_ls`, `marksman`, `pyright`, `rust_analyzer` (from toolchain), `tinymist`, `ts_ls`

## Shell

- Windows: `nushell` (fallback `powershell`, then `cmd`)
- Linux: `fish` (fallback `$SHELL`)

## Speed

- `vim-wakatime` deferred to `CursorHold` (not startup)
- `nvim-notify` loads on `VeryLazy`
- `Comment.nvim`, `gitsigns`, `autopairs`, `todo-comments` all lazy-loaded on file events
- `mason.nvim` only loads on `:Mason`
- `no-neck-pain.nvim` loads at startup but defers auto-enable with `safe`

## Notes

- Background is fully transparent — your terminal emulator provides the color.
- Statusline uses a custom theme that pulls colors from the active colorscheme (no hardcoded gruvbox).
- Right side of statusline shows ジュジュ.
- `legendary.nvim` skipped — upstream archived April 2025.
- This is plain Neovim, not LunarVim.
