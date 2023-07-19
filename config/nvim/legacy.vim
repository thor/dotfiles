"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Relatively clean .vimrc & init.vim -- thor at roht dott no
" vim: set et :

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Core vim configurations not migrated yet
if !exists('g:vscode')

" Other behavioural configurations
" - Restore guicursor after exiting
au VimLeave * set guicursor=a:hor100-blinkon1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Terminal plugin configurations


" # Configuring ALE
" - Setting up linter aliases
let g:ale_linter_aliases = {'pandoc': ['markdown']}
" - Use global executables by default
let g:ale_use_global_executables = 1
" - Enabling pipenv integration
let g:ale_python_auto_pipenv = 1
" - Always keep the gutter open
let g:ale_sign_column_always = 1
" - Setting pretties
let g:ale_sign_error = "◉"
let g:ale_sign_warning = "◉"
let g:ale_sign_info = "◈"
highlight ALEErrorSign ctermfg=9 ctermbg=18
highlight ALEWarningSign ctermfg=11 ctermbg=18
highlight ALEInfoSign ctermfg=6 ctermbg=18
" - Set default fixer
let g:ale_fixers = ['prettier']


endif

" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Non-terminal plugin configurations


" # Configuring VSCode settings and keybindings
runtime! sections/vscode.vim


" # Configuring WSL (Windows Subsystem for Linux) settings
if !empty($WSL_DISTRO_NAME)
	runtime! sections/wsl.vim
endif

" }}}

