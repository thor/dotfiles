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

" - Themes & Visuals
Plug 'chriskempson/base16-vim'           " The enjoyable base-16 theme

" - UI & Interaction
Plug 'tpope/vim-fugitive'     " Git, git, git
Plug 'bling/vim-airline'      " It's so enjoyable with a nice status!
Plug 'junegunn/fzf'           " Cooler fuzzy file finder
Plug 'junegunn/fzf.vim'       " vim-integration for fuzzy file finder
Plug 'Shougo/defx.nvim',	  " file explorer not riddled by bugs
	\ Cond(has('nvim'), {'do': ':UpdateRemotePlugins'})
Plug 'junegunn/goyo.vim'      " Distraction free writing
Plug 'junegunn/limelight.vim' " Hyper-focused writing in vim
Plug 'Konfekt/FastFold'       " Less, aka faster, folding
Plug 'vimwiki/vimwiki', 	  " personal wiki/notes for vim
	\ {'for': 'mkd'}

" - Settings management
Plug 'editorconfig/editorconfig-vim' " Deal with shared EditorConfig files

" - Linting & Auto-completion
Plug 'neomake/neomake'            " Code linting and compiling
Plug 'Shougo/deoplete.nvim',      " Code completion with darkness
	\ Cond(has('nvim'), {'do': ':UpdateRemotePlugins'})
Plug 'zchee/deoplete-jedi',       " Python completion
	\ Cond(has('nvim'))
Plug 'deoplete-plugins/deoplete-clang',
	\ Cond(has('nvim'))			  " C/C++ completion
	

" - Syntax & File Type Enhancers
Plug 'saltstack/salt-vim'                " YAML-assistance
Plug 'stephpy/vim-yaml'                  " YAML-syntax
Plug 'Matt-Deacalion/vim-systemd-syntax' " systemd unit files syntax
Plug 'lervag/vimtex'                     " LaTeX editing & completion and all
Plug 'rust-lang/rust.vim'                " Rust-syntax
Plug 'Shirk/vim-gas'					 " AT&T Assembly syntax
Plug 'wannesm/wmgraphviz.vim'            " GraphViz
Plug 'fatih/vim-go',					 " Go-go-go-go
	\ { 'do': ':GoUpdateBinaries' }
Plug 'arakashic/chromatica.nvim',		 " Semantic C/C++ highlighting
	\ Cond(has('nvim'), {'do': ':UpdateRemotePlugins',
		\'for': ['c', 'cpp', 'objc', 'objcpp'] })
Plug 'numirias/semshi',                  " Semantic Python highlighting
	\ Cond(has('nvim'), {'do': ':UpdateRemotePlugins'})

" --- binary hex
Plug 'fidian/hexmode'                    " Hexmode
Plug 'hashivim/vim-terraform'            " Terraform, syntax, with more
Plug 'aklt/plantuml-syntax'              " PlantUML

" --- Writing enhancements
Plug 'vim-pandoc/vim-pandoc'             " pandoc-features
Plug 'vim-pandoc/vim-pandoc-syntax'      " pandoc-syntax
Plug 'reedes/vim-pencil'			     " The pencil



"" - Text Manipulation
Plug 'junegunn/vim-easy-align'           " Align tables, comments, delims
Plug 'dhruvasagar/vim-table-mode'		 " Quickly deal with tables and such
Plug 'tpope/vim-surround'                " surrounding stuff, like parenthesis
Plug 'dkarter/bullets.vim'				 " Bullet lists made easy and automatic


" - Temporary plugins
Plug 'lambdalisue/suda.vim'				 " Workaround for !sudo tee % in v-1.3

" Finished pluggin' -- any plugins need to be before this
call plug#end()



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configurations


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



" # Configuring Neomake
" - Automatically run on writing files
autocmd! BufWritePost * Neomake


" # Configuring deoplete
" - Enable at startup
let g:deoplete#enable_at_startup = 1
" - Configure autocompletion for vimtex and vim-pandoc
call deoplete#custom#var('omni', 'input_patterns', {
			\ 'pandoc': '@\w\w*',
			\ 'tex': g:vimtex#re#deoplete,
			\ })
" - 350ms delay by default
call deoplete#custom#option('auto_complete_delay', 350)
" - Configure C/C++ completion
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/lib/clang/8.0.1/include'


" # Configuring vim-pandoc
runtime! sections/pandoc.vim


" # Configuring vimtex
" - Set vimtex to use zathura (remember .latexmkrc for synctex)!
let g:vimtex_view_method = 'zathura'
" - Configuring neovim-remote usage
if has('nvim')
	let g:vimtex_compiler_progname = '/usr/bin/nvr'
