set columns=150 
set lines=50

colorscheme tomorrow

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

if has("mac") " has(mac) have to be before has(unix)
  set guifont=Osaka-Mono:h14
  " set linespace=7
  let g:winresizer_gui_enable = 1
  "let g:winresizer_gui_start_key = '<C-W>a'
else
  if has("win64") || has("win32") || has("win32unix")
    set guifont=Cica:h12
    " set linespace=5
  elseif has("unix")
    "set noimdisableactivate
    "set iminsert=2
    "inoremap <ESC> <ESC>:set iminsert=0<CR>
    "autocmd InsertLeave * set iminsert=0 imsearch=0
    set guifont=Cica\ Regular\ 14
    " set linespace=5
  endif
endif
