# - Claude Code: preload a Bun hook that turns off the agent_summary side-query
#   Source: https://gist.github.com/flamerix-ai/c3905705cc4205e5de3011fa2e74efce
#   Env: CC_AGENT_SUMMARY_MODE=off|pass, CC_AGENT_SUMMARY_LOG=<file>
#   A --preload naming a missing file stops claude from starting, so only add it if present.
() {
	local hook=$HOME/.local/lib/no-agent-summary.js
	if [[ ! -f $hook ]]; then
		_warn "Missing $hook, Claude Code agent summaries stay on"
		return
	fi
	[[ " ${BUN_OPTIONS-} " == *" --preload=$hook "* ]] && return
	export BUN_OPTIONS="${BUN_OPTIONS:+$BUN_OPTIONS }--preload=$hook"
}
