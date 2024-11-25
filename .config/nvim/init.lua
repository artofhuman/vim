-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { 
      "shaunsingh/nord.nvim", 
      config = function()
        vim.g.nord_bold = false
        vim.g.nord_italic = false
        vim.g.nord_disable_background = true
        vim.g.nord_borders = false

        -- vim.cmd[[colorscheme nord]]
  
        -- nord fixes
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3b4252", underline = false, bold = false })
      end
    },
  
    { 
      'olivercederborg/poimandres.nvim',
      lazy = false,
      priority = 1000,
      config = function()
        require('poimandres').setup {
          -- leave this setup function empty for default config
          -- or refer to the configuration section
          -- for configuration options
          disable_background = true
        }
      end,

      -- optionally set the colorscheme within lazy config
      init = function()
        -- vim.cmd("colorscheme poimandres")
      end
    },
  
    { 
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
        require("rose-pine").setup({
          variant = "moon",
          styles = {
            bold = false,
            italic = false,
            transparency = true,
          },
        })
      end
    },

    -- {
    --   'jesseleite/nvim-noirbuddy',
    --   dependencies = {
    --     { 'tjdevries/colorbuddy.nvim' }
    --   },
    --   lazy = false,
    --   priority = 1000,
    --   opts = {
    --     preset = "slate"
    --     -- All of your `setup(opts)` will go here
    --   },
    -- },

    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        transparent = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        }
      },
    },
  
    { "savq/melange-nvim" },

    -- save my last cursor position
    {
      "ethanholz/nvim-lastplace",
      config = function()
        require("nvim-lastplace").setup({
          lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
          lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
          lastplace_open_folds = true
        })
      end,
    },

    -- Highlight, edit, and navigate code
    { 
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      build = ":TSUpdate",
      config = function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = {
            'proto',
            'lua',
            'ruby',
            'python',
            'vimdoc',
            'vim',
            'bash',
            'json',
            'markdown',
            'markdown_inline',
          },
          indent = { enable = false },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<space>", -- maps in normal mode to init the node/scope selection with space
              node_incremental = "<space>", -- increment to the upper named parent
              node_decremental = "<bs>", -- decrement to the previous node
              scope_incremental = "<tab>", -- increment to the upper scope (as defined in locals.scm)
            },
          },
          autopairs = {
            enable = true,
          },
          highlight = {
            enable = true,

            -- Disable slow treesitter highlight for large files
            -- disable = function(lang, buf)
            --   local max_filesize = 100 * 1024 -- 100 KB
            --   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            --   if ok and stats and stats.size > max_filesize then
            --     return true
            --   end
            -- end,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
                ["iB"] = "@block.inner",
                ["aB"] = "@block.outer",
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                [']]'] = '@function.outer',
              },
              goto_next_end = {
                [']['] = '@function.outer',
              },
              goto_previous_start = {
                ['[['] = '@function.outer',
              },
              goto_previous_end = {
                ['[]'] = '@function.outer',
              },
            },
            swap = {
              enable = true,
              swap_next = {
                ['<leader>sn'] = '@parameter.inner',
              },
              swap_previous = {
                ['<leader>sp'] = '@parameter.inner',
              },
            },
          },
        })
      end,
    }, 

    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = true,
      opts = {
        check_ts = true,
      }
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
    },

      -- fuzzy finder framework
    {
      "nvim-telescope/telescope.nvim", 
      tag = '0.1.8',
      lazy = true,
      dependencies = { 
        "nvim-lua/plenary.nvim" ,
        "nvim-tree/nvim-web-devicons",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
      },
      config = function ()
        local actions = require('telescope.actions')
        local telescope = require("telescope")
        telescope.setup({
          defaults = {
            file_ignore_patterns = {
              "*.pyc",
            },
            -- layout_strategy='vertical',
            -- layout_config={width=0.6},
            mappings = {
              i = {
                ["<ESC>"]   = actions.close,
              }
            },
          },
          extensions = {
            fzf = {
              fuzzy = true,                    -- false will only do exact matching
              override_generic_sorter = true,  -- override the generic sorter
              override_file_sorter = true,     -- override the file sorter
              case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                               -- the default case_mode is "smart_case"
            }
          },
        })
    
        -- To get fzf loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        telescope.load_extension('fzf')
        telescope.load_extension("live_grep_args")
        -- To get ui-select loaded and working with telescope, you need to call
        -- load_extension, somewhere after setup function:
        telescope.load_extension("ui-select")
      end,
    },

    -- file explorer
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()

        -- disable netrw (built-in nvim file tree)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
          disable_netrw = false, -- again, disabling netrw
          hijack_cursor = true, -- keeps the cursor on the first letter of filename while navigating
          sort_by = "case_sensitive",
          view = {
            -- side = "right",
            width = 40,
          },
          filters = {
            dotfiles = false,
          },
          renderer = {
            highlight_git = true,
          },
          on_attach = function(bufnr)
            local api = require('nvim-tree.api')

            local function opts(desc)
              return {
                desc = 'nvim-tree: ' .. desc,
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true,
              }
            end

            api.config.mappings.default_on_attach(bufnr)

            vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
            vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))
            vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
          end
        })
      end,
    },
  
    -- completions
    {
      "hrsh7th/nvim-cmp",
      dependencies = { 
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip'
      },
      config = function()
      	local cmp = require("cmp")
      	local luasnip = require("luasnip")
      	local cmp_autopairs = require("nvim-autopairs.completion.cmp")

        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    
        luasnip.config.setup {}
         require('cmp').setup({
           snippet = {
             expand = function(args)
               luasnip.lsp_expand(args.body)
             end,
           },
           sources = {
             { name = 'nvim_lsp' },
             { 
               name = "buffer",
               options = {
                 get_bufnrs = function()
                   return vim.api.nvim_list_bufs()
                 end
               }
             },
             { name = "luasnip" },
             { name = "path" },
           },

           mapping = cmp.mapping.preset.insert {
             ['<C-n>'] = cmp.mapping.select_next_item(),
             ['<C-p>'] = cmp.mapping.select_prev_item(),
             ['<C-d>'] = cmp.mapping.scroll_docs(-4),
             ['<C-f>'] = cmp.mapping.scroll_docs(4),
             ['<CR>'] = cmp.mapping.confirm { select = true },
             ['<Tab>'] = cmp.mapping(function(fallback)
               if cmp.visible() then
                 cmp.select_next_item()
               elseif luasnip.expand_or_locally_jumpable() then 
                 luasnip.expand_or_jump()
               elseif has_words_before() then
                 cmp.complete()
               else
                 fallback()
               end
             end, { 'i', 's' }),
           },
           view = {
             entries = {
               name = "custom",
               selection_order = "near_cursor",
             },
           },
         })
      end
    },
  
    {
      "neovim/nvim-lspconfig",
      config = function ()
        local capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        require'lspconfig'.pyright.setup{}
        require'lspconfig'.solargraph.setup{}
      end
    },

    { 'bogado/file-line' },
  
    -- git staff
    -- git browse
    {
      "linrongbin16/gitlinker.nvim",
      cmd = "GitLink",  -- open by defaut in browse
      config = function ()
        require('gitlinker').setup({
          router = {
            browse = {
              ["^git%.skbkontur%.ru"] = require('gitlinker.routers').gitlab_browse,
            },
          }
        })
      end
    },

    {
      'sindrets/diffview.nvim'
    },

    {
      'tpope/vim-fugitive'
    },
    ---
  },
  
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})



