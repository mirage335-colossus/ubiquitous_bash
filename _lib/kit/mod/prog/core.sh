##### Core

_refresh_overlay() {
	_safeRMR "$scriptModules"/overlay/
	
	# WARNING: Transferring files individually recommended. See second example.
	#mkdir -p "$overlay"
	#cp -a "$app_mod"/. "$overlay"/
	
	mkdir -p "$overlay"/directory
	cp -a "$app_mod"/directory/. "$overlay"/directory
}

# TODO: Not implemented.
_apply_overlay() {
	true
}

_update_mod() {
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	! cd "$app_mod" && return 1
	
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

_update_mod_sequence() {
	"$scriptAbsoluteLocation" _update_mod
}

#"$1" == $modSource
#"$2" == $modDestination
#"$3" == path
_modTransfer() {
	rsync -q -ax --exclude "/.git" "$1"/"$3" "$2"/"$3"
}


#"$1" == "$spliceCodeGitdiff"
#"$2" == "$replacementOne"
#"$3" == "$replacementTwo"
_splice_generator_filter() {
	local spliceCodeGitDiff="$1"
	
	#replacementOne
	local languageName
	languageName="$1"
	sed -i 's/$languageNameProper/'"$languageNameProper"'/g' "$spliceCodeGitDiff"
	
	#replacementTwo
	local languageNameProper
	languageNameProper="$2"
	sed -i 's/$languageName/'"$languageName"'/g' "$spliceCodeGitDiff"
}

#"$1" == "$replacementOne"
#"$2" == "$replacementTwo"
#"$3" == modSource (default, $app_orig)
#"$4" == modDestination  (default, "$scriptLocal"/templates/"$replacementOne")
_construct_feature_sequence() {
	_start
	_prepare_splice
	
	local localFunctionEntryPWD
	localFunctionEntryPWD="$PWD"
	
	#"$replacementOne"
	local languageName
	languageName="$1"
	
	#"$replacementTwo"
	local languageNameProper
	languageNameProper="$2"
	
	#modSource == original files to read for update
	export modSource="$app_orig"
	[[ "$3" != "" ]] && export modSource="$3"
	
	#Uncomment to force augmentation of existing modified version.
	#export modSource="$app_mod"
	
	#modDestination == files to create/update
	export modDestination="$scriptLocal"/templates/"$languageName"
	[[ "$4" != "" ]] && export modDestination="$4"
	
	#Read files.
	! mkdir -p "$modDestination" && _stop 1
	
	_modTransfer "$modSource" "$modDestination" file.sh
	
	#Insert data into splice.
	_modTransfer "$spliceGitdiff" "$spliceTmpGitdiff" .
	
	_splice_generator_filter "$languageName" "$languageNameProper" "$spliceTmpGitdiff"/file.sh
	
	#Track.
	! cd "$modDestination"/ && _stop 1
	! git check-ignore . && _stop 1
	_gitNew
	
	#Substitute, basic modification.
	sed -i 's/pattern/new/g' "$modDestination"/directory/file
	
	find "$modDestination"/directory/directory -name '*.sh' -exec sed -i 's/pattern/new/g' {} \;
	
	#Patch.
	#git apply "$spliceTmpGitdiff"/file.sh.patch
	#git apply "$spliceTmpGitdiff"/directory/patch.patch
	
	patch -p1 < "$spliceTmpGitdiff"/file.sh.patch
	patch -p1 < "$spliceTmpGitdiff"/directory/patch.patch
	
	
	cd "$localFunctionEntryPWD"
	
	
	_stop
}

_construct_feature() {
	"$scriptAbsoluteLocation" _construct_feature_sequence "$@"
}

_construct_feature_name() {
	_construct_feature "name" "NAME" "$@"
}

_augment_feature_name() {
	[[ -e "$scriptLocal"/directory/feature_name ]] && return 1
	
	if ! _construct_feature_name "$app_mod"
	then
		return 1
	fi
	
	rsync -avx --exclude "/.git" "$scriptLocal"/directory/feature_name/. "$app_mod"/
}
_construct() {
	[[ -e "$scriptLocal"/directory/feature_name ]] && return 1
	
	_construct_feature_name
}

_augment() {
	[[ -e "$scriptLocal"/directory/feature_name ]] && return 1
	
	_augment_feature_name
}

#duplicate _anchor
_refresh_anchors() {
	_refresh_anchors_ubiquitous
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_construct
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_augment
}

