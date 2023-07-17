"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Relatively clean .vimrc & init.vim -- thor at roht dott no
" vim: set et :

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Initialise vim-plug and them plugins
" - Conditional function to help share configuration across vim and nvim
function! Cond(cond, ...)
	let opts = get(a:000, 0, {})
	return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Load list of plugins for vim-plug
call plug#begin('~/.config/nvim/plugged')

" - Motions
Plug 'chrisbra/nrrwrgn'        " Narrowing from Emacs

"" - Text Manipulation
Plug 'junegunn/vim-easy-align'    "  Align tables, comments, delims
Plug 'tpope/vim-surround'         "  surrounding stuff, like parenthesis
Plug 'dkarter/bullets.vim'        "  Bullet lists made easy and automatic

if !exists('g:vscode')

" - Temporary plugins
Plug 'lambdalisue/suda.vim'       "  Workaround for !sudo tee % in v-1.3

"    - UX & Functionality
Plug 'metakirby5/codi.vim'          " Interactive scratchpad/REPL buffer
Plug 'mhinz/vim-signify'            " VCS gutter diffs

" - Settings management
Plug 'editorconfig/editorconfig-vim' " Deal with shared EditorConfig files

" - Linting & Auto-completion
" TODO: Figure out if ALE provides any functionality LSP does not
Plug 'dense-analysis/ale'           " linting et al and LSP

" - Quality of life
Plug 'zhimsel/vim-stay'             " Behind the scenes saving of folds


endif

" Finished pluggin' -- any plugins need to be before this
call plug#end()

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Global key mappings

" - Set mapleader to be space, convenient
let mapleader = " "
" - Set local leader to be the backspace, somewhat convenient
let localleader = "\\"

" - Easier spellcheck med \s
nnoremap <leader>c ea<C-X><C-S>

" - Buffers with tab!
nnoremap <Tab> :bn<cr>
nnoremap <S-Tab> :bp<cr>

" - Make splits easier to deal with
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" - Map paste-mode
map <F2> :set paste!<CR>:lua require('lualine').refresh()<CR>
set pastetoggle=<F2>

" - Map vim-easy-align commands
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" - Map list-characters key
nmap <leader>s :set list!<cr>

" - Map tab in insert mode to go through suggestions
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
inoremap <silent><expr> <s-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ <SID>check_back_space() ? "\<s-TAB>" :
      \ deoplete#manual_complete()

" - Map Ctrl+Space for opening LSP suggestions
inoremap <expr><C-Space> deoplete#manual_complete("lsp")

" - Syntax debugging
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands

" - Add buffer deletion command for more-than-one windows and buffers
command Bd bp | sp | bn | bd

