set number
set laststatus=2      " show filename
set expandtab 
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
set smartindent
set backspace=2
set fileencoding=utf-8 " default file encoding

set undofile           " enable undo folder

function! Mkdir(path)
    if !isdirectory(a:path)
        call mkdir(a:path, 'p')
    endif
endfunction

if has("mac") || has("unix") 
    let tmpdirectory   =expand("~/.vim/tmp")
    let undodirectory  =expand("~/.vim/undo")
    let dein_dir       =expand('~/.vim/.cache/dein')
    let dein_plugin_dir=expand('~/.vim/.cache/dein/repos/github.com/Shougo/dein.vim')

    " Required for dein
    set runtimepath+=~/.vim/.cache/dein/repos/github.com/Shougo/dein.vim

elseif has("win64") || has("win32") || has("win32unix")
    let tmpdirectory   =expand("~/vimfiles/tmp")
    let undodirectory  =expand("~/vimfiles/undo")
    let dein_dir       =expand('~/vimfiles/cache/dein')
    let dein_plugin_dir=expand('~/vimfiles/cache/dein/repos/github.com/Shougo/dein.vim')

    " Required for dein
    set runtimepath+=~/vimfiles/cache/dein/repos/github.com/Shougo/dein.vim
endif

call Mkdir(tmpdirectory)
call Mkdir(undodirectory)

let &directory=tmpdirectory
let &backupdir=tmpdirectory
let &undodir=undodirectory

if has("autocmd")
    filetype plugin on
    filetype indent on
    autocmd BufRead,BufNewFile *.launch setfiletype xml
    autocmd BufRead,BufNewFile *.log    setlocal readonly
    "sw=shiftwidth, sts=softtabstop, ts=tabstop, et=expandtab
    autocmd FileType tex    setlocal sw=2 sts=2 ts=2 et
    autocmd BufRead,BufNewFile *.md  set filetype=markdown
endif

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap tree NERDTreeToggle
cnoremap md PrevimOpen

"dein Scripts-----------------------------
if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
if dein#load_state(dein_dir)
    call dein#begin(dein_dir)

    " Let dein manage dein
    " Required:
    call dein#add(dein_plugin_dir)

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

    call dein#add('lervag/vimtex')
    "call dein#add('thinca/vim-quickrun')
    
    " for Markdown
    call dein#add('tpope/vim-markdown')
    call dein#add('kannokanno/previm')
    call dein#add('tyru/open-browser.vim')

    " Required:
    call dein#end()
    call dein#save_state()
endif

" Required:
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"match it plugin
runtime macros/matchit.vim

" gruvbox
colorscheme gruvbox
set background=dark
set t_Co=256
let g:lighline = { 'colorscheme': 'gruvbox' }

" spell check highlight
hi clear SpellBad
hi SpellBad cterm=underline
" Set style for gVim
hi SpellBad gui=undercurl

" for latexmk
let g:vimtex_compiler_latexmk_engines = {
            \ 'background' : 0,
            \ 'build_dir' : '',
            \ 'continuous' : 1,
            \ 'options' : [
            \   '-pdfdvi',
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \ ],
            \}
"
" for bash on windows
set visualbell t_vb=

" for Markdown
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime = 1
