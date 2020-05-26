" Set latexindent options
let g:latexindent = 1
let g:latexindent_options = '-l=./.latexindent.yaml -'

" Set vimtex to use zathura (remember .latexmkrc for synctex)!
let g:vimtex_view_method = 'zathura'
" Configuring neovim-remote usage
if has('nvim')
	let g:vimtex_compiler_progname = '/usr/bin/nvr'
endif
" Enable folds (see FastFold for better performance)
let g:vimtex_fold_enabled = 1
" Custom formatexpr to handle inline comments
let g:vimtex_format_enabled = 1
" Use temporary files to avoid overwriting output file while compiling
let g:vimtex_view_use_temp_files = 0
" Close the error window after writing a bit
let g:vimtex_quickfix_autoclose_after_keystrokes = 3

" Update the latexmk configuration to use Make to make missing files like PNGs
let g:vimtex_compiler_latexmk = {
			\ 'options' : [
			\	 '-verbose',
			\	 '-file-line-error',
			\	 '-synctex=1',
			\	 '-interaction=nonstopmode',
			\	 '-use-make',
			\ ],
			\}

" Configure table of contents
" - Hide the help
" - Disable the label list by default
" - Resize too automatically
" - Increase size from 30 to 50
" - Reduce from 3 levels (4 parts) to 2 (3 parts)
let g:vimtex_toc_config = {
			\ 'show_help': 0,
			\ 'layer_status': {'content': 1, 'todo': 1, 'label': 1, 'fixme': 1},
			\ 'split_width': 50,
			\ 'tocdepth': 2
			\}
" - Do not show preamble in the list
let g:vimtex_toc_show_preamble = 0

let s:lbl_todo  = '✅D: '
let s:lbl_warn  = '⛔W: '
let s:lbl_fixme = '⚡F: '

let g:vimtex_toc_todo_labels = {
			\ 'TODO': s:lbl_todo, 
			\ 'FIXME': s:lbl_fixme, }

" Make the great todos even better than before
let s:matcher_fixmes = {
      \ 're' : g:vimtex#re#not_comment . '\\fx\w*%(\[[^]]*\])?\{\zs.*',
      \ 'prefilter': '\fx',
      \ 'priority' : 2,
      \}

function! s:matcher_fixmes.get_entry(context) abort dict " {{{1
  let l:title = matchstr(a:context.line, self.re)
  let l:type = strpart(a:context.line, 3, 1)

  let [l:end, l:count] = s:find_closing(0, l:title, 1, '{')
  if l:count == 0
    let l:title = strpart(l:title, 0, l:end)
  else
    let self.count = l:count
    let s:matcher_continue = deepcopy(self)
  endif

  let l:types = {'w': s:lbl_todo, 'f': s:lbl_fixme }

  return {
        \ 'title'  : get(l:types, l:type, s:lbl_todo) . l:title,
		\ 'number' : '',
        \ 'file'   : a:context.file,
        \ 'line'   : a:context.lnum,
        \ 'level'  : a:context.max_level - a:context.level.current,
        \ 'rank'   : a:context.lnum_total,
        \ 'type'   : 'todo',
        \ }
endfunction

" }}}1
let g:vimtex_toc_custom_matchers = [ s:matcher_fixmes ]

function! s:find_closing(start, string, count, type) abort " {{{1
  if a:type ==# '{'
    let l:re = '{\|}'
    let l:open = '{'
  else
    let l:re = '\[\|\]'
    let l:open = '['
  endif
  let l:i2 = a:start-1
  let l:count = a:count
  while l:count > 0
    let l:i2 = match(a:string, l:re, l:i2+1)
    if l:i2 < 0 | break | endif

    if a:string[l:i2] ==# l:open
      let l:count += 1
    else
      let l:count -= 1
    endif
  endwhile

  return [l:i2, l:count]
endfunction