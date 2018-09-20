set number
set laststatus=2 "show filename

set expandtab "i add these 2018_2_21
set shiftwidth=4
set softtabstop=4
set tabstop=4

set autoindent
set smartindent

if has("autocmd")
    filetype plugin on
    filetype indent on
    autocmd BufRead,BufNewFile *.launch setfiletype xml
    "sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtab
    autocmd FileType tex    setlocal sw=2 sts=2 ts=2 et
endif

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap tree NERDTreeToggle

"dein Scripts-----------------------------
if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein')
    call dein#begin('~/.vim/dein')

    " Let dein manage dein
    " Required:
    call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')

    " Add or remove your plugins here:
    call dein#add('Shougo/neosnippet.vim')
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('Shougo/neocomplete.vim')
    call dein#add('Shougo/unite.vim')

    call dein#add('flazz/vim-colorschemes')
    call dein#add('tpope/vim-surround')

    call dein#add('scrooloose/nerdtree')

    " You can specify revision/branch/tag.
    call dein#add('Shougo/deol.nvim', { 'rev': '01203d4c9' })

    " Required:
    call dein#end()
    call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"match it plugin
set nocompatible
filetype plugin on
runtime macros/matchit.vim

" === gruvbox ===
colorscheme gruvbox
set background=dark
set t_Co=256
let g:lighline = { 'colorscheme': 'gruvbox' }
" === gruvbox ===
