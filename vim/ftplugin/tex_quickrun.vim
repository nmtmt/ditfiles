" LaTeX Quickrun
let g:quickrun_config['tex'] = {
\ 'command' : 'latexmk',
\ 'outputter' : 'error',
\ 'outputter/error/success' : 'null',
\ 'outputter/error/error' : 'quickfix',
\ 'srcfile' : expand("%"),
\ 'cmdopt': '-pdfdvi',
\ 'hook/sweep/files' : [
\                      '%S:p:r.aux',
\                      '%S:p:r.bbl',
\                      '%S:p:r.blg',
\                      '%S:p:r.dvi',
\                      '%S:p:r.fdb_latexmk',
\                      '%S:p:r.fls',
\                      '%S:p:r.log',
\                      '%S:p:r.out'
\                      ],
\ 'exec': '%c %o %a %s',
\}
"\           'latexmk -pdfdvi -pv -output-directory=%a %a/tmptex.latex',

" 部分的に選択してコンパイル
" http://auewe.hatenablog.com/entry/2013/12/25/033416 を参考にしたhttps://qiita.com/ssh0/items/4aea2d3849667717b36dより
let g:quickrun_config.tmptex = {
\   'exec': [
\           'mkdir -p %a',
\           'mv %s %a/tmptex.tex',
\           'latexmk %a/tmptex.tex -pdfdvi -pv -output-directory=%a',
\           ],
\   'args' : expand("%:p:h:gs?\\\\?/?")."/tmp",
\
\   'outputter' : 'error',
\   'outputter/error/success' : 'null',
\   'outputter/error/error' : 'quickfix',
\
\   'hook/cd' : "%s:r"."/tmp",
\   'hook/eval/enable' : 1,
\   'hook/eval/template' : '\documentclass[uplatex]{jsarticle}'       ."\n"
\                         .'\usepackage[dvipdfmx]{graphicx, hyperref}'."\n"
\                         .'\providecommand{\tightlist}{%'            ."\n"
\                         .'  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}'."\n"
\                         .'\begin{document}'                         ."\n"
\                         .'%s'
\                         .'\end{document}',
\   'hook/sweep/files' : [
\                        '%a/tmptex.aux',
\                        '%a/tmptex.bbl',
\                        '%a/tmptex.blg',
\                        '%a/tmptex.dvi',
\                        '%a/tmptex.fdb_latexmk',
\                        '%a/tmptex.fls',
\                        '%a/tmptex.log',
\                        '%a/tmptex.out'
\                        ],
\}

nnoremap <silent><buffer> <F5> :QuickRun -mode n -type tmptex<CR>
vnoremap <silent><buffer> <F5> :QuickRun -mode v -type tmptex<CR>
