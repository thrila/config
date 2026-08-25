return {
  "nvim-mini/mini.nvim",
  version = false,
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    -- Comments
    require("mini.comment").setup {
      -- Options which control module behavior
      options = {
        -- custom_commentstring = nil, -- Function to compute custom 'commentstring' (optional)
        ignore_blank_line = false, -- Whether to ignore blank lines when commenting
        start_of_line = false, -- Whether to ignore blank lines in actions and textobject
        pad_comment_parts = true, -- Whether to force single space inner padding for comment parts
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        -- -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- comment = 'gc',        -- Normal and Visual modes
        -- comment_line = 'gcc',  -- Toggle comment on current line
        -- comment_visual = 'gc', -- Toggle comment on visual selection
        -- -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        -- -- Works also in Visual mode if mapping differs from `comment_visual`
        -- textobject = 'gc',
      },
      -- Hook functions to be executed at certain stage of commenting
      hooks = {
        -- -- Before successful commenting. Does nothing by default.
        -- pre = function() end,
        -- -- After successful commenting. Does nothing by default.
        -- post = function() end,
      },
    }

    -- Surround
    require("mini.surround").setup {
      -- Add custom surroundings to be used on top of builtin ones. For more
      -- information with examples, see `:h MiniSurround.config`.
      custom_surroundings = nil,

      -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
      highlight_duration = 500,

      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "sh", -- Highlight surrounding
        replace = "sr", -- Replace surrounding

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },

      -- Number of lines within which surrounding is searched
      n_lines = 20,

      -- Whether to respect selection type:
      -- - Place surroundings on separate lines in linewise mode.
      -- - Place surroundings on each line in blockwise mode.
      respect_selection_type = false,

      -- How to search for surrounding (first inside current line, then inside
      -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
      -- see `:h MiniSurround.config`.
      search_method = "cover",

      -- Whether to disable showing non-error feedback
      -- This also affects (purely informational) helper messages shown after
      -- idle time if user input is required.
      silent = false,
    }

    -- SplitJoin
    require("mini.splitjoin").setup {
      -- Module mappings. Use `''` (empty string) to disable one.
      -- Created for both Normal and Visual modes.
      mappings = {
        -- toggle = 'gS',
        toggle = "", -- disable default mapping
        split = "sk",
        join = "sj",
      },

      -- Detection options: where split/join should be done
      detect = {
        -- Array of Lua patterns to detect region with arguments.
        -- Default: { '%b()', '%b[]', '%b{}' }
        brackets = nil,

        -- String Lua pattern defining argument separator
        separator = ",",

        -- Array of Lua patterns for sub-regions to exclude separators from.
        -- Enables correct detection in presence of nested brackets and quotes.
        -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
        exclude_regions = nil,
      },

      -- Split options
      split = {
        hooks_pre = {},
        hooks_post = {},
      },

      -- Join options
      join = {
        hooks_pre = {},
        hooks_post = {},
      },
    }

    -- Clue (Which key)
    require("mini.clue").setup {
      triggers = {
        -- Leader triggers
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },

        -- Built-in completion
        { mode = "i", keys = "<C-x>" },

        -- `g` key
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },

        -- Marks
        { mode = "n", keys = "'" },
        { mode = "n", keys = "`" },
        { mode = "x", keys = "'" },
        { mode = "x", keys = "`" },

        -- Registers
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },

        -- Window commands
        { mode = "n", keys = "<C-w>" },

        -- `z` key
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },

        -- `s` key (split&join, surround etc)
        { mode = "n", keys = "s" },
        { mode = "v", keys = "s" },

        { mode = "n", keys = "]" },
        { mode = "v", keys = "]" },

        { mode = "n", keys = "[" },
        { mode = "v", keys = "[" },
      },

      clues = {

        { mode = "n", keys = "<Leader>f", desc = "+Find (Telescope)" },
        { mode = "n", keys = "<Leader>x", desc = "+Trouble (Todo)" },
        { mode = "n", keys = "<Leader>g", desc = "+Git" },
        { mode = "n", keys = "<Leader>w", desc = "+Window" },
        { mode = "n", keys = "<Leader>c", desc = "+Code (LSP)" },
        { mode = "n", keys = "<Leader>s", desc = "+Search" },
        { mode = "n", keys = "<Leader>d", desc = "+Debugger" },
        { mode = "n", keys = "<Leader>u", desc = "+ui" },

        -- Built-in completion clues
        require("mini.clue").gen_clues.builtin_completion(),

        -- `g` key clues (e.g., for goto commands like g~, gu, gU)
        require("mini.clue").gen_clues.g(),

        -- Marks clues (e.g., for jumping to marks with ' or `)
        require("mini.clue").gen_clues.marks(),

        -- Registers clues (e.g., for yanking/pasting with ")
        require("mini.clue").gen_clues.registers(),

        -- Window commands clues (e.g., <C-w>h to move left)
        require("mini.clue").gen_clues.windows(),

        -- `z` key clues (e.g., for folding like zR to open all folds)
        require("mini.clue").gen_clues.z(),

        require("mini.clue").gen_clues.square_brackets(),
      },

      window = { delay = 70, config = { width = "auto" } },
    }

    -- Picker (File explorer)
    require("mini.pick").setup {
      -- Delays (in ms; should be at least 1)
      delay = {
        -- Delay between forcing asynchronous behavior
        async = 10,

        -- Delay between computation start and visual feedback about it
        busy = 50,
      },

      -- Keys for performing actions. See `:h MiniPick-actions`.
      mappings = {
        caret_left = "<Left>",
        caret_right = "<Right>",

        choose = "<CR>",
        choose_in_split = "<C-s>",
        choose_in_tabpage = "<C-t>",
        choose_in_vsplit = "<C-v>",
        choose_marked = "<M-CR>",

        delete_char = "<BS>",
        delete_char_right = "<Del>",
        delete_left = "<C-u>",
        delete_word = "<C-w>",

        mark = "<C-x>",
        mark_all = "<C-a>",

        move_down = "<C-j>",
        move_start = "<C-g>",
        move_up = "<C-k>",

        paste = "<C-r>",

        refine = "<C-Space>",
        refine_marked = "<M-Space>",

        scroll_down = "<C-f>",
        scroll_left = "<C-h>",
        scroll_right = "<C-l>",
        scroll_up = "<C-b>",

        stop = "<Esc>",

        toggle_info = "<S-Tab>",
        toggle_preview = "<Tab>",
      },

      -- General options
      options = {
        -- Whether to show content from bottom to top
        content_from_bottom = false,

        -- Whether to cache matches (more speed and memory on repeated prompts)
        use_cache = false,
      },

      -- Source definition. See `:h MiniPick-source`.
      source = {
        items = nil,
        name = nil,
        cwd = nil,

        match = nil,
        show = nil,
        preview = nil,

        choose = nil,
        choose_marked = nil,
      },

      -- Window related options
      window = {
        -- Float window config (table or callable returning it)
        config = nil,

        -- String to use as caret in prompt
        prompt_caret = "▏",

        -- String to use as prefix in prompt
        prompt_prefix = "> ",
      },
    }

    -- Highlight
    require("mini.cursorword").setup {
      -- Delay (in ms) between when cursor moved and when highlighting appeared
      delay = 101,
    }

    -- Mini diff
    require("mini.diff").setup()
  end,
}
