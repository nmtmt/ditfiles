set columns=150 
set lines=50

colorscheme tomorrow

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

if has("win64") || has("win32") || has("win32unix")
    set guifont=cica:h14
endif
