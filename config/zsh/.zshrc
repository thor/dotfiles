# zsh RC
# - Contains various personal aliases and configuratios that always happen
function _warn {
	printf "WARN: %s\n" $*
}

# base16 Shell
# - Modified to avoid .base16-theme, simplified somewhat
BASE16_SHELL=$HOME/.config/base16-shell/scripts
BASE16_THEME=base16-default-dark
if [ -n "$PS1" ] && [ -s "$BASE16_SHELL/$BASE16_THEME.sh" ]; then
	. "$BASE16_SHELL/$BASE16_THEME.sh"
else
	_warn "No theme, missing $BASE16_SHELL/$BASE16_THEME.sh"
fi

# Nobody can live without their editor
export EDITOR="nvim"

# Configure virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs"

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
if [ -s "$(which thefuck)" ]; then
	eval "$(thefuck --alias)"
else
	_warn "No fuck, missing thefuck executable"
fi

# Set up WSL ssh-agent if relevant
read _osrelease</proc/sys/kernel/osrelease
if [[ "$_osrelease" == *Microsoft* ]] && [ -z "$SSH_AUTH_SOCK"]; then
	eval $(/mnt/c/dev/ssh-agent-wsl -r)
fi


# Aliases and similar

# Use exa if available
if [[ -s /usr/bin/exa ]]; then
	alias ll="exa -lgFL 2"
	alias la="ll -a"
fi

# Setup ptpb pastebin
alias ptpb="curl -F c=@- https://0x0.st"

# Be kind to me
alias please='sudo $(fc -ln -1)'

# systemd-related
alias sctl="systemctl"
alias jctl="journalctl"

# Vagrant Cheats
alias vup="vagrant up"
alias vh="vagrant halt"
alias vsus="vagrant suspend"
alias vs="vagrant status"
alias vp="vagrant provision"
alias vr="vagrant resume"
alias vrld="vagrant reload"
alias vssh="vagrant ssh"

# USiT / UiO related
alias ussh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias u-socks="ssh -D 8888 -f -C -q -N thorhog@saruman.uio.no"
alias u-socks-high="ssh -D 8889 -f -C -q -N thorhog-drift@virt-mgmt.uio.no"
alias u-socks-external-high="ssh -D 8889 -f -C -q -N -J thorhog@saruman.uio.no,thorhog@dresden.uio.no thorhog-drift@virt-mgmt.uio.no"
function rawurlencode {
  local string="${@}"
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
function print-ifi() {
	set -x
	local filepath="$1"
	local file="${filepath##*/}"
	scp "$filepath" tmhogaas@login.ifi.uio.no:Documents/
	ssh -t tmhogaas@login.ifi.uio.no "/usr/bin/print \"Documents/${file}\" ${@:2};rm -f \"Documents/${file}\""
}

function u-govc() {
	if [ "$1" != "" ]; then
		local VC="${1}"
	else
		local VC="vcsa-vdiprod01"
	fi
	export https_proxy=127.0.0.1:8118
	export GOVC_URL="thorhog-drift@${VC}.uio.no"
	local GOVC_PASSWORD="$(rawurlencode $(secret-tool lookup domain UIO user thorhog-drift))"
	govc session.login -u "thorhog-drift:${GOVC_PASSWORD}@${VC}.uio.no"
}

# GitHub and BitBucket convenience
_fetchpr() {
    origin=${3:-origin}
    ref=$1
    branch=$2
    program=${funcstack#_fetchpr};
    if (( $# != 2 && $# != 3 )) then
        echo usage:$program id branchname \[remote\];
	return 1
    fi

    if git rev-parse --git-dir &> /dev/null; then
         git fetch $origin $ref && git checkout $branch
    else
	echo 'error: not in git repo'
    fi
}

# Checkout Github PR function
function gitpr() {
    github="pull/$1/head:$2"
    _fetchpr $github $2 $3
}

# Checkout Bitbucket PR function
function bitpr() {
    bitbucket="refs/pull-requests/$1/from:$2"
    _fetchpr $bitbucket $2 $3
}
