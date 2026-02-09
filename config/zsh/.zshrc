# zsh RC

# Toggle to enable profiling, see bottom of zshrc
[ -z "$ZPROF" ] || zmodload zsh/zprof

# Specifically for tools on macOS, specify XDG_CONFIG_HOME
export XDG_CONFIG_HOME="$HOME/.config"


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
	[ -f "$HOME/.ssh/id_ed25519_work" ] && ssh-add -q ~/.ssh/id_ed25519_work
fi


# base16 Shell
export BASE16_THEME=base16-default-dark

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source load.d profile scripts
for script in ${ZDOTDIR:-$HOME}/load.d/*.*sh; do
	source "${script}"
done


# Source sheldon (the shell, specifically zsh plugin manager)
if _exists sheldon; then
  eval "$(sheldon source)"
else
  _warn "No sheldon, couldn't source shell scripts"
fi

# Setup direnv after instant prompt
zsh-defer _exists direnv && emulate zsh -c "$(direnv hook zsh)"

# Source homebrew zsh completions, but do these zsh?
if _exists brew 2>&1 >/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Source fzf if it exists (checks for fzf-share, too)
if _exists fzf; then
  _fzf_dir="$(_select_first /usr/share/fzf/ "$(_bp fzf)/shell/" "$(command -v fzf-share >/dev/null 2>&1 && fzf-share)")"
	zsh-defer source "${_fzf_dir}/key-bindings.zsh"
	zsh-defer source "${_fzf_dir}/completion.zsh"
else
	_warn "No FZF, could not find fzf script"
fi

# mise: the better alternative to asdf
if _exists mise; then
	export RTX_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/mise/python-default-packages"
	zsh-defer eval "$(mise activate zsh)" >/dev/null 2>&1
else
	_warn "mise wasn't available; you should install it"
fi

# Source cargo environments
if [ -f "$HOME/.cargo/env" ]; then
  zsh-defer source "$HOME/.cargo/env"
fi

# Configure pay-respects
_exists pay-respects && zsh-defer eval "$(pay-respects zsh)" || _warn "No pay-respects, missing pay-respects executable"

# Configure jujutsu
_exists jj && zsh-defer eval "$(COMPLETE=zsh jj)" || true

# Aliases and similar

# Journal is too long
alias j=journal

# Kubernetes
export KUBECONFIG=/dev/null
alias ke="export KUBECONFIG=~/.kube/config"
alias kd="export KUBECONFIG=/dev/null"
# kubectl is our friend
alias k=kubectl

# lazygit is neat
alias lg=lazygit

# Use exa if available
if _exists eza; then
	alias ll="eza -lgL 2"
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

# jujutsu
alias jjp="jj git push --tracked"
alias jjs="jj show"
alias jjl="jj log"
alias jjrbm="jj rebase -r 'mine() & mutable()' -d 'trunk()'"
alias jjn="jj new"
alias jjgf"jj git fetch"
alias jjm="jj most"
alias jjt="jj tug"
alias jjtp="jjt && jjp"

# nix-darwin
alias nup="sudo darwin-rebuild switch"
alias nep="pushd $HOME/.config/thonix; nvim flake.nix +'Telescope fd'; popd"

# Source work.sh for work configuration
if [[ -s "${HOME}/.local/lib/work.sh" ]]; then
  zsh-defer source "${HOME}/.local/lib/work.sh"
else 
	_warn "Missing ~/.local/lib/work.sh, no work-related aliases will be loaded"
fi

# Google Cloud SDK
# TODO: Add paths for Arch setup? Ideally, site-functions should deal with this
local _gcloud_completion="$(_bcp google-cloud-sdk)/latest/google-cloud-sdk/completion.zsh.inc"
_exists $_gcloud_completion && _source_first $_gcloud_completion

# iTerm2: disable the mark
export ITERM2_SQUELCH_MARK=1

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Toggle to stop profiling, see toggle at top of zshrc
[ -z "$ZPROF" ] || zprof

# pnpm
[[ -f /Users/thor ]] && export PNPM_HOME="/Users/thor/Library/pnpm" || export PNPM_HOME="$HOME/.local/share/pnpm"

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
