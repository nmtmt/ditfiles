set columns=150
set lines=50

colorscheme Tomorrow

nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

set mouse=a

set guioptions-=m " remove menu bar
set guioptions-=T " remove tool bar

set guioptions-=r " remove right scroll bar
set guioptions-=R " remove right scroll bar
set guioptions-=l " remove left scroll bar
set guioptions-=L " remove left scroll bar

if has("mac") " has(mac) line have to be checked before has(unix)
  set guifont=Osaka-Mono:h14
  let &pythonhome      = split(g:python_host_prog , '/bin/python')[0]
  let &pythonthreehome = split(g:python3_host_prog, '/bin/python')[0]
  let &pythondll      = &pythonhome      . '/Python'
  let &pythonthreedll = &pythonthreehome . '/Python'
  try
    python3 print()
    " use python3 as default by calling python3 here because MacVim-kaoriya does not
    " support to use vim with python2.x and python3.x at the same time
  catch
  endtry
  set linespace=4
else
  if has("win64") || has("win32") || has("win32unix")
    set guifont=Osaka-Mono:h12
    set linespace=2
    " for deoplete
    let g:python3_host_prog=glob("$HOME/AppData/Local/Programs/Python/Python37/python.exe")
    let &pythonthreehome=glob("$HOME/AppData/Local/Programs/Python/Python37")
    let &pythonthreedll =glob("$HOME/AppData/Local/Programs/Python/Python37/python3.dll")
    " set linespace=5
  elseif has("unix")
    " set guifont=Cica\ Regular\ 12
    if has("nvim") " for neovim-qt
      Guifont! Osaka-Mono:h12
      set linespace=4
    else
      set guifont=Osaka-Mono\ 12
    endif
    " set linespace=5
  endif
endif
