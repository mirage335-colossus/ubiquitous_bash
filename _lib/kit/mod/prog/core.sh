##### Core

_refresh_overlay() {
	_safeRMR "$scriptModules"/overlay/
	
	mkdir -p "$overlay"/
	cp -a "$SigBlockly_mod"/_code.html "$overlay"/
	cp -a "$SigBlockly_mod"/_blockfactory.html "$overlay"/
	
	mkdir -p "$overlay"/blocks/
	cp -a "$SigBlockly_mod"/blocks/arbitrary.js "$overlay"/blocks/arbitrary.js
	
	mkdir -p "$overlay"/generators/bash/
	mkdir -p "$overlay"/generators/c/
	cp -a "$SigBlockly_mod"/generators/bash/. "$overlay"/generators/bash/
	cp -a "$SigBlockly_mod"/generators/c/. "$overlay"/generators/c/
	
	mkdir -p "$overlay"/generators/bash/
	mkdir -p "$overlay"/generators/c/
	mkdir -p "$overlay"/generators/dart/
	mkdir -p "$overlay"/generators/javascript/
	mkdir -p "$overlay"/generators/lua/
	mkdir -p "$overlay"/generators/php/
	mkdir -p "$overlay"/generators/python/
	cp -a "$SigBlockly_mod"/generators/bash/arbitrary.js "$overlay"/generators/bash/
	cp -a "$SigBlockly_mod"/generators/c/arbitrary.js "$overlay"/generators/c/
	cp -a "$SigBlockly_mod"/generators/dart/arbitrary.js "$overlay"/generators/dart/
	cp -a "$SigBlockly_mod"/generators/javascript/arbitrary.js "$overlay"/generators/javascript/
	cp -a "$SigBlockly_mod"/generators/lua/arbitrary.js "$overlay"/generators/lua/
	cp -a "$SigBlockly_mod"/generators/php/arbitrary.js "$overlay"/generators/php/
	cp -a "$SigBlockly_mod"/generators/python/arbitrary.js "$overlay"/generators/python/
	
	mkdir -p "$overlay"/demos/code/
	cp -a "$SigBlockly_mod"/demos/code/. "$overlay"/demos/code/
}

# TODO: Not implemented.
_apply_overlay() {
	true
}

_update_SigBlockly() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	! cd "$SigBlockly_mod" && return 1
	
	git reset --hard
	
	#git pull upstream master
	
	#https://stackoverflow.com/questions/15232000/git-ignore-files-during-merge
	#https://stackoverflow.com/questions/41101998/git-checkout-vs-git-checkout
	git merge --no-ff --no-commit upstream/master
	git reset HEAD LICENSE
	git reset HEAD README.md
	git checkout -- LICENSE
	git checkout -- README.md
	#git commit -m "merged <merge-branch>"
	
	
	cd "$localFunctionEntryPWD"
}

#"$1" == $modSource
#"$2" == $modDestination
#"$3" == path
_modTransfer() {
	rsync -q -ax --exclude "/.git" "$1"/"$3" "$2"/"$3"
}

#languageName == "$1"
#languageNameProper == "$2"
#spliceCodeGitdiff == "$3"
_splice_generator_filter() {
	local languageName
	languageName="$1"
	local languageNameProper
	languageNameProper="$2"
	local spliceCodeGitdiff
	spliceCodeGitdiff="$3"
	
	sed -i 's/$languageNameProper/'"$languageNameProper"'/g' "$3"
	sed -i 's/$languageName/'"$languageName"'/g' "$3"
}

