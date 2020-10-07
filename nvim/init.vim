let mapleader = ';'

" SYSTEM {{{
set shell=pwsh shellquote= shellpipe=\| shellxquote=
set shellcmdflag=-NoLogo\ -NoProfile\ -ExecutionPolicy\ RemoteSigned\ -Command
set shellredir=\|\ Out-File\ -Encoding\ UTF8
"}}}

" PLUGINS {{{
"call plug#begin('~/.local/share/nvim/plugged')
"
"Plug 'tpope/vim-fugitive'
"Plug 'editorconfig/editorconfig-vim'
"Plug 'dcharbon/vim-flatbuffers'
"
"call plug#end()
"
"let g:EditorConfig_exclude_patterns = ['fugitive://.*']
"}}}

" (disabled) PLUGIN SETTINGS {{{
"
""coc.vim
"" Use tab for trigger completion with characters ahead and navigate.
"" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
"         \ pumvisible() ? "\<C-n>" :
"         \ <SID>check_back_space() ? "\<TAB>" :
"         \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
"
"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
"" Coc only does snippet and additional edit on confirm.
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"
"" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"" Remap keys for gotos
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"      execute 'h '.expand('<cword>')
"   else
"      call CocAction('doHover')
"   endif
"endfunction
"
"" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" Remap for rename current word
"nmap <leader>rn <Plug>(coc-rename)
"
"" Remap for format selected region
"xmap <leader>f <Plug>(coc-format-selected)
"nmap <leader>f <Plug>(coc-format-selected)
"
"" Using CocList
"" Show all diagnostics
"nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
"" Manage extensions
"nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
"" Show commands
"nnoremap <silent> <space>c :<C-u>CocList commands<cr>
"" Find symbol of current document
"nnoremap <silent> <space>o :<C-u>CocList outline<cr>
"" Search workspace symbols
"nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
"
"" color scheme
"let g:gruvbox_contrast_dark = 'hard'
"colorscheme gruvbox
""}}}

" GENERAL {{{
" global
set number
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab

" search
set incsearch
set ignorecase

" disable mouse
set mouse=

" no additional files
set nobackup
set noswapfile
set noundofile

" clipboard
set clipboard=unnamed

" highlight chars
set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
set list

" statusline
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\ [ASCII\ 0x%B]
set statusline+=\ [%{&filetype}]
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ 

"}}}

" FILE {{{
autocmd BufNewFile * set fileformat=unix
autocmd BufNewFile * set fileencoding=utf-8

""" => // comment in json
""autocmd FileType json syntax match Comment +\/\/.\+$+

" => Inconsistent default encoding behavior in Windows Powershell
" <https://stackoverflow.com/questions/40098771/changing-powershells-default-output-encoding-to-utf-8>
autocmd BufRead,BufNewFile *.ps1,*.psm1 setfiletype ps1

augroup rust
   autocmd BufReadPre *.rs set noet ts=4 sw=4
augroup END

""augroup clang
""   autocmd BufRead,BufNewFile *.c,*.h set path=.,include,../include,c:/raylib/raylib/src
""augroup END

function SetMakeCpp()
   set makeprg=clang++\ -std=c++17\ -o\ demo.exe\ %:p
endfunction

augroup cpp
   autocmd BufRead,BufNewFile *.c,*.cpp call SetMakeCpp()
augroup end

augroup winbatch
   autocmd BufRead,BufNewFile *.bat,*.cmd set fileformat=dos
augroup end
"}}}

" KEY MAPPINGS {{{

" => movement
tnoremap <C-h> <C-\><C-N><C-w>h
tnoremap <C-j> <C-\><C-N><C-w>j
tnoremap <C-k> <C-\><C-N><C-w>k
tnoremap <C-l> <C-\><C-N><C-w>l
inoremap <C-h> <C-\><C-N><C-w>h
inoremap <C-j> <C-\><C-N><C-w>j
inoremap <C-k> <C-\><C-N><C-w>k
inoremap <C-l> <C-\><C-N><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-s> :w<Return>

tnoremap <Esc> <C-\><C-n>

nnoremap <leader>sh :topleft vsplit<Return>
nnoremap <leader>sj :rightbelow vsplit<Return>
nnoremap <leader>sk :leftabove vsplit<Return>
nnoremap <leader>sl :botright vsplit<Return>

nnoremap <leader>sH :topleft split<Return>
nnoremap <leader>sJ :rightbelow split<Return>
nnoremap <leader>sK :leftabove split<Return>
nnoremap <leader>sL :botright split<Return>

"}}}

" vim:ts=3:sw=3:et:ft=vim:ff=unix:fdm=marker
