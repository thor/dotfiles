# We like our relatively dotless directory
export ZDOTDIR=~/.config/zsh/
# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
# Set up extra paths
typeset -U path
path=(
	~/.local/bin
	~/dev/go/bin
	~/.gem/ruby/2.5.0/bin
	$path[@]
)
# Set up GOPATH
export GOPATH=~/dev/go
