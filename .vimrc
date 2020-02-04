set number            " show line numbers
set laststatus=2      " show filename 

set tabstop=4
set softtabstop=0
set shiftwidth=0
set expandtab

set autoindent
set smartindent

set backspace=2
set fileencoding=utf-8 " default file encoding
set fileformat=unix    " default file format

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
    autocmd BufRead,BufNewFile *.md     setfiletype arkdown
    " ts=tabstop, sts=softtabstop, sw=shiftwidth, et=expandtab
    autocmd FileType tex setlocal ts=2 sts=0 sw=0 et
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

" for using tex snippet of neosnippet
let g:tex_flavor='latex'

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
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.tex = g:vimtex#re#neocomplete

" for not to ring warning bell on bash on windows
set visualbell t_vb=

" for Markdown
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime = 1

" =========== Setting for neocomplete =============
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

let g:neocomplete#max_list = 5

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" <TAB>: completion.
inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"

" Close popup by <Space> or <CR>.
inoremap <expr><Space> pumvisible() ? "\<C-y><Space>" : "\<Space>"
inoremap <expr><CR>    pumvisible() ? "\<C-y>" : "\<CR>"

" Enable omni completion.
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
" =========== End of Setting for neocomplete =============
"
" =========== neosnippet Setting =============
" " Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB>
\ pumvisible() ? "\<C-n>" :
\ neosnippet#expandable_or_jumpable() ?
\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
let g:neosnippet#enable_snipmate_compatibility = 1
" ========== End of neosnippet Setting ===========
