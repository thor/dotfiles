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
