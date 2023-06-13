# zsh RC

# Source load.d profile scripts
for script in ${ZDOTDIR:-$HOME}/load.d/*.*sh; do
	source "${script}"
done

# Setup direnv before instant prompt
if _exists direnv; then
		(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



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
if _exists fzf; then
	_fzf_dir="$(_select_first /usr/share/fzf/ "$(_bp fzf)/shell/")"
	source "${_fzf_dir}/key-bindings.zsh"
	source "${_fzf_dir}/completion.zsh"
else
	_warn "No FZF, could not find fzf script"
fi

# asdf: nvm, pyenv, rbenv, goenv, etc
if _exists asdf; then
	source "$(_bp asdf)/libexec/asdf.sh"
fi


# termite: open current directory with ctrl+shift+t
if [[ $TERM == xterm-termite ]]; then
	. /etc/profile.d/vte.sh
fi

# Configure thefuck
if _exists thefuck; then
	eval "$(thefuck --alias)"
else
	_warn "No fuck, missing thefuck executable"
fi

# Temporarily we're just using a local SSH agent because of some perky issues
# Set up WSL ssh-agent if relevant
if [ -n "${WSL_DISTRO_NAME}" ]; then
	export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
	ss -a | grep -q $SSH_AUTH_SOCK
	if [ $? -ne 0   ]; then
		rm -f $SSH_AUTH_SOCK
		( setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/dev/wsl-ssh-agent/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
	fi

	# Then add our work profile
	ssh-add -q ~/.ssh/id_ed25519_work
fi

# Setup direnv
if command -v direnv; then
    eval "$(direnv hook zsh)"
fi

# Aliases and similar

# Journal is too long
alias j=journal

# kubectl is our friend
alias k=kubectl

# Use exa if available
if _exists exa; then
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

# Source work.sh for work configuration
if [[ -s "${HOME}/.local/lib/work.sh" ]]; then
  source "${HOME}/.local/lib/work.sh"
else 
	_warn "Missing ~/.local/lib/work.sh, no work-related aliases will be loaded"
fi

# Google Cloud SDK
if _exists gcloud; then
	# TODO: Add paths for Arch setup? Ideally, site-functions should deal with this
	_source_first "$(_bcp google-cloud-sdk)/latest/google-cloud-sdk/completion.zsh.inc"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
