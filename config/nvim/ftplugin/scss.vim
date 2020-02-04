" Set linters for SCSS in ALE
let b:ale_linters = ['stylelint']
" Set fixers for SCSS in ALE
let b:ale_fixers = ['prettier']

" Enable fix on save for SCSS in ALE
let b:ale_fix_on_save = 1

" Disable global prettier for SCSS
let b:ale_javascript_prettier_use_global = 0
" Disable global stylelint
let b:ale_scss_stylelint_use_global = 0
" Possibly a bug in
" https://github.com/dense-analysis/ale/blob/master/autoload/ale/fixers/stylelint.vim
let b:ale_stylelint_use_global = 0
