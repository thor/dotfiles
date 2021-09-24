" Configuration and mappings for VSCode

if (exists('g:vscode'))

" vim-commentary-esque bindings
" https://github.com/asvetliakov/vscode-neovim#vim-commentary
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

augroup vscode
  autocmd! vscode
  autocmd FileType tex nmap <buffer> <silent> k gk
  autocmd FileType tex nmap <buffer> <silent> j gj
augroup END

end
