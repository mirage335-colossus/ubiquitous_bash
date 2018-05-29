export app_orig="$scriptLib"/app
export app_mod="$scriptLib"/modName



export scriptModules="$scriptLib"/modules

export overlay="$scriptModules"/overlay

export splice="$scriptModules"/splice
export spliceGitdiff="$scriptModules"/splice/gitdiff

export spliceTmp="$safeTmp"/splice
export spliceTmpGitdiff="$spliceTmp"/gitdiff

_prepare_splice() {
	mkdir -p "$spliceTmp"
	mkdir -p "$spliceTmpGitdiff"
}

_prepare_prog() {
	true
}
