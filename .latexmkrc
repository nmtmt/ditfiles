#!/usr/bin/env perl
$latex         = 'uplatex -synctex=1 -halt-on-error';
$latex_silent  = 'uplatex -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex        = 'upbibtex';
$dvipdf        = 'dvipdfmx %O -o %D %S';
$makeindex     = 'mendex %O -o %D %S';
$max_repeat    = 5;
$pdf_mode	   = 3; # generates pdf via dvipdfmx

# Prevent latexmk from removing PDF after typeset.
# This enables Skim to chase the update in PDF automatically.
$pvc_view_file_via_temporary = 0;

# Use Skim as a previewer
if ($^O eq 'darwin') {
  $pdf_previewer = 'open -ga Skim';
} elsif ($^O eq 'linux') {
  $pdf_previewer = 'evince';
}