-- vim.cmd[[colorscheme nord]]

-- Settings
vim.g.mapleader = ","
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.number = true        -- Show line numbers
vim.opt.splitright = true    -- Split windows right to the current windows
vim.opt.splitbelow = true    -- Split windows below to the current windows
vim.opt.autochdir = false -- Change CWD when I open a file

vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'  -- Copy/paste to system clipboard
vim.opt.swapfile = false           -- Don't use swapfile
vim.opt.ignorecase = true          -- Search case insensitive...
vim.opt.smartcase = true           -- ... but not it begins with upper case 

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"

-- Indent Settings
vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2    -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2       -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true

vim.wo.wrap = false

vim.opt.laststatus = 0 -- removing statusline
vim.opt.updatetime = 500 -- trigger cursorhold event faster.
vim.opt.scrolloff = 8 -- annoying scroll fix
vim.opt.signcolumn = "yes" -- show sign column so that text doesn't shift


vim.keymap.set('n', '<Leader>w', ':write!<CR>') -- Fast saving
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR>') -- Disable search

-- Don't jump forward if I higlight and search for a word
local function stay_star()
  local sview = vim.fn.winsaveview()
  local args = string.format("keepjumps keeppatterns execute %q", "sil normal! *")
  vim.api.nvim_command(args)
  vim.fn.winrestview(sview)
end
vim.keymap.set('n', '*', stay_star, {noremap = true, silent = true})

local function add_debug()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "import pdb; pdb.set_trace()" })
end
vim.keymap.set('n', '<Leader>d', add_debug, {noremap = true, silent = true}) -- Set debug point
-- rename the word under the cursor 
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Better split switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- Terminal (not sure I need this)
-- Open terminal in vertical and horizontal split
-- vim.keymap.set('n', '<leader>tv', '<cmd>vnew term://zsh<CR>', { noremap = true })
-- vim.keymap.set('n', '<leader>ts', '<cmd>split term://fish<CR>', { noremap = true })

-- Folding

vim.o.foldmethod = 'indent'
-- vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
-- nmap <space> za

-- Telescope
local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-b>', builtin.buffers, {})
vim.keymap.set('n', '<C-g>', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>r', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>rg', builtin.grep_string, {})
vim.keymap.set('n', '<leader>gg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", {})
-- vim.keymap.set('n', '<leader>s', builtin.lsp_document_symbols, {})

-- File-tree mappings
vim.keymap.set('n', '<BS>', ':NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('n', '<C-e>', ':NvimTreeFindFile!<CR>', { noremap = true })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>v', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>s', "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts)

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

require'nvim-web-devicons'.setup {
  color_icons = false;
}

local icons = require("nvim-web-devicons")
local GRAY = "#80838f"
local FADED_GRAY = "#33373a"
local STRONG_FADED_GRAY = "#2a2d30"

-- change color of icons
local new_icons = {}
for key, icon in pairs(icons.get_icons()) do
icon.color = GRAY
new_icons[key] = icon
-- overrides["BufferLineDevIcon" .. icon.name] = { bg = BG, fg = FADED_GRAY } -- unactive tabs to faded gray
-- overrides["BufferLineDevIcon" .. icon.name .. "Selected"] = { bg = BG, fg = GRAY } -- active tabs to gray
end
icons.set_icon(new_icons)


vim.cmd("colorscheme rose-pine-moon")
