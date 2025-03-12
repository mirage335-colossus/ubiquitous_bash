


_mitigate-ubcp_rewrite_procedure() {
	[[ "$skimfast" != "true" ]] && _messagePlain_nominal 'init: _mitigate-ubcp_rewrite_procedure'
	[[ "$currentPWD" != "" ]] && cd "$currentPWD"
	local currentRoot=$(_getAbsoluteLocation "$PWD")
	
	local currentLink="$1"
	local currentLinkFile=$(basename "$1" )
	local currentLinkFolder=$(dirname "$1")
	currentLinkFolder=$(_getAbsoluteLocation "$currentLinkFolder")
	
	local currentLinkDirective=$(readlink "$1")
	
	
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentRoot
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLink
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLinkFile
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLinkFolder
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentLinkDirective
	
	[[ "$currentLinkDirective" == '/proc/'* ]] && return 0
	[[ "$currentLinkDirective" == '/dev/'* ]] && return 0
	
	
	
	local currentRelativeRoot
	local currentLinkFolder_eval
	
	local currentDots='..'
	
	local currentMatch=false
	local currentIterations=0
	
	if [[ "$currentLinkFolder" == "$currentRoot" ]]
	then
		currentRelativeRoot='.'
		currentMatch='true'
	else
		while [[ "$currentMatch" == 'false' ]] && [[ "$currentIterations" -lt 14 ]]
		do
			[[ "$skimfast" != "true" ]] && _messagePlain_probe "$currentLinkFolder"/"$currentDots"
			currentLinkFolder_eval=$(_getAbsoluteLocation "$currentLinkFolder"/"$currentDots")
			[[ "$currentLinkFolder_eval" == "$currentRoot" ]] && currentMatch='true'
			
			if [[ "$currentMatch" == 'true' ]]
			then
				currentRelativeRoot="$currentDots"
			elif [[ "$currentMatch" == 'false' ]]
			then
				currentDots='../'"$currentDots"
				let currentIterations="$currentIterations"+1
			fi
		done
	fi
	
	
	
	
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var currentRelativeRoot
	
	
	local processedLinkDirective
	
	if [[ "$currentLinkDirective" == '/'* ]]
	then
		processedLinkDirective="$currentRelativeRoot""$currentLinkDirective"
		
	fi
	
	[[ "$skimfast" != "true" ]] && _messagePlain_probe_var processedLinkDirective
	
	
	
	if [[ "$currentLinkDirective" == '/'* ]]
	then
		cd "$currentLinkFolder"
		
		[[ "$skimfast" != "true" ]] && ls -l "$processedLinkDirective"
		
		
		# ATTENTION: Forces scenario '2'!
		# CAUTION: Three possible scenarios to consider.
		# 2) Symlinks rewritten to '/bin'. Links now pointing to '/bin' should return files when retrieved through network drive, without this link.
		# In any case, Cygwin will not be managing this directory .
		if [[ "$mitigate_ubcp_modifySymlink" == 'true' ]]
		then
			if [[ "$currentLinkDirective" == '/usr/bin/'* ]]
			then
				processedLinkDirective="${processedLinkDirective/'/usr/bin/'/'/bin/'}"
			fi
		fi
		
		
		
		ln -sf "$processedLinkDirective" "$currentLinkFolder"/"$currentLinkFile"
		
		[[ "$skimfast" != "true" ]] && ls -ld "$currentLinkFolder"/"$currentLinkFile"
		[[ "$skimfast" != "true" ]] && [[ -d "$currentLinkFolder"/"$currentLinkFile" ]] && ls -l "$currentLinkFolder"/"$currentLinkFile"
		
		#rm -f "$currentLink"
		##currentLink=$(_getAbsoluteLocation "$currentLink)
		##cd "$currentLinkFolder"
		#ln -sf "$currentLinkDirective" "$currentLink"
		# ... replace symlink with file if not also a symlink
		
		cd "$outerPWD"
	fi
	
	# ATTENTION: Forces scenario '3'!
	# CAUTION: Three possible scenarios to consider.
	# 3) Symlinks replaced. No links, files only.
	if [[ "$mitigate_ubcp_replaceSymlink" == 'true' ]]
	then
		cd "$currentLinkFolder"
		
		[[ "$skimfast" != "true" ]] && ls -ld "$currentLinkFolder"/"$currentLinkFile"
		
		
		
		[[ "$skimfast" != "true" ]] && _messagePlain_nominal 'directive: replace: true'
		cp -L -R --preserve=all "$currentLinkFolder"/"$currentLinkFile" "$currentLinkFolder"/"$currentLinkFile".replace
		rm -f "$currentLinkFolder"/"$currentLinkFile"
		mv "$currentLinkFolder"/"$currentLinkFile".replace "$currentLinkFolder"/"$currentLinkFile"
		
		[[ "$skimfast" != "true" ]] && ls -ld "$currentLinkFolder"/"$currentLinkFile"
		[[ "$skimfast" != "true" ]] && [[ -d "$currentLinkFolder"/"$currentLinkFile" ]] && ls -l "$currentLinkFolder"/"$currentLinkFile"
		
		cd "$outerPWD"
	fi
	
	
	
	return 0
}

