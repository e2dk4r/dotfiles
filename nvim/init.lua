-- normal
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.autoread = true

-- status line
vim.opt.laststatus=2
vim.opt.statusline='%<%f %h%m%r%=[0x%B][%{&filetype} %{&fileencoding}][%(%.l,%c%V%) %P]'

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true

-- color
vim.opt.termguicolors = true
--vim.cmd.colorscheme('habamax')
vim.cmd.colorscheme('gruvbox')

-- clipboard
vim.keymap.set('n', '<space>y', '"+y')
vim.keymap.set('n', '<space>p', '"+p')
vim.keymap.set('n', '<space>yp', ':let @+ = expand("%") . ":" . line(".") | echo "relative path copied"<CR>')

-- diagnostic
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next) 

-- shortcuts
vim.keymap.set('n', '<c-k>', ':silent !clang-format -i %<CR>')
vim.keymap.set('n', '<c-j>', ':write<CR>')
vim.keymap.set('n', '<c-l>', ':make<CR>')

-- command abbreviations
vim.cmd.cnoreabbrev('git Git')
vim.cmd.cnoreabbrev('Make make')
vim.cmd.cnoreabbrev('amek make')
vim.cmd.cnoreabbrev('amke make')
vim.cmd.cnoreabbrev('man Man')

-- insert abbreviations
vim.cmd.iabbrev('todo: TODO:')
vim.cmd.iabbrev('fixme: FIXME:')
vim.cmd.iabbrev('note: NOTE:')

-- treesitter
vim.treesitter.language.add('tsq',        { path = "/usr/lib64/libtree-sitter-tsq.so" })
vim.treesitter.language.add('c',          { path = "/usr/lib64/libtree-sitter-c.so"          })
vim.treesitter.language.add('html',       { path = "/usr/lib64/libtree-sitter-html.so"       })
vim.treesitter.language.add('css',        { path = "/usr/lib64/libtree-sitter-css.so"        })
vim.treesitter.language.add('javascript', { path = "/usr/lib64/libtree-sitter-javascript.so" })
require('nvim-treesitter.configs').setup({
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  }
})

-- lsp
local lspzero = require('lsp-zero')
lspzero.preset('recommended')
lspzero.setup()

local lspconfig = require('lspconfig')
lspconfig.clangd.setup {}
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<c-k>', vim.lsp.buf.format, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>a', vim.lsp.buf.code_action, opts)
  end,
})

-- telescope
require('telescope').load_extension('fzf')
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<space>g', telescope.live_grep, {})
vim.keymap.set('n', '<space>f', telescope.find_files, {})
vim.keymap.set('n', '<space>b', telescope.buffers, {})
vim.keymap.set('n', '<space>h', telescope.help_tags, {})
vim.keymap.set('n', '<space>s', telescope.lsp_document_symbols, {})
vim.keymap.set('n', '<space>S', telescope.lsp_workspace_symbols, {})
vim.keymap.set('n', '<space>d', telescope.diagnostics, {})
vim.keymap.set('n', '<space>t', telescope.treesitter, {})

-- events
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = function(ev)
    -- meson
    if vim.fn.filereadable('meson.build') == 1 and vim.fn.isdirectory('build/') then
      vim.o.makeprg = 'ninja -j0 -C build/'
    end
  end
})
