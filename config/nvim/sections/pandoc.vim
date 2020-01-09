"
" PURPOSE
"	Sectioned configuration for Pandoc and all Markdown-writing related
"	content as one sees fit.
"

" Configuring independent options {{{

" - Setting textwidth and formatting
let g:pandoc#formatting#mode = 's'
" - Quick latex-command generation
let g:pandoc#command#autoexec_command = 'Pandoc pdf'
" - Set pdflatex as default engine
let g:pandoc#command#latex_engine = 'lualatex'
" - Enable bibtool for bibliography details (see deoplete)
let g:pandoc#biblio#use_bibtool = 1
" - Use headers from setext for level 1 and 2
let g:pandoc#keyboard#sections#header_style = 's'
" - Fold the YAML front matter
let g:pandoc#folding#fold_yaml = 1
" - Fold stacked as to show all headers at the same time
let g:pandoc#folding#mode = 'stacked'
" - Add looking for 'bibliography.bib'
let g:pandoc#biblio#bibs = ['../bibliography.bib']

" }}}

" Configuring vim-pandoc-after options {{{
" - Enable the nrrwrgn and fastfold
let g:pandoc#after#modules#enabled = ["nrrwrgn", "fastfold"]
" }}}

" Configuring citeproc-dependent settings {{{
if filereadable("/usr/bin/pandoc-citeproc")
	" - Use citeproc backend for searching in bibliographies
	let g:pandoc#completion#bib#mode = 'citeproc'
	" - Use previews in the information
	let g:pandoc#completion#bib#use_preview = 1
else
	echoerr "pandoc-citeproc not installed at /usr/bin/pandoc-citeproc"
endif
" }}}

" pandoc autocmd {{{
augroup just_pandoc_things
  autocmd!
  " - making it work well with vimwiki (forcing upon it)
  autocmd BufEnter,BufRead,BufNewFile *.md set filetype=pandoc
  autocmd FileType vimwiki set syntax=pandoc
augroup END
" }}}

" Helper functions for keybindings {{{
function! s:pandocSoft()
  call pandoc#formatting#DisableAutoformat()
  PencilSoft
endfunction

function! s:pandocOnWrite()
  let g:pandoc#command#autoexec_on_writes = 1
endfunction
" }}}

" - adding my favourite keybinding
noremap <Leader>t :noautocmd grep! "(TODO\\|FIXME).*" -o %:h/*.md<CR>:cw<CR>
" - Map MarkDown/pandoc word count
xnoremap <leader>w <esc>:'<,'>:w !mdwc<CR>
