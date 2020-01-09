" Set linters for Rust in ALE
let b:ale_linters = ['rls']
" Set fixers for Rust in ALE
let b:ale_fixers = ['rustfmt']
" Use clippy if possible
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