endif
" - Enable folds (see FastFold for better performance)
let g:vimtex_fold_enabled = 1
" - Custom formatexpr to handle inline comments
let g:vimtex_format_enabled = 1


" # Configuring vim-slime
" - Use tmux per default instead of screen
let g:slime_target = 'tmux'


" # Configuring chromatica
" - Enable on startup, but see plug definition
let g:chromatica#enable_at_startup = 1


" # Configuring Terraform
" - Aligning automatically
let g:terraform_align = 1
" - Foldin' 's pretty cool too
let g:terraform_fold_sections = 1


" # Configuring FastFold
" - TeX, with vimtex too (see up)
let g:tex_fold_enabled = 1
" - pandoc
let g:pandoc_fold_enabled = 1


" # Configuring vim-table-mode
" - ReST-compatible tables for pandoc GRID tables too
"   TODO: change this to + and = for .rst files only
let g:table_mode_corner = '|'
let g:table_mode_header_fillchar = '-'

" # Configuring vimwiki
" - setting the list of notes/wikis
let g:vimwiki_list = [
			\ {'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md'},
			\ {'path': '~/master/journal','syntax': 'markdown', 'ext': '.md'}]
" - try to change the file endings away from .md
let g:vimwiki_ext2syntax = {'.mdk': 'markdown',
			\ '.wiki': 'media'}

" # Configuring vim-pencil
" - soft as default
let g:pencil#wrapModeDefault = 'soft'
" - two spaces after periods
let g:pencil#joinspaces = 1     " 0=one_space (def), 1=two_spaces
" - no concealment
let g:pencil#conceallevel = 2     " 0=disable, 1=one char, 2=hide char, 3=hide all (def)
" - add to airline
let g:airline_section_x = '%{PencilMode()}'

" # Configuring defx
runtime! sections/defx.vim

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
	set undofile
endif

" Themes 
let base16colorspace=256        " Make sure that the scheme uses 256-colors.
colorscheme base16-default-dark " base16-inspired colorscheme.
set background=dark             " Use the dark theme of whatever colorscheme.

" Colouring / syntax / schemes
let g:load_doxygen_syntax=1     " Automatically load Doxygen syntax for C/C++.
set foldmethod=marker           " Change from manual to marker for folding defaults

" Spacing / tabs / code-style
set tabstop=4               " Visual space per TAB used!
set softtabstop=-1          " Spaces entered per TAB in editing.
set shiftwidth=4            " Using 8 is ridicilous.
set autoindent              " (d) Because automatic indentation is useful.
set listchars=tab:▸\ ,eol:¬ " Configure how listchars should appear.

" User interface / elements / locations
set number                          " Show line numbers in the left bar.
set relativenumber                  " Let the line numbers be relative to pos.
set cursorline                      " Reveal the line I'm currently on.
set wildmenu                        " (d) Show tab-complete line for :cmds.
set colorcolumn=+1                  " Shows textwidth-column +1.
set title							" Use terminal title
highlight ColorColumn ctermbg=18    " Colours the textwidth bar.

" Other behavioural configurations
" - Restore guicursor after exiting
au VimLeave * set guicursor=a:hor100-blinkon1
set backspace=indent,eol,start " (d) Backspace beyond single lines.
set modeline                   " Configure settings per file.
set mouse=a                    " (d) Mouse-support is actually really cool.
set incsearch                  " (d) Incremental search view for /searches.


" Email configuration
" - Add format option 'w' to add trailing white space, incl. 'a' for
"   auto-formatting. Used together with neomutts text_flowed-option.
augroup mail_trailing_whitespace " {
    autocmd!
    autocmd FileType mail setlocal formatoptions+=wa
augroup END " }



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global key mappings

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
nnoremap <leader>ps :<C-U>call <SID>pandocSoft()<CR>


" - Map paste-mode
set pastetoggle=<F2>

" - Map vim-easy-align commands
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" - Map list-characters key
nmap <leader>s :set list!<cr>

" - Map keys for FZF based on CtrlP and similarly
nmap     <leader>p  :FZF<cr>
nmap     <leader>P  :FZF!<cr>
nmap     <leader>ph :FZF ~<cr>
nnoremap <C-P>      :<C-U>FZF<CR>

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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File-based key mappings
" TODO: move to own files



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands

" - Add buffer deletion command for more-than-one windows and buffers
command Bd bp | sp | bn | bd

