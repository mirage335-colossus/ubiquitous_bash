export blockly_orig="$scriptLib"/blockly
export SigBlockly_mod="$scriptLib"/SigBlockly

export generatorSource=generators/"$modLanguageName"
export generatorSourceEntry=generators/"$modLanguageName".js


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
