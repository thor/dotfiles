" Set linters for C++ in ALE
let b:ale_linters = ['ccls', 'clangtidy', 'cppcheck']
" Set fixers for Rust in ALE
let b:ale_fixers = ['clang-format']

" Use make -n to parse commands
let b:ale_c_parse_compile_commands = 1
" Reduce default C++ clang options
let b:ale_cpp_clang_options = '-Wall'
" Specify new options to cppcheck
let b:ale_cpp_cppcheck_options = '--enable=style --suppressions-list=.suppressions.txt'
