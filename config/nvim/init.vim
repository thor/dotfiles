"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Relatively clean .vimrc & init.vim -- thor at roht dott no

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
Plug 'justinmk/vim-sneak'      " Sneak, the missing motion

"" - Text Manipulation
Plug 'junegunn/vim-easy-align'    "  Align tables, comments, delims
Plug 'dhruvasagar/vim-table-mode' "  Quickly deal with tables and such
Plug 'tpope/vim-surround'         "  surrounding stuff, like parenthesis
Plug 'dkarter/bullets.vim'        "  Bullet lists made easy and automatic

if !exists('g:vscode')

" --- Writing enhancements
Plug 'vim-pandoc/vim-pandoc'             " pandoc-features
Plug 'vim-pandoc/vim-pandoc-syntax'      " pandoc-syntax
Plug 'vim-pandoc/vim-pandoc-after'       " plugin integration, incl. fastfold
Plug 'reedes/vim-pencil'                 " The pencil

" --- binary hex
Plug 'fidian/hexmode'                    " Hexmode
Plug 'hashivim/vim-terraform'            " Terraform, syntax, with more
Plug 'aklt/plantuml-syntax'              " PlantUML

" - Temporary plugins
Plug 'lambdalisue/suda.vim'       "  Workaround for !sudo tee % in v-1.3

" - Themes & Visuals
Plug 'chriskempson/base16-vim'           " The enjoyable base-16 theme

"    - UX & Functionality
Plug 'tpope/vim-fugitive'           " Git, git, git
Plug 'bling/vim-airline'            " It's so enjoyable with a nice status!
Plug 'junegunn/fzf'                 " Cooler fuzzy file finder
Plug 'junegunn/fzf.vim'             " vim-integration for fuzzy file finder
Plug 'junegunn/goyo.vim'            " Distraction free writing
Plug 'junegunn/limelight.vim'       " Hyper-focused writing in vim
Plug 'kyazdani42/nvim-web-devicons' " file icons for file tree viewer
Plug 'kyazdani42/nvim-tree.lua'     " file tree viewer
Plug 'metakirby5/codi.vim'          " Interactive scratchpad/REPL buffer
Plug 'mhinz/vim-signify'            " VCS gutter diffs

" - Settings management
Plug 'editorconfig/editorconfig-vim' " Deal with shared EditorConfig files

" - Linting & Auto-completion
Plug 'ludovicchabant/vim-gutentags' " tags generation
Plug 'dense-analysis/ale'           " linting et al and LSP
Plug 'Shougo/deoplete.nvim',        " Code completion with darkness
  \ Cond(has('nvim'), {'do': ':UpdateRemotePlugins'})
Plug 'zchee/deoplete-jedi',         " Python completion
  \ Cond(has('nvim'))
Plug 'deoplete-plugins/deoplete-clang',
  \ Cond(has('nvim'))               " C/C++ completion
Plug 'neovim/nvim-lspconfig'        " LSP configurations
Plug 'folke/lsp-colors.nvim'        " Colours for LSP
Plug 'folke/trouble.nvim'           " LSP error overview
Plug 'kyazdani42/nvim-web-devicons' " LSP pretty icons

" - Quality of life
Plug 'Konfekt/FastFold'             " Less, aka faster, folding
Plug 'zhimsel/vim-stay'             " Behind the scenes saving of folds


" - Syntax & File Type Enhancers
Plug 'saltstack/salt-vim'                " YAML-assistance for Salt
Plug 'pearofducks/ansible-vim'           " YAML-assistance for Ansible
Plug 'stephpy/vim-yaml'                  " YAML-syntax
Plug 'Matt-Deacalion/vim-systemd-syntax' " systemd unit files syntax
Plug 'Konfekt/vim-sentence-chopper'      " Sentence chopping using latexindent
Plug 'rust-lang/rust.vim'                " Rust-syntax
Plug 'Shirk/vim-gas'                     " AT&T Assembly syntax
Plug 'wannesm/wmgraphviz.vim'            " GraphViz
Plug 'fatih/vim-go',                     " Go-go-go-go
  \ { 'do': ':GoUpdateBinaries' }
Plug 'numirias/semshi',                  " Semantic Python highlighting
  \ Cond(has('nvim'), {'do': ':UpdateRemotePlugins'})
