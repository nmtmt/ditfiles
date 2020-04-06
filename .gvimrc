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
elseif has("win64") || has("win32") || has("win32unix") || has("unix")
  set guifont=cica:h12
  " set linespace=5
endif
