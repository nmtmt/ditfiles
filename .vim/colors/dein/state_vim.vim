if g:dein#_cache_version !=# 100 || g:dein#_init_runtimepath !=# '/home/matsumoto/.vim,/home/matsumoto/share/vim/vimfiles,/home/matsumoto/share/vim/vim81,/home/matsumoto/share/vim/vimfiles/after,/home/matsumoto/.vim/after,/home/matsumoto/.vim/dein/repos/github.com/Shougo/dein.vim' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/home/matsumoto/.vimrc'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/home/matsumoto/.vim/dein'
let g:dein#_runtime_path = '/home/matsumoto/.vim/dein/.cache/.vimrc/.dein'
let g:dein#_cache_path = '/home/matsumoto/.vim/dein/.cache/.vimrc'
let &runtimepath = '/home/matsumoto/.vim,/home/matsumoto/share/vim/vimfiles,/home/matsumoto/.vim/dein/repos/github.com/Shougo/dein.vim,/home/matsumoto/.vim/dein/.cache/.vimrc/.dein,/home/matsumoto/share/vim/vim81,/home/matsumoto/.vim/dein/.cache/.vimrc/.dein/after,/home/matsumoto/share/vim/vimfiles/after,/home/matsumoto/.vim/after'
filetype off