Plug 'jvirtanen/vim-hcl'                 " HCL2+ syntax highlighting


" - Syntax & File Type Enhancers
Plug 'lervag/vimtex'                     " LaTeX editing & completion and all

endif

" Finished pluggin' -- any plugins need to be before this
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Core vim configurations
" - (d) neovim default

let $VIMHOME=expand('<sfile>:p:h')

" Buffer management & behaviour
set hidden                " vim can remember buffers' contents when hidden
" - (d) Persistent undo 
if has('persistent_undo') && !has('nvim')
	let theUndoDir = expand($VIMHOME . '/undodir')
	call system('mkdir ' . theUndoDir)
	let &undodir = theUndoDir
endif
set undofile              " actually enable the saving of history to the file


" Windows
set clipboard=unnamedplus

" Colouring / syntax / schemes
let g:load_doxygen_syntax=1     " Automatically load Doxygen syntax for C/C++.
set foldmethod=marker           " Change from manual to marker for folding defaults

" Spacing / tabs / code-style
set tabstop=2                                        " Visual space per TAB used!
set softtabstop=-1                                   " Spaces entered per TAB in editing.
set shiftwidth=2                                     " Using 8 is ridicilous.
set autoindent                                       " (d) Because automatic indentation is useful.
set listchars=tab:▸\ ,eol:¬,trail:·,extends:#,nbsp:␣ " Configure how listchars should appear.

" User interface / elements / locations
set number                          " Show line numbers in the left bar.
set relativenumber                  " Let the line numbers be relative to pos.
set cursorline                      " Reveal the line I'm currently on.
set wildmenu                        " (d) Show tab-complete line for :cmds.
set colorcolumn=+1                  " Shows textwidth-column +1.
set title							" Use terminal title

if !exists('g:vscode')

function! ColorSchemeOverride() abort
	highlight ColorColumn ctermbg=18 " Colours the textwidth bar.
	highlight CursorLine ctermbg=19  " Colours the cursor line.
	highlight SpellCap ctermbg=NONE  " Remove background colour from spelling notices
	highlight SpellBad ctermbg=NONE  " Remove background colour from spelling errors
endfunction
augroup custom_colours
	autocmd!
	autocmd ColorScheme * call ColorSchemeOverride()
augroup END

" Themes 
set background=dark             " Use the dark theme of whatever colorscheme.
let base16colorspace=256        " Make sure that the scheme uses 256-colors.
colorscheme base16-default-dark " base16-inspired colorscheme.

" Other behavioural configurations
" - Restore guicursor after exiting
au VimLeave * set guicursor=a:hor100-blinkon1

endif

set backspace=indent,eol,start " (d) Backspace beyond single lines.
set modeline                   " Configure settings per file.
set mouse=a                    " (d) Mouse-support is actually really cool.
set incsearch                  " (d) Incremental search view for /searches.
" - Use ag instead of grep
set grepprg=rg\ -n\ $*
" - Remove options from views
set viewoptions-=options
" - Double frequency of swap writes for vim-signify
set updatetime=2000

" Email configuration
" - Add format option 'w' to add trailing white space, incl. 'a' for
"   auto-formatting. Used together with neomutts text_flowed-option.
augroup mail_trailing_whitespace " {
    autocmd!
    autocmd FileType mail setlocal formatoptions+=wa
augroup END " }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Terminal plugin configurations
if !exists('g:vscode')


" # Configuring vim-airline
" - Custom symbols
if !exists('g:airline_symbols')
   let g:airline_symbols = {}
endif
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
" - Use powerline symbols
let g:airline_powerline_fonts = 1
" - Enable a list of buffers at the top
let g:airline#extensions#tabline#enabled = 1
" - Show just the filename
" let g:airline#extensions#tabline#fnamemod = ':t'
" - Shorthand modes
let g:airline_mode_map = {
			\ '__' : '-',
			\ 'c'  : 'C',
			\ 'i'  : 'I',
			\ 'ic' : 'IC',
			\ 'ix' : 'Ic',
			\ 'n'  : 'N',
			\ 'ni' : '(I)',
			\ 'no' : 'OP',
			\ 'R'  : 'R',
			\ 'Rv' : 'RV',
			\ 's'  : 'S',
			\ 'S'  : 'S-L',
			\ '' : 'S-B',
			\ 't'  : 'T',
			\ 'v'  : 'V',
			\ 'V'  : 'V-L',
			\ '' : 'V-B',
			\ }
