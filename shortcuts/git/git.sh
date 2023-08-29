_testGit() {
	_wantGetDep git
}

#Ignores file modes, suitable for use with possibly broken filesystems like NTFS.
_gitCompatible() {
	git -c core.fileMode=false "$@"
}

_gitInfo() {
	#Git Repository Information
	export repoDir="$PWD"

	export repoName=$(basename "$repoDir")
	export bareRepoDir=../."$repoName".git
	export bareRepoAbsoluteDir=$(_getAbsoluteLocation "$bareRepoDir")

	#Set $repoHostName in user ".bashrc" or similar. May also set $repoPort including colon prefix.
	[[ "$repoHostname" == "" ]] && export repoHostname=$(hostname -f)
	
	true
}

_gitRemote() {
	_gitInfo
	
	if [[ -e "$bareRepoDir" ]]
	then
		_showGitRepoURI
		return 0
	fi
	
	if ! [[ -e "$repoDir"/.git ]]
	then
		return 1
	fi
	
	if git config --get remote.origin.url > /dev/null 2>&1
	then
		echo -n "git clone --recursive "
		git config --get remote.origin.url
		return 0
	fi
	_gitBare
}

_gitNew() {
	git init
	git add .
	git commit -a -m "first commit"
	git branch -M main
}

_gitImport() {
	cd "$scriptFolder"
	
	mkdir -p "$1"
	cd "$1"
	shift
	git clone "$@"
	
	cd "$scriptFolder"
}

_findGit_procedure() {
	cd "$1"
	shift
	
	if [[ -e "./.git" ]]
	then
		"$@"
		return 0
	fi
	
	find -L . -mindepth 1 -maxdepth 1 -not \( -path \*_arc\* -prune \) -not \( -path \*/_local/ubcp/\* -prune \) -type d -exec "$scriptAbsoluteLocation" _findGit_procedure '{}' "$@" \;
}

#Recursively searches for directories containing ".git".
_findGit() {
	if [[ -e "./.git" ]]
	then
		"$@"
		return 0
	fi
	
	find -L . -mindepth 1 -maxdepth 1 -not \( -path \*_arc\* -prune \) -not \( -path \*/_local/ubcp/\* -prune \) -type d -exec "$scriptAbsoluteLocation" _findGit_procedure '{}' "$@" \;
}

_gitPull() {
	git pull
	git submodule update --recursive
}

_gitCheck_sequence() {
	echo '-----'
	
	local checkRealpath
	checkRealpath=$(realpath .)
	local checkBasename
	checkBasename=$(basename "$checkRealpath")
	
	echo "$checkBasename"
	
	git status
}

_gitCheck() {
	_findGit "$scriptAbsoluteLocation" _gitCheck_sequence
}

_gitPullRecursive_sequence() {
	echo '-----'
	
	local checkRealpath
	checkRealpath=$(realpath .)
	local checkBasename
	checkBasename=$(basename "$checkRealpath")
	
	echo "$checkBasename"
	
	"$scriptAbsoluteLocation" _gitPull
}

# DANGER
#Updates all git repositories recursively.
_gitPullRecursive() {
	_findGit "$scriptAbsoluteLocation" _gitPullRecursive_sequence
}

# DANGER
# Pushes all changes as a commit described as "Upstream."
_gitUpstream() {
	git add -A . ; git commit -a -m "Upstream." ; git push
}
_gitUp() {
	_gitUpstream
}

# DANGER
#Removes all but the .git folder from the working directory.
#_gitFresh() {
#	find . -not -path '\.\/\.git*' -delete
#}








# DANGER: CAUTION: WARNING: Calls '_git_shallow'.
_git_shallow-ubiquitous() {
	[[ "$1" != "true" ]] && exit 1
	
	_git_shallow 'git@github.com:mirage335/ubiquitous_bash.git' '_lib/ubiquitous_bash'
}

# DANGER: Not robust. May damage repository and/or submodules, as well as any history not remotely available, causing *severe* data loss.
# CAUTION: Intended only for developers to correct a rare mistake of adding a non-shallow git submodule. No production use.
# WARNING: Submodule path must NOT have trailing or preceeding slash!
# "$1" == uri (eg. git@github.com:mirage335/ubiquitous_bash.git)
# "$2" == path/to/submodule (eg. '_lib/ubiquitous_bash')
_git_shallow() {
	[[ "$1" == "" ]] && exit 1
	[[ "$2" == "" ]] && exit 1
	! [[ -e "$2" ]] && exit 1
	! [[ -e "$scriptAbsoluteFolder"/"$2" ]] && exit 1
	cd "$scriptAbsoluteFolder"
	! [[ -e "$2" ]] && exit 1
	! [[ -e "$scriptAbsoluteFolder"/"$2" ]] && exit 1
	
	
	! [[ -e "$scriptAbsoluteFolder"/.gitmodules ]] && exit 1
	! [[ -e "$scriptAbsoluteFolder"/.git/config ]] && exit 1
	
	_start
	
	# https://gist.github.com/myusuf3/7f645819ded92bda6677
	
	# Remove the submodule entry from .git/config
	git submodule deinit -f "$2"

	# Remove the submodule directory from the superproject's .git/modules directory
	#rm -rf .git/modules/"$2"
	export safeToDeleteGit="true"
	_safeRMR "$scriptAbsoluteFolder"/.git/modules/"$2"

	# Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
	git rm -f "$2"
	
	git commit -m "WIP."
	
	
	# https://stackoverflow.com/questions/2144406/how-to-make-shallow-git-submodules
	
	git submodule add --depth 1 "$1" "$2"
	
	git config -f .gitmodules submodule."$2".shallow true
	
	_messagePlain_request git commit -a -m "Draft."
	_messagePlain_request git push
	
	_stop
}


_self_gitMad_procedure() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	cd "$scriptAbsoluteFolder"
	_gitMad
	
	cd "$functionEntryPWD"
}
_self_gitMad() {
	"$scriptAbsoluteLocation" _self_gitMad_procedure "$@"
}
# https://stackoverflow.com/questions/1580596/how-do-i-make-git-ignore-file-mode-chmod-changes
_gitMad() {
	git config core.fileMode false
	git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
	git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git submodule foreach git config core.fileMode false
}