# WARNING: May be untested.
_mitigate-ubcp_rewrite_parallel() {
	local currentArg
	for currentArg in "$@"
	do
		true
		
		_mitigate-ubcp_rewrite_procedure "$currentArg"
		
		# WARNING: May be untested.
		#_mitigate-ubcp_rewrite_procedure "$currentArg" &
		
		#/bin/echo "$currentArg" > /dev/tty
	done
}

_mitigate-ubcp_rewrite_sequence() {
	export safeToDeleteGit="true"
	! _safePath "$1" && _stop 1
	cd "$1"
	
	
	# WARNING: May be slow (multiple hours).
	unset currentPWD
	#find "$2" -type l -exec "$scriptAbsoluteLocation" _mitigate-ubcp_rewrite_procedure '{}' \;
	
	
	# WARNING: May be untested.
	# https://stackoverflow.com/questions/4321456/find-exec-a-shell-function-in-linux
	# Since only the shell knows how to run shell functions, you have to run a shell to run a function.
	# export -f dosomething
	# find . -exec bash -c 'dosomething "$0"' {} \;
	unset currentPWD
	export currentPWD="$PWD"
	#export currentPWD="$1"
	unset currentFile
	export -f "_mitigate-ubcp_rewrite_procedure"
	export -f "_messagePlain_nominal"
	export -f "_color_begin_nominal"
	export -f "_color_end"
	export -f "_getAbsoluteLocation"
	export -f "_realpath_L_s"
	export -f "_realpath_L"
	export -f "_compat_realpath_run"
	export -f "_compat_realpath"
	export -f "_messagePlain_probe_var"
	export -f "_color_begin_probe"
	export -f "_messagePlain_probe"
	#find "$2" -print0 | while IFS= read -r -d '' currentFile; do _mitigate-ubcp_rewrite_procedure "$currentFile"; done
	
	
	
	# WARNING: May be untested.
	##find "$2" -type l -exec bash -c '_mitigate-ubcp_rewrite_procedure "$1"' _ {} \;
	
	
	#_experimentInteractive ()
	#{
		#echo begin: "$@";
		#sleep 1;
		#echo end
	#}
	#export -f _experimentInteractive
	#seq 1 500 | xargs -x -s 4096 -L 6 -P 4 bash -c 'echo begin: "$@" ; sleep 1 ; echo end' _
	#seq 1 500 | xargs -x -s 4096 -L 6 -P 4 bash -c '_experimentInteractive "$@"' _

	
	# WARNING: Diagnostic output will be corrupted by parallelism.
	# ATTENTION: Expect as much as 4x as many CPU threads may be saturated due to MSW (MSW, NOT Cygwin) inefficiencies.
	# Or only 2x if CPU has leading single-thread (ie. per-thread) performance and MSW inefficiencies have been reduced.
	# Expect done in as little as 15 minutes.
	# https://serverfault.com/questions/193319/a-better-unix-find-with-parallel-processing
	# https://stackoverflow.com/questions/11003418/calling-shell-functions-with-xargs
	export -f "_mitigate-ubcp_rewrite_parallel"
	find "$2" -type l -print0 | xargs -0 -x -s 4096 -L 6 -P $(nproc) bash -c '_mitigate-ubcp_rewrite_parallel "$@"' _
	#find "$2" -type l -print0 | xargs -0 -n 1 -P 4 -I {} bash -c '_mitigate-ubcp_rewrite_parallel "$@"' _ {}
	#find "$2" -type l -print0 | xargs -0 -n 1 -P 4 -I {} bash -c '_mitigate-ubcp_rewrite_procedure "$@"' _ {}
	
	return 0
}