" - enable basic wordcount for vim-pandoc
let g:airline#extensions#wordcount#filetypes = [
			\ 'asciidoc', 'help', 'mail', 'markdown', 'org', 'rst', 
			\ 'tex', 'text', 'pandoc']


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


" # Configuring deoplete
" - Enable at startup
let g:deoplete#enable_at_startup = 1
" - Use system installed Python as host for neovim (ignore venv)
"   Very useful for having virtualenvs.
let g:python3_host_prog = '/usr/bin/python'
" - Configure ALE for deoplete
"   Do nothing. It should be registered automatically.
" - Configure autocompletion for vimtex and vim-pandoc
call deoplete#custom#var('omni', 'input_patterns', {
			\ 'pandoc': '@\w\w*',
			\ 'tex': g:vimtex#re#deoplete,
			\ })
" - 350ms delay by default
call deoplete#custom#option('auto_complete_delay', 350)
" - Configure C/C++ completion
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/lib/clang/10.0.0/include'


" # Configuring LSP client configurations
runtime! sections/lsp.vim


" # Configuring tree file viewer
runtime! sections/file-tree.lua


" # Configuring Goyo
" - Turning on and off syntax to fix issues with italis and bold
"   https://github.com/junegunn/goyo.vim/issues/156
function! s:goyo_leave()
  let l:set_syntax = &syntax
  syntax off
  syntax on
  let &syntax = l:set_syntax
endfunction
autocmd! User GoyoLeave nested call <SID>goyo_leave()


" # Configuring FZF
runtime! sections/fzf.vim


" # Configuring FastFold
" - TeX, with vimtex too (see up)
let g:tex_fold_enabled = 1
" - pandoc
let g:pandoc_fold_enabled = 1


" # Configuring vim-slime
" - Use tmux per default instead of screen
let g:slime_target = 'tmux'


" # Configuring vim-gutentags (and tags)
let g:gutentags_ctags_tagfile = '.tags'
set tags=./.tags;,.tags


" # Configuring vimtex
runtime! sections/vimtex.vim


endif
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ Non-terminal plugin configurations

" # Configuring vim-pandoc
runtime! sections/pandoc.vim


" # Configuring Terraform
" - Aligning automatically
let g:terraform_align = 1
" - Foldin' 's pretty cool too
let g:terraform_fold_sections = 1


" # Configuring vim-pencil
" - soft as default
let g:pencil#wrapModeDefault = 'soft'
" - two spaces after periods
let g:pencil#joinspaces = 1     " 0=one_space (def), 1=two_spaces
" - no concealment
let g:pencil#conceallevel = 2     " 0=disable, 1=one char, 2=hide char, 3=hide all (def)
" - add to airline
let g:airline_section_x = '%{PencilMode()}'


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

" - Setup table mode is just enabled/disabled manually
xnoremap <leader>tt <Plug>(table-mode-tableize)
nnoremap <leader>tt <Plug>(table-mode-tableize)

function! s:toggleTables()
  call pandoc#formatting#ToggleAutoformat()
  call tablemode#Toggle()
endfunction
nnoremap <leader>tm :<C-U>call <SID>toggleTables()<CR>

" - Setup Pandoc writes!
nnoremap <leader>pw :<C-U>call <SID>pandocOnWrite()<CR>

" - Setup Pandoc soft-mode TODO
nnoremap <leader>pS :<C-U>call <SID>pandocSoft()<CR>


" - Map paste-mode
set pastetoggle=<F2>

" - Map vim-easy-align commands
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" - Map list-characters key
nmap <leader>s :set list!<cr>

" - Map keys for FZF based on CtrlP and similarly
nnoremap <C-P>      :<C-U>Files<CR>
nmap     <leader>ph :Files ~<cr>
nmap     <leader>pb :Buffers<cr>
nmap     <leader>pg :Rg<cr>
nmap     <leader>pc :call vimtex#fzf#run('cl', g:fzf_layout)<cr>
nmap     <leader>pt :call vimtex#fzf#run('t', g:fzf_layout)<cr>


" - Map key for distraction free writing mode
nnoremap <F11> :Goyo<cr>

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

