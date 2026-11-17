# zsh RC

# Toggle to enable profiling, see bottom of zshrc
[ -z "$ZPROF" ] || zmodload zsh/zprof

# XDG_CONFIG_HOME is set once in .zshenv (sourced for every zsh invocation)

if [ -n "${WSL_DISTRO_NAME}" ]; then
  # Temporarily we're just using a local SSH agent because of some perky issues
  # Set up WSL ssh-agent if relevant
	export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
	ss -a | grep -q $SSH_AUTH_SOCK
	if [ $? -ne 0   ]; then
		rm -f $SSH_AUTH_SOCK
		( setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"/mnt/c/dev/wsl-ssh-agent/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork & ) >/dev/null 2>&1
	fi

	# Then add our work profile
	[ -f "$HOME/.ssh/id_ed25519_work" ] && ssh-add -q ~/.ssh/id_ed25519_work
fi

# Make zsh-defer available to load.d scripts (sheldon reloads it later; idempotent)
_zsh_defer_plugin="${XDG_DATA_HOME:-$HOME/.local/share}/sheldon/repos/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh"
[ -f "$_zsh_defer_plugin" ] && source "$_zsh_defer_plugin"
 
 # Source load.d profile scripts ((N): expand to nothing when there's no match)
for script in ${ZDOTDIR:-$HOME}/load.d/*.*sh(N); do
  source "${script}"
done


# Source sheldon (the shell, specifically zsh plugin manager)
if _exists sheldon; then
  eval "$(sheldon source)"
else
  _warn "No sheldon, couldn't source shell scripts"
fi

# Setup direnv (synchronous so its hook is active for the first command)
_exists direnv && emulate zsh -c "$(direnv hook zsh)"

# Source homebrew zsh completions, but do these zsh?
if _exists brew; then
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
	# Synchronous so shims are on PATH for the first command
	eval "$(mise activate zsh)"
else
	_warn "mise wasn't available; you should install it"
fi

# Source cargo environments
if [ -f "$HOME/.cargo/env" ]; then
  zsh-defer source "$HOME/.cargo/env"
fi

# Ensure cargo bin is on PATH (in case ~/.cargo/env is absent)
case ":$PATH:" in
  *":$HOME/.cargo/bin:"*) ;;
  *) export PATH="$HOME/.cargo/bin:$PATH" ;;
esac

# Configure pay-respects
# Single-quote so the $(...) fork happens at defer time, not now
_exists pay-respects && zsh-defer eval 'eval "$(pay-respects zsh)"' || _warn "No pay-respects, missing pay-respects executable"

# Configure jujutsu completions (deferred; fork happens at defer time)
_exists jj && zsh-defer eval 'eval "$(COMPLETE=zsh jj)"' || true

# Aliases and similar
# Use exa if available
if _exists eza; then
	alias ll="eza -lgL 2"
	alias la="ll -a"
fi


# Source work.sh for work configuration
if [[ -s "${HOME}/.local/lib/work.sh" ]]; then
  zsh-defer source "${HOME}/.local/lib/work.sh"
else 
	_warn "Missing ~/.local/lib/work.sh, no work-related aliases will be loaded"
fi

# Google Cloud SDK completions
# Derive the SDK root from the gcloud binary so this works regardless of the
# install layout (homebrew, nix, tarball). Skips silently if no inc ships.
if _exists gcloud; then
  _gcloud_root="${$(readlink -f "$(command -v gcloud)"):h:h}"
  [ -f "$_gcloud_root/completion.zsh.inc" ] && zsh-defer source "$_gcloud_root/completion.zsh.inc"
fi

# pnpm
if [[ "$OSTYPE" == darwin* ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [ -n "${WSL_DISTRO_NAME}" ]; then
  # Keep it snappy without PATH_DIRS
  unsetopt PATH_DIRS
  
  # Use the right stuff
  export GALLIUM_DRIVER=d3d12
  export LIBVA_DRIVER_NAME=d3d12
fi

# Surface any warnings collected during load (was previously never printed)
_print_warnings

# Load starship
eval "$(starship init zsh)"

if [ -n "$_STARSHIP_TRANSIENT" ]; then
  # Configure transient starship shell
  autoload -Uz add-zsh-hook add-zle-hook-widget

  # Derive the transient prompts from the live PROMPT so they auto-inherit every
  # flag starship passes (--status, --cmd-duration, --jobs, ...). NOTE: this
  # depends on starship emitting the subcommand as " prompt " (space-padded); if
  # that ever changes, these substitutions silently stop matching.
  TRANSIENT_PROMPT="${PROMPT// prompt / prompt --profile transient }"
  TRANSIENT_RPROMPT="${PROMPT// prompt / prompt --profile rtransient }"

  # Collapse the current line into the transient prompt (on Enter, and on Ctrl+C).
  function transient-prompt {
      PROMPT="$SAVED_PROMPT" RPROMPT="$SAVED_RPROMPT" zle .reset-prompt
  }
  # Fix ctrl+c behavior: collapse the prompt even when the line is aborted.
  TRAPINT() { transient-prompt; return $(( 128 + $1 )) }

  # Pre-render the transient prompt while idle so the Enter->collapse is instant.
  # ${(e)...} runs the embedded $(starship ...) natively -- no eval, half the forks.
  function transient-prompt-precmd {
      SAVED_PROMPT="${(e)TRANSIENT_PROMPT}"
      SAVED_RPROMPT="${(e)TRANSIENT_RPROMPT}"
  }

  add-zsh-hook precmd transient-prompt-precmd
  add-zle-hook-widget zle-line-finish transient-prompt
fi

# Toggle to stop profiling, see toggle at top of zshrc
[ -z "$ZPROF" ] || zprof
