# Neovim Configuration Redesign Documentation

## 1. Objective

Redesign a **single Neovim instance** optimized for coding, professional document writing, and interactive learning of keybindings and commands. The focus is on:

* Minimalism and readability
* Single theme (Gruvbox) for comfort
* OS-specific shell integration
* Self-documenting keymaps and interactive command board
* Support for multiple programming and markup languages

---

## 2. Use Cases

* **Code editing:** ASM, Rust, C/C++, Python, JavaScript/TypeScript
* **Professional documents:** Markdown, Typst
* **Interactive learning:** Ability to see commands, keymaps, and plugin features on demand
* **Navigation & project management:** Fast fuzzy finding and symbol search

---

## 3. Features and Requirements

### 3.1 Visual & Reading Comfort

* Single theme: **Gruvbox**
* Soft wrapping and linebreaks for readability (Only for typst documents)
* Highlight current line, relative line numbers, and scroll offset for comfortable reading
* Folding support via Treesitter for code and document sections
* Conceal level for Markdown and LaTeX for clean visuals

### 3.2 Command Board & Keymaps

* **which-key.nvim** for a live popup of all keybindings
* **Telescope.nvim** for fuzzy file search, symbol search, and commands
* **Legendary.nvim (optional)** for a centralized interactive panel of commands, keymaps, and autocmds

### 3.3 Language Support

* **Programming:** Rust (`rust-analyzer`)[already in toolchain], C/C++ (`clangd`), Python (`pyright`), JS/TS (`ts-go`)
* **Markup:** Markdown (`vim-markdown` + `markdown-preview`), Typst (`typst-lsp`)

### 3.4 OS-Specific Shells

* **Windows:** PowerShell
* **Linux:** Fish shell
* Configured via Neovim’s `shell` and `shellcmdflag` options

### 3.5 Start Screen

* Customizable ASCII art as welcome screen
* Quick actions (new file, find file, live grep, help) accessible from start screen

### 3.6 Minimal Configuration Philosophy

* **Single-file `init.lua`** with inline plugin configuration(a way to shuffle through the files)
* Lazy-loading of plugins where appropriate
* Clear, annotated sections to act as a self-documenting board
* Avoid scattered config files to maintain simplicity and clarity

---

## 4. Plugin Stack Overview

| Purpose                       | Plugin                                                |
| ----------------------------- | ----------------------------------------------------- |
| Syntax highlighting & folding | `nvim-treesitter`                                     |
| LSP & autocompletion          | `nvim-lspconfig`, `mason.nvim`, `nvim-cmp`, `LuaSnip` |
| Fuzzy search & navigation     | `telescope.nvim`                                      |
| Harpoon                       | `telescope.nvim`                                      |
| Keybinding hints              | `which-key.nvim`                                      |
| Markdown support              | `vim-markdown`, `markdown-preview.nvim`               |
| Start screen                  | `dashboard-nvim`                                      |
| Optional command board        | `legendary.nvim`                                      |
| Git intergration              | `lazygit.exe`                                      |
| Notification System           | `vim notify`                                      |

---

## 5. User Interaction Flow

1. Launch Neovim → ASCII art welcome screen with commands
2. Use `<leader>` to see which-key popup for keymaps
3. Open files or search symbols using Telescope
4. Edit code or documents with LSP support and Treesitter syntax folding (for typst files)
5. switch between files with harpoon.
5. Preview Markdown/LaTeX as needed

---

## 6. Customization Notes

* All configurations, keymaps, and plugin setups are **documented inline** for reference
* Users can replace ASCII art in the dashboard for personal branding
* Shell integration ensures consistent terminal behavior on both Windows and Linux

