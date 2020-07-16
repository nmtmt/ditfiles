set number         " show line numbers
set laststatus=2   " show filename 
set ruler          " show cursor info and window percentage
"set rulerformat=%-3(%P%) " only show percentage ...not work well

set tabstop=4
set softtabstop=-1 " same as ts
set shiftwidth=0   " same as ts
set expandtab      " use space in stead of tab

set autoindent  
set smartindent " C-like indent. enabled when autoindent is on
" set cindent

set backspace=2
set encoding=utf-8            " vim internal encoding
set fileencodings=utf-8,cp932 " default encoding on file reading
set fileencoding=utf-8        " default encoding on file writing
set fileformat=unix           " default file format
scriptencoding utf-8          " this vim file's encoding. must be below the fileformat line

set spelllang=en,cjk   " disable spell check words in Japanese
set wildmenu           " commamd mode completion
set wildmode=longest:full " setting for command line mode completion
set undofile           " enable undo folder

" not show preview window with word completion
set completeopt=menuone,noselect
" show preview window with word completion
" set completeopt=menuone,preview
set previewheight=2

set nrformats="alpha" " disable octal, enable alphabet incremental

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

elseif has("win64") || has("win32") || has("win32unix")
  let tmpdirectory   =expand("~/vimfiles/tmp")
  let undodirectory  =expand("~/vimfiles/undo")
  let dein_dir       =expand('~/vimfiles/cache/dein')
  let dein_plugin_dir=expand('~/vimfiles/cache/dein/repos/github.com/Shougo/dein.vim')
endif

call Mkdir(tmpdirectory)
call Mkdir(undodirectory)

let &directory=tmpdirectory
let &backupdir=tmpdirectory
let &undodir=undodirectory

if has("autocmd")
  filetype plugin on
  filetype indent on
  autocmd BufRead,BufNewFile *.launch   setfiletype xml
  autocmd BufRead,BufNewFile *.md,*.mkd setfiletype markdown
  autocmd BufRead,BufNewFile *.php      setfiletype html
  autocmd BufRead,BufNewFile *.log      setlocal readonly
  autocmd BufRead,BufNewFile .gitignore setfiletype gitignore
  autocmd FileType text NeoCompleteLock
  " ts=tabstop, sts=softtabstop, sw=shiftwidth, et=expandtab
  autocmd FileType text,tex,markdown,html,xml,vim,json setlocal ts=2 sts=-1 sw=0 et
  " fo=formatoptions, com=comments
  autocmd FileType text,tex,markdown,json setlocal spell
  " autocmd FileType text setlocal fo+=nr fo-=c com-=fb:-,fb:* com+=b:-,b:*
  autocmd FileType text setlocal fo+=nr com-=fb:-,fb:* com+=b:-,b:*
  autocmd FileType qf 3wincmd_ " set quickfix window height to 3
  autocmd InsertLeave * if pumvisible() == 0|pclose|endif " close preview window on leavning insert mode
endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" install dein if not installed
if match( &runtimepath, '/dein.vim' ) == -1
  if !isdirectory(dein_plugin_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' dein_plugin_dir
  endif
  let &runtimepath .= ','.expand(dein_plugin_dir)
endif

let use_deoplete=0
if ((has('nvim')  || has('timers')) && has('python3')) && system('pip3 show neovim') !=# ''
  let use_deoplete=1
endif
" Required:
if dein#load_state(dein_dir)
  call dein#begin(dein_dir)

  " Let dein manage dein
  " Required:
  call dein#add(dein_plugin_dir)

  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/deoplete.nvim')
  if !has('nvim') " for deoplete on vim8
    call dein#add('roxma/nvim-yarp')
    call dein#add('roxma/vim-hug-neovim-rpc')
  endif

  call dein#add('Shougo/unite.vim')

  call dein#add('flazz/vim-colorschemes')
  call dein#add('tpope/vim-surround')
  call dein#add('tpope/vim-obsession')

  call dein#add('scrooloose/nerdtree')

  " enable paste mode when paste with clipboard
  call dein#add('ConradIrwin/vim-bracketed-paste')

  call dein#add('lervag/vimtex')
  call dein#add('thinca/vim-quickrun')
  
  " for Markdown
  " call dein#add('tpope/vim-markdown')
  call dein#add('godlygeek/tabular')
  call dein#add('plasticboy/vim-markdown')
  call dein#add('kannokanno/previm')
  call dein#add('tyru/open-browser.vim')

  call dein#add('elzr/vim-json') " check json syntax

  " load my snippets
  call dein#add('nmtmt/winresizer') " for resizing window
  call dein#add('nmtmt/neosnippet-snippets')
  call dein#add('nmtmt/mdvimtex')
  let &runtimepath .= ','. dein_dir . "/repos/github.com/nmtmt/mdvimtex"

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

if len(dein#check_clean()) " if there are plugins to be removed
  call map(dein#check_clean(), "delete(v:val, 'rf')")
  call dein#recache_runtimepath()
  source $MYVIMRC " reload .vimrc
endif

"End dein Scripts-------------------------

" cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap tree<TAB> NERDTreeToggle
cnoremap md<TAB> PrevimOpen
cnoremap recache silent execute '!hash -r' <bar> call dein#recache_runtimepath() <bar> source $MYVIMRC

" enable filtering using ctrl-p or ctrl-n
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

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
let g:vimtex_compiler_latexmk = {
            \ 'background' : 1,
            \ 'build_dir' : './build',
            \ 'continuous' : 1,
            \ 'options' : [
            \   '-pdfdvi',
            \   '-verbose',
            \   '-file-line-error',
            \   '-synctex=1',
            \   '-interaction=nonstopmode',
            \ ],
            \}
if has("mac")
  let g:vimtex_view_method = 'skim'
endif

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.tex = g:vimtex#re#neocomplete

" for not to ring warning bell on bash on windows
set visualbell t_vb=

" for Markdown
let g:vim_markdown_folding_disabled=1
let g:previm_enable_realtime = 1

set splitright " open new window on right side
set splitbelow " open new window below the current one
let g:quickrun_config = {
      \'*': { 'outputter/buffer/split': ':40vsplit'},
      \'python': {'command': 'python3'}, 
      \}

let g:acp_enableAtStartup = 0 " Disable AutoComplPop.     

if use_deoplete
  " =========== deoplete setting ============
  let g:deoplete#enable_at_startup = 1
  call deoplete#custom#option({
        \'auto_complete_delay':50,
        \'auto_complete_popup':"auto",
        \'max_list':8,
        \'min_pattern_length':2,
        \'skip_chars':['(', ')', ','],
        \})
  " =========== deoplete setting ============
else
  " =========== Setting for neocomplete =============
  let g:neocomplete#enable_at_startup = 1  " Use neocomplete.
  let g:neocomplete#enable_smart_case = 0  " Use smartcase.

  let g:neocomplete#sources#syntax#min_keyword_length = 3 " Set minimum syntax keyword length.
  let g:neocomplete#max_list = 8

  let g:neocomplete#auto_completion_start_length = 3
  let g:neocomplete#auto_complete_delay = 0

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

  " =========== End of Setting for neocomplete =============
endif

" <TAB>: completion.
" inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"

" Close popup by <Space> or <CR>.
inoremap <expr><Space> pumvisible() ? "\<C-y><Space>" : "\<Space>"
"inoremap <expr><CR>    pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr><CR>    pumvisible() ? "\<C-y><CR>" : "\<CR>"
inoremap <expr><TAB>   pumvisible() ? "\<C-y><TAB>" : "\<TAB>"

" =========== neosnippet Setting =============
" " Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><TAB>
      \ neosnippet#jumpable() ?
      \    "\<Plug>(neosnippet_jump)" : "\<TAB>"
smap <expr><TAB> 
      \ neosnippet#jumpable() ?
      \ "\<Plug>(neosnippet_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  " set conceallevel=2 concealcursor=niv
  set conceallevel=0 concealcursor=
  let g:vim_json_syntax_conceal = 0 " disable concealing of vim-json plugin
endif
" load snippets from runtime path automatically
let g:neosnippet#enable_snipmate_compatibility = 1
" ========== End of neosnippet Setting ===========

" ========== winresizer ===========
let g:winresizer_start_key     = '<C-W>w'
let g:winresizer_gui_start_key = '<C-W>a'
let g:winresizer_gui_enable     = 1 " enable if has("gui_running")
let g:winresizer_keycode_finish = 113 " q
let g:winresizer_keycode_cancel = 99  " c
let g:winresizer_keycode_mode   = 109 " m
let g:winresizer_keycode_move   = 118 " v (not use)
" ========== end of winresizer ====
"
nmap \ll <Plug>(mdvimtex_compile)
