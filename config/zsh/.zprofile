#!/usr/bin/env zsh
#
# Executes commands at login pre-zshrc.
#

#
# Editors and tools
#

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export AUR_PAGER='nvim'
export DIFFPROG='nvim -d'
export FZF_DEFAULT_COMMAND='fd --color=never -IH -E .git'

#
# Happy aliases
#

# Kubernetes
export KUBECONFIG=/dev/null
alias ke="export KUBECONFIG=~/.kube/config"
alias kd="export KUBECONFIG=/dev/null"
# kubectl is our friend
alias k=kubectl

# lazygit is neat
alias lg=lazygit
# Setup ptpb pastebin
alias clbin="curl -F 'clbin=<-' https://clbin.com"

# Be kind to me
alias please='sudo $(fc -ln -1)'

# systemd-related
alias uctl="systemctl --user"
alias jctl="journalctl --user"

# Vagrant Cheats
alias vup="vagrant up"
alias vh="vagrant halt"
alias vsus="vagrant suspend"
alias vs="vagrant status"
alias vp="vagrant provision"
alias vr="vagrant resume"
alias vrld="vagrant reload"
alias vssh="vagrant ssh"

# jujutsu
alias jjgpt="jj git push --tracked"
alias jjs="jj show"
alias jjl="jj log"
alias jjrs="jj restack"
alias jjrbm="jj rebase -r 'mine() & mutable()' -d 'trunk()'"
alias jjn="jj new"
alias jjgf="jj git fetch"
alias jjm="jj most"
alias jjt="jj tug"
alias jjtp="jjt && jjp"

# nix-darwin
alias nup="sudo darwin-rebuild switch"
alias nep="pushd $HOME/.config/thonix; nvim flake.nix +'Telescope fd'; popd"

#
# Language
# 
# - There's only one to default to
if [[ -z "$LANG" ]]; then
  export LANG='en_GB.UTF-8'
fi
# - Ibus for Korean
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus


# 
# Appearance
# 
# - Set the default BASE16_THEME so that a terminal emulator may dynamically
#   load it as it pleases, which works better for Kitty than setting it
#   with a script upon every start. Plus, at the time of this writing, I
#   start Kitty via i3.
# TODO: eliminate as tinty sorts this for us
export BASE16_THEME=base16-default-dark

#
# Paths
#

# Ensure path arrays do not contain duplicates and setup added folders.
typeset -gu cdpath fpath mailpath path
path=(
	~/.local/bin
	~/dev/go/bin
	$path[@]
)

# WSL: /etc/wsl.conf sets appendWindowsPath=false, because every PATH lookup
# through /mnt/c is slow (it made startup take ~5s). Add back only what we use.
if [[ -n "$WSL_DISTRO_NAME" ]]; then
	path+=(
		/mnt/c/Windows/System32(N/)
		/mnt/c/Windows(N/)
		/mnt/c/Users/*/scoop/apps/vscode/current/bin(N/)
	)
fi

# Set up GOPATH
export GOPATH=~/dev/go

# 
# Special locations
#

# - Configure virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs"

# - XDG_CONFIG_HOME is set once in .zshenv (sourced for every zsh invocation)
export XDG_CONFIG_CACHE="$HOME/.cache"

# Set ZSH cache directory
export ZSH_CACHE_DIR="$XDG_CONFIG_CACHE/zsh"

# - Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"


# Source homebrew
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#
# Less
#

# Set the default Less options.
# -X (disable screen clearing), -F (exit if content fits on one screen)
export LESS='-F -g -i -M -R -S -w -z-4 -X --mouse'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
