scriptencoding utf-8
" vim: set fdm=marker foldlevel=0:
"
" Vim syntax file to add TODO into Pandoc documents
"
syntax keyword pandocTodo TODO FIXME XXX TBD containedin=ALL
hi link pandocTodo Todo

syntax sync clear
