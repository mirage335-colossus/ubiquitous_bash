
<< 'EXPLANATION'

Cygwin installations may create links which are not portable due to (1) symlinks using DUBIOUS path, or (2) symlinks that are not portable due to  other issue entirely.

Two mitigation passes are done by _mitigate-ubcp .

First pass rewrites symlinks to use relative links OR /bin links, correcting issues with (1) symlinks using DUBIOUS path.
Second pass replaces symlinks entirely with copied files, correcting issues with (2) symlinks that are not portable due to  other issue entirely.

DUBIOUS path may not be clearly defined at this time. Some directories created by Cygwin may have originally pointed to directories which were themselves symlinks, and that may have been non-portable. Absolute paths outside of Cygwin's root filesystem may also have existed, and would not have been portable. Future-proofing resilience in this case may have been attepted thorugh sledgehammer, and with issues emerging with some /etc files symlinks not getting rewritten adequately, the sledgehammer may not have been heavy enough.

EXPLANATION



<< 'DIAGRAM'
_mitigate-ubcp()
    |___ _mitigate-ubcp_directory()
            |___ _mitigate-ubcp_procedure()
			    |___ _mitigate-ubcp_rewrite()
DIAGRAM

# Calls _mitigate-ubcp_directory , twice .
_mitigate-ubcp() {
	export mitigate_ubcp_modifySymlink='true'
	export mitigate_ubcp_replaceSymlink='false'
	_mitigate-ubcp_directory "$@"
	
	
	# !!! mitigate_ubcp_replaceSymlink changes from false to true !!!
	export mitigate_ubcp_replaceSymlink='true'
	_mitigate-ubcp_directory "$@"
}
_mitigate-ubcp_directory() {
	#...
	_mitigate-ubcp_procedure "$scriptLocal"/ubcp/cygwin
	#...
}
_mitigate-ubcp_procedure() {
	#...
	_mitigate-ubcp_rewrite "$1" "$1"/etc/crypto-policies
	#...
}



<< 'DIAGRAM'
_mitigate-ubcp_rewrite()
|_ _mitigate-ubcp_rewrite_sequence()
    |___ find/xargs
        |___ _mitigate-ubcp_rewrite_parallel()
            |___ _mitigate-ubcp_rewrite_procedure()
DIAGRAM

_mitigate-ubcp_rewrite() {
	"$scriptAbsoluteLocation" _mitigate-ubcp_rewrite_sequence "$@"
	#...
}
_mitigate-ubcp_rewrite_sequence() {
	## "$1" (ie. "$scriptLocal"/ubcp/cygwin)
	cd "$1"
	export currentPWD="$PWD"
	#...

	# Slow. Discouraged.
	#_mitigate-ubcp_rewrite_procedure

	export -f "_mitigate-ubcp_rewrite_parallel"
	## "$2" (eg. "$1"/etc/crypto-policies)
	find "$2" -type l -print0 | xargs ... bash -c '_mitigate-ubcp_rewrite_parallel "$@"' _
}

_mitigate-ubcp_rewrite_parallel() {
	local currentArg
	for currentArg in "$@"
	do
		_mitigate-ubcp_rewrite_procedure "$currentArg"
	done
}

_mitigate-ubcp_rewrite_procedure() {
	#...
	local currentLinkDirective=$(readlink "$1")
	#...
	local currentRelativeRoot="$currentDots"
	#...

	local processedLinkDirective

	## Default scenario '1'.
	if [[ "$currentLinkDirective" == '/'* ]]
	then
		processedLinkDirective="$currentRelativeRoot""$currentLinkDirective"
		
	fi

	if [[ "$currentLinkDirective" == '/'* ]]
	then
		cd "$currentLinkFolder"

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
		#...
	fi


	# ATTENTION: Forces scenario '3'!
	# CAUTION: Three possible scenarios to consider.
	# 3) Symlinks replaced. No links, files only.
	if [[ "$mitigate_ubcp_replaceSymlink" == 'true' ]]
	then
		cd "$currentLinkFolder"
		
		cp -L -R --preserve=all "$currentLinkFolder"/"$currentLinkFile" "$currentLinkFolder"/"$currentLinkFile".replace
		rm -f "$currentLinkFolder"/"$currentLinkFile"
		mv "$currentLinkFolder"/"$currentLinkFile".replace "$currentLinkFolder"/"$currentLinkFile"
		#...
	fi
	#...
}





