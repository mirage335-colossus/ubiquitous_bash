
#_set_GH_TOKEN() {
	#[[ "$GH_TOKEN" != "" ]] && export GH_TOKEN=$(_safeEcho "$GH_TOKEN" | tr -dc 'a-zA-Z0-9_')
	#[[ "$INPUT_GITHUB_TOKEN" != "" ]] && export INPUT_GITHUB_TOKEN=$(_safeEcho "$INPUT_GITHUB_TOKEN" | tr -dc 'a-zA-Z0-9_')
#}
#_set_GH_TOKEN

