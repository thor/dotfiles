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

# Setup direnv after instant prompt
if _exists direnv; then
		(( ${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"
fi

# base16 Shell
# - Modified to avoid .base16-theme, simplified somewhat
# - NOTE: the scripts are not necessary with kitty, nor helpful
BASE16_SHELL=$HOME/.config/base16-shell/scripts
BASE16_THEME=base16-default-dark
if [ "$TERM" = "xterm-kitty" ]; then
	# do nothing
elif [ -n "$PS1" ] && [ -s "$BASE16_SHELL/$BASE16_THEME.sh" ]; then
	. "$BASE16_SHELL/$BASE16_THEME.sh" >/dev/null
else
	_warn "No theme, missing $BASE16_SHELL/$BASE16_THEME.sh"
fi

# Source homebrew zsh completions, but do these zsh?
if _exists brew 2>&1 >/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
	# We ignore compinit ectc because zprezto will do it for us
fi

# iTerm2: disable the mark
export ITERM2_SQUELCH_MARK=1


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

# rtx: the better alternative to asdf
if _exists rtx; then
	source "$(rtx activate zsh)" >/dev/null 2>&1
# asdf: nvm, pyenv, rbenv, goenv, etc
elif _exists asdf; then
	source "$(_bp asdf)/libexec/asdf.sh"
	# Load asdf-direnv
	source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
	# Tell asdf-python where to get default packages from
	export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.asdf/python-default-packages"
fi


# termite: open current directory with ctrl+shift+t
if [[ $TERM == xterm-termite ]]; then
	. /etc/profile.d/vte.sh
fi

# Configure thefuck
_exists thefuck && eval "$(thefuck --alias)" || _warn "No fuck, missing thefuck executable"

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
