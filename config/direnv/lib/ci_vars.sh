#!/bin/bash

function use_ci_vars() {
	urlencode () { [[ "${1}" ]] || return 1; local LANG=C i x; for (( i = 0; i < ${#1}; i++ )); do x="${1:i:1}"; [[ "${x}" == [a-zA-Z0-9.~_-] ]] && echo -n "${x}" || printf '%%%02X' "'${x}"; done; echo; }

	repo_remote=$(git remote get-url origin)
	repo_project=${repo_remote#*:}
	repo_project=${repo_project%.git}
	repo_project_url=$(urlencode "$repo_project")

	workspace="$(terraform workspace show | tr '-' '/')"

	repo_vars=$(glab api "projects/$repo_project_url/variables")
	repo_vars_exports=$(echo "$repo_vars" | jq -r ".[] | select(.environment_scope == \"$workspace\", .environment_scope == \"*\") | \"export \(.key)='\(.value)'\"")

	eval "$repo_vars_exports"
}
