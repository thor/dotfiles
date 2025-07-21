#!/bin/sh
layout_poetry() {
	PYPROJECT_TOML="${PYPROJECT_TOML:-pyproject.toml}"
	if [ ! -f "$PYPROJECT_TOML" ]; then
		log_status "No pyproject.toml found. Executing \`poetry init\` to create a \`$PYPROJECT_TOML\` first."
		poetry init
	fi

	# Avoid quirky problems
	unset VIRTUAL_ENV
	if [ -d ".venv" ]; then
		VIRTUAL_ENV="$(pwd)/.venv"
	else
		VIRTUAL_ENV=$(
			poetry env info --path 2>/dev/null
			true
		)
	fi

	if [ -z "$VIRTUAL_ENV" ] || [ ! -d "$VIRTUAL_ENV" ]; then
		log_status "No virtual environment exists. Executing \`poetry install\` to create one."
		poetry install
		VIRTUAL_ENV=$(poetry env info --path)
	fi

	if [ -z "$VIRTUAL_ENV" ]; then
		log_warning "Potentially missing requisite version, can't prepare virtual environment"
		unset VIRTUAL_ENV
	fi

	PATH_add "$VIRTUAL_ENV/bin"
	export POETRY_ACTIVE=1
	export VIRTUAL_ENV
	log_status "Configured Poetry with the virtual environment '$VIRTUAL_ENV'"
}
