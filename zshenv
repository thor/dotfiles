#!/usr/bin/env zsh
# Single source of truth for XDG_CONFIG_HOME: .zshenv is sourced for every zsh
# invocation (login, interactive, and bare `zsh -c` scripts), so tools that
# resolve config via XDG (e.g. Homebrew's trust store) agree across contexts.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# We like our relatively dotless directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

