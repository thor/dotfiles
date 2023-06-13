#!/usr/bin/env zsh

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

# Friendly fzf-based fixup picker
function gcff() {
	commits="$(git log --topo-order --color --pretty=format:"%C(green)%h%C(reset) %s%C(red)%d%C(reset)")"
	if [ "$?" != "0" ]; then
		return 0
	fi

	commit="$(echo "$commits" | fzf --no-sort --reverse --height 15% --ansi | cut -d' ' -f1)"
	if [ -z "$commit" ]; then
		return 0
	fi

	git commit --fixup "$commit" "$@"
}
