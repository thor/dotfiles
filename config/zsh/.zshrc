# Allegedly common option for themes
#setopt promptsubst

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source zinit
export ZINITZSH=~/.local/lib/zinit/zinit.zsh
if [[ -s "$ZINITZSH" ]]; then source "$ZINITZSH"; fi

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



# TODO: Try to add colors
autoload colors
colors

zinit wait lucid for \
	PZT::modules/spectrum \
	PZT::modules/utility \
	PZT::modules/terminal \
	PZT::modules/editor \
	PZT::modules/directory \
	PZT::modules/prompt


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
if [ -n "${WSL_DISTRO_NAME}" ]; then
	export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
	ss -a | grep -q $SSH_AUTH_SOCK
	if [ $? -ne 0   ]; then
		rm -f $SSH_AUTH_SOCK
		( setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/tools/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
	fi
fi

# Load the theme
zinit ice depth'1'
zinit light romkatv/powerlevel10k

# Source fzf if it exists
if [[ -d "/usr/share/fzf/" ]]; then
	zinit wait lucid as"completion" is-snippet for \
		/usr/share/fzf/key-bindings.zsh \
		/usr/share/fzf/completion.zsh
	#source "/usr/share/fzf/key-bindings.zsh"
	#source "/usr/share/fzf/completion.zsh"
else
	_warn "No FZF, could not find fzf script"
fi

zinit wait lucid for \
	PZT::modules/git/alias.zsh \
	zsh-users/zsh-completions \
	PZT::modules/completion \

# Syntax highlighting should come after the completion initialisation
zinit wait lucid atload"zicompinit; zicdreplay" for \
	zdharma/fast-syntax-highlighting


zinit wait lucid is-snippet for \
	/usr/share/nvm/init-nvm.sh

# Replays all the compdef commands as compinit wasn't loaded yet
#zinit cdreplay -q

# Aliases and similar

# Journal is too long
alias j=journal

# Use exa if available
if [[ -s /usr/bin/exa ]]; then
	alias ls=exa
	alias ll="exa -lgFL 2"
	alias la="ll -a"
fi

# Setup ptpb pastebin
alias clbin="curl -F 'clbin=<-' https://clbin.com"

# Be kind to me
alias please='sudo $(fc -ln -1)'

# systemd-related
alias uctl="systemctl --user"
alias ujctl="journalctl --user"

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

# Source work.sh for work configuration
if [[ -s "${HOME}/.local/lib/work.sh" ]]; then
  zinit snippet "${HOME}/.local/lib/work.sh"
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
