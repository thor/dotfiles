# - Contains various personal aliases and configuratios that always happen
function _warn {
	printf "WARN: %s\n" "$@" 1>&2
}

# - help source files when they could be in different locations
function _source_first {
	for target in "$@"; do
		if [ -f "$target" ]; then
			source "$target"
			return
		fi
	done
	_warn "Failed to source one of $@ because none exists"
}

# - help select first file/directory that exists
function _select_first {
	for target in "$@"; do
		if [ -e "$target" ]; then
			echo "$target"
			return
		fi
	done
	_warn "Failed to select one from $* because none exists"
	exit 1
}

# - check if executable exists
function _exists {
	command -v "$1" 2>&1 >/dev/null
}

# - get brew prefix
function _bp {
	brew --prefix "$@"
}

# - get brew caskroom
function _bcp {
	brew --caskroom "$@"
}

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

