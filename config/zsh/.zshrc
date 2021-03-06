# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh RC
# - Contains various personal aliases and configuratios that always happen
function _warn {
	printf "WARN: %s\n" "$@"
}

# base16 Shell
# - Modified to avoid .base16-theme, simplified somewhat
# - NOTE: the scripts are not necessary with kitty, nor helpful
BASE16_SHELL=$HOME/.config/base16-shell/scripts
BASE16_THEME=base16-default-dark
if [ "$TERM" = "xterm-kitty" ]; then
	true
elif [ -n "$PS1" ] && [ -s "$BASE16_SHELL/$BASE16_THEME.sh" ]; then
	. "$BASE16_SHELL/$BASE16_THEME.sh"
else
	_warn "No theme, missing $BASE16_SHELL/$BASE16_THEME.sh"
fi


# Source prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Source fzf if it exists
if [[ -d "/usr/share/fzf/" ]]; then
	source "/usr/share/fzf/key-bindings.zsh"
	source "/usr/share/fzf/completion.zsh"
else
	_warn "No FZF, could not find fzf script"
fi

# termite: open current directory with ctrl+shift+t
if [[ $TERM == xterm-termite ]]; then
	. /etc/profile.d/vte.sh
fi

# Configure thefuck
if [ -s "$(command -v thefuck)" ]; then
	eval "$(thefuck --alias)"
else
	_warn "No fuck, missing thefuck executable"
fi

# Set up WSL ssh-agent if relevant
read -r _osrelease</proc/sys/kernel/osrelease
if [[ "$_osrelease" == *Microsoft* ]] && [ -z "$SSH_AUTH_SOCK" ]; then
	eval "$(/mnt/c/dev/ssh-agent-wsl -r)"
fi


# Aliases and similar

# Journal is too long
alias j=journal

# Use exa if available
if [[ -s /usr/bin/exa ]]; then
	alias ll="exa -lgFL 2"
	alias la="ll -a"
fi

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

# Used by usit.sh
function rawurlencode {
  # TODO: verify that it shouldn't be ${@}
  local string="${*}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:${pos}:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

# University-related for printing
function print-ifi() {
	set -x
	local filepath="$1"
	local file="${filepath##*/}"
	scp "$filepath" tmhogaas@login.ifi.uio.no:Documents/
	ssh -t tmhogaas@login.ifi.uio.no "/usr/bin/print ${@:2} \"Documents/${file}\"; rm -f \"Documents/${file}\""
}

# Source usit.sh for work configuration
if [[ -s "${HOME}/.local/lib/usit.sh" ]]; then
  source "${HOME}/.local/lib/usit.sh"
else 
	_warn "Missing usit.sh, no work-related aliases will be loaded"
fi

# GitHub and BitBucket convenience
_fetchpr() {
    origin=${3:-origin}
    ref=$1
    branch=$2
    program=${funcstack#_fetchpr};
    if (( $# != 2 && $# != 3 )) then
        echo "usage:$program id branchname \[remote\]"
	return 1
    fi

    if git rev-parse --git-dir &> /dev/null; then
         git fetch "$origin" "$ref" && git checkout "$branch"
    else
	echo 'error: not in git repo'
    fi
}

# Checkout Github PR function
function gitpr() {
    github="pull/$1/head:$2"
    _fetchpr "$github" "$2" "$3"
}

# Checkout Bitbucket PR function
function bitpr() {
    bitbucket="refs/pull-requests/$1/from:$2"
    _fetchpr "$bitbucket" "$2" "$3"
}

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