_mitigate-ubcp_rewrite() {
	"$scriptAbsoluteLocation" _mitigate-ubcp_rewrite_sequence "$@"

	# CAUTION: This may not catch mitigate failure . The actual issue with 'getconf' was removal of the 'ARG_MAX' value , which was not caused by mitigate failure .
	if [[ ! -e /usr/bin/getconf ]]
	then
		_messagePlain_bad 'missing: bad: /usr/bin/getconf'
		echo 'Usually, this is a symlink, if missing, indicative of failed symlink mitigation due to xargs parameter length or parallelism failure.'
		_messageFAIL
		_stop 1
		return 1
	fi
	return 0
}




_mitigate-ubcp_procedure() {
	export safeToDeleteGit="true"
	! _safePath "$1" && _stop 1
	
	# DANGER: REQUIRED for symbolic links to be valid as necessary during rewrite/replace algorithm.
	ln -s "$1"/bin "$1"/usr/bin
	
	_mitigate-ubcp_rewrite "$1" "$1"/etc/alternatives
	
	_mitigate-ubcp_rewrite "$1" "$1"/bin
	_mitigate-ubcp_rewrite "$1" "$1"/usr/share
	_mitigate-ubcp_rewrite "$1" "$1"/usr/libexec
	_mitigate-ubcp_rewrite "$1" "$1"/lib
	_mitigate-ubcp_rewrite "$1" "$1"/etc/pki
	_mitigate-ubcp_rewrite "$1" "$1"/etc/ssl
	_mitigate-ubcp_rewrite "$1" "$1"/etc/crypto-policies
	_mitigate-ubcp_rewrite "$1" "$1"/etc/mc
	
	_mitigate-ubcp_rewrite "$1" "$1"/opt
	
	
	
	
	
	# CAUTION: Three possible scenarios to consider.
	# 1) Symlinks rewritten as is to '/usr/bin'. Links pointing to '/usr/bin' directory will not work through network drive unless this link remains.
		# PREVENT - ' rm -f "$1"/usr/bin ' .
		# Tested - known working ( _userVBox , _userQemu ) .
	# 2) Symlinks rewritten to '/bin'. Links now pointing to '/bin' should return files when retrieved through network drive, without this link.
		# ALLOW - ' rm -f "$1"/usr/bin ' .
		# Tested - known working ( _userVBox , _userQemu ) .
	# 3) Symlinks replaced. No links, files only.
		# ALLOW - ' rm -f "$1"/usr/bin ' 
		# Tested - known working ( _userVBox , _userQemu ) .
	# In any case, Cygwin will not be managing this directory .
	( [[ "$mitigate_ubcp_replaceSymlink" == 'true' ]] || [[ "$mitigate_ubcp_modifySymlink" == 'true' ]] ) && rm -f "$1"/usr/bin
}




_mitigate-ubcp_directory() {
	mkdir -p "$safeTmp"/package/_local
	
	if [[ -e "$scriptLocal"/ubcp/cygwin ]]
	then
		_mitigate-ubcp_procedure "$scriptLocal"/ubcp/cygwin
		return 0
	fi
# 	if [[ -e "$scriptLib"/ubcp/cygwin ]]
# 	then
# 		_mitigate-ubcp_procedure "$scriptLib"/ubcp/cygwin
# 		return 0
# 	fi
# 	if [[ -e "$scriptAbsoluteFolder"/ubcp/cygwin ]]
# 	then
# 		_mitigate-ubcp_procedure "$scriptAbsoluteFolder"/ubcp/cygwin
# 		return 0
# 	fi
	
	
	export mitigate_ubcp_replaceSymlink='false'
	cd "$outerPWD"
	_stop 1
}

# ATTENTION: Override with 'ops' or similar.
_mitigate-ubcp() {
	export mitigate_ubcp_modifySymlink='true'
	export mitigate_ubcp_replaceSymlink='false'
	_mitigate-ubcp_directory "$@"
	
	export mitigate_ubcp_replaceSymlink='true'
	_mitigate-ubcp_directory "$@"
}

