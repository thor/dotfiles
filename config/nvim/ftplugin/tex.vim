" Setup soft-wrapping with vim-pencil
"augroup pencil
"  autocmd!
"  autocmd FileType markdown,mkd call pencil#init()
"  autocmd FileType text         call pencil#init()
"augroup END
call pencil#init({'wrap': 'soft'})
" Enable linebreaks
set linebreak
" Enable soft-wrapping
set wrap

" Setup vimtex

" ale and YaLafi

" F9: show detailed LT message for error under cursor, is left with 'q'
map <F9> :ALEDetail<CR>
" Specify the LaTeXlinters
let b:ale_linters = ['lty', 'chktex', 'lacheck', 'redpen']
" Enable latexindent as a fixer
let b:ale_fixers = ['latexindent']
" default place of LT installation: '~/lib/LanguageTool'
let g:ale_tex_lty_ltdirectory = '/usr/share/java/languagetool'
" set shell options to use custom definitions
let g:ale_tex_lty_shelloptions = '--python-defs tex_filters'
" set to '' to disable server usage or to 'lt' for LT's Web server
let g:ale_tex_lty_server = 'my'
" default language: 'en-GB'
let g:ale_tex_lty_language = 'en-GB'
" default disabled LT rules: 'WHITESPACE_RULE'
let g:ale_tex_lty_disable = 'WHITESPACE_RULE,OXFORD_SPELLING_ADJECTIVES,OXFORD_SPELLING_NOUNS,OXFORD_SPELLING_ISE_VERBS'
" remap errors to information from languagetool
let g:ale_type_map = {'lty': {'E': 'I'}}
