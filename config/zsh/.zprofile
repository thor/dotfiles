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
export FZF_DEFAULT_COMMAND='fd --color=never'
export DIFFPROG='nvim -d'
export FZF_DEFAULT_COMMAND='fd --color=never -IH -E .git'

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

# Set up GOPATH
export GOPATH=~/dev/go

# Setup direnv
eval "$(direnv hook zsh)"

# 
# Special locations
#

# - Configure virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs"

# - Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