#"$1" == languageName
#"$2" == languageNameProper
#"$3" == modSource (default, $blockly_orig)
#"$4" == modDestination  (default, "$scriptLocal"/templates/"$languageName")
_construct_generator_sequence() {
	_start
	_prepare_splice
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	local languageName
	languageName="$1"
	local languageNameProper
	languageNameProper="$2"
	
	#modSource == original files to modify
	export modSource="$blockly_orig"
	#export modSource="$SigBlockly_mod"
	export modDestination="$scriptLocal"/templates/"$languageName"
	
	[[ "$3" != "" ]] && export modSource="$3"
	[[ "$4" != "" ]] && export modDestination="$4"
	
	#Files.
	! mkdir -p "$modDestination" && _stop 1
	! mkdir -p "$modDestination"/demos/code && _stop 1
	! mkdir -p "$modDestination"/generators && _stop 1
	
	_modTransfer "$modSource" "$modDestination" build.py
	
	_modTransfer "$modSource" "$modDestination" demos/code/index.html
	_modTransfer "$modSource" "$modDestination" demos/code/code.js
	
	_modTransfer "$modSource" "$modDestination" "$generatorSource"/
	_modTransfer "$modSource" "$modDestination" "$generatorSource".js
	
	mv "$modDestination"/"$generatorSource" "$modDestination"/generators/"$languageName"
	mv "$modDestination"/"$generatorSource".js "$modDestination"/generators/"$languageName".js
	
	#Splice.
	_modTransfer "$spliceGitdiff" "$spliceTmpGitdiff" .
	
	_splice_generator_filter "$languageName" "$languageNameProper" "$spliceTmpGitdiff"/language/build.py.patch
	_splice_generator_filter "$languageName" "$languageNameProper" "$spliceTmpGitdiff"/language/demos/code/code.js.patch
	_splice_generator_filter "$languageName" "$languageNameProper" "$spliceTmpGitdiff"/language/demos/code/index.html.patch
	
	#Track.
	! cd "$modDestination"/ && _stop 1
	! git check-ignore . && _stop 1
	
	_gitNew
	
	#Substitute.
	sed -i 's/Blockly.Generator('\'''"$modLanguageNameProper"''\'')/Blockly.Generator('\'''"$languageName"''\'')/g' "$modDestination"/generators/"$languageName".js
	sed -i 's/Blockly\.'"$modLanguageNameProper"'/Blockly\.'"$languageName"'/g' "$modDestination"/generators/"$languageName".js
	
	find "$modDestination"/generators/"$languageName" -name '*.js' -exec sed -i 's/Blockly\.'"$modLanguageNameProper"'/Blockly\.'"$languageName"'/g' {} \;
	
	#Patch.
	#git apply "$spliceTmpGitdiff"/language/build.py.patch
	#git apply "$spliceTmpGitdiff"/language/demos/code/code.js.patch
	#git apply "$spliceTmpGitdiff"/language/demos/code/index.html.patch
	patch -p1 < "$spliceTmpGitdiff"/language/build.py.patch
	patch -p1 < "$spliceTmpGitdiff"/language/demos/code/code.js.patch
	patch -p1 < "$spliceTmpGitdiff"/language/demos/code/index.html.patch
	
	
	cd "$localFunctionEntryPWD"
	
	
	_stop
}

_construct_generator() {
	"$scriptAbsoluteLocation" _construct_generator_sequence "$@"
}

_construct_generator_c() {
	_construct_generator "c" "C" "$@"
}

_augment_generator_c() {
	[[ -e "$scriptLocal"/templates/c ]] && return 1
	
	if ! _construct_generator_c "$SigBlockly_mod"
	then
		return 1
	fi
	
	rsync -avx --exclude "/.git" "$scriptLocal"/templates/c/. "$SigBlockly_mod"/
}

_construct_generator_bash() {
	_construct_generator "bash" "BASH" "$@"
}

_augment_generator_bash() {
	[[ -e "$scriptLocal"/templates/bash ]] && return 1
	
	if ! _construct_generator_bash "$SigBlockly_mod"
	then
		return 1
	fi
	
	rsync -avx --exclude "/.git" "$scriptLocal"/templates/bash/. "$SigBlockly_mod"/
}

_construct() {
	[[ -e "$scriptLocal"/templates/c ]] && return 1
	[[ -e "$scriptLocal"/templates/bash ]] && return 1
	
	_construct_generator_c
	_construct_generator_bash
}

_augment() {
	[[ -e "$scriptLocal"/templates/c ]] && return 1
	[[ -e "$scriptLocal"/templates/bash ]] && return 1
	
	_augment_generator_c
	_augment_generator_bash
}

