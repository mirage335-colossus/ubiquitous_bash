

<< 'TODO'
+) Why does  ./_bin _mitigate-ubcp  from within a PowerShell session create improperly named (ie. without '.lnk' file extension) shortcuts files for /etc/crypto-policies ?
 >+) Apparently, at least in some situations, the 'ln -sf' command under Cygwin/MSW only correctly creates an '.lnk' file properly if the existing link does not exist.
  *) TODO - Test what those conditions are.

TODO

<< 'PROMPT'


PROMPT

<< 'SCRATCH'
./setup-x86_64.exe --no-admin --site 'https://ftp.snt.utwente.nl/pub/software/cygwin/' --root 'C:\Users\mirag\Downloads\package_ubcp-core\ubcp\cygwin' --local-package-dir 'C:\Users\mirag\Downloads\package_ubcp-core\ubcp\cygwin\.pkg-cache' --no-shortcuts --no-desktop --delete-orphans --upgrade-also --no-replaceonreboot --quiet-mode --packages dialog

cp -a 'C:\Users\mirag\Downloads\package_ubcp-core\ubcp\cygwin' 'C:\q\p\zCore\infrastructure\ubiquitous_bash\_local\ubcp\cygwin - backup'

#WinMerge 'C:\q\p\zCore\infrastructure\ubiquitous_bash\_local\ubcp\cygwin' 'C:\q\p\zCore\infrastructure\ubiquitous_bash\_local\ubcp\cygwin - backup'
# /etc/crypto-policies/back-ends


./ubiquitous_bash.sh _mitigate-ubcp_rewrite $(_getAbsoluteLocation ./_local/ubcp/cygwin) $(_getAbsoluteLocation ./_local/ubcp/cygwin/etc/crypto-policies)
./_bin _mitigate-ubcp_rewrite /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/ubcp/cygwin /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/ubcp/cygwin/etc/crypto-policies


./_bash
ls -ld /etc/crypto-policies/back-ends/gnutls.config
cat /etc/crypto-policies/back-ends/gnutls.config


# ops.sh
_experiment() {
    #set "CYGWIN=winsymlinks:lnk nodosfilewarning"
    #export CYGWIN="$CYGWIN winsymlinks:lnk nodosfilewarning"

	#export mitigate_ubcp_modifySymlink='true'
	#export mitigate_ubcp_replaceSymlink='false'
	##"$scriptAbsoluteLocation" _mitigate-ubcp_directory "$@"
    #_mitigate-ubcp_rewrite "$scriptLocal"/ubcp/cygwin "$scriptLocal"/ubcp/cygwin/etc/crypto-policies
	
	#export mitigate_ubcp_replaceSymlink='true'
	##"$scriptAbsoluteLocation" _mitigate-ubcp_directory "$@"
    #_mitigate-ubcp_rewrite "$scriptLocal"/ubcp/cygwin "$scriptLocal"/ubcp/cygwin/etc/crypto-policies

    
    cd /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/ubcp/cygwin/etc/crypto-policies/back-ends
    ln -sf "../../../usr/share/crypto-policies/DEFAULT/gnutls.txt" "/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/ubcp/cygwin/etc/crypto-policies/back-ends"/"gnutls.config"

    _messagePlain_probe 'ls -l /etc/crypto-policies/back-ends/gnutls.config'
    ls -l /etc/crypto-policies/back-ends/gnutls.config

    _messagePlain_probe 'cat /etc/crypto-policies/back-ends/gnutls.config'
    cat /etc/crypto-policies/back-ends/gnutls.config

    sleep 90
}

.\_bin _experiment


.\_bash
#
#cd /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/ubcp/cygwin/etc/crypto-policies/back-ends
#ln -sf "../../../usr/share/crypto-policies/DEFAULT/gnutls.txt" "/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/ubcp/cygwin/etc/crypto-policies/back-ends"/"gnutls.config" ; ls -l /etc/crypto-policies/back-ends/gnutls.config
#ls -l /etc/crypto-policies/back-ends/gnutls.config
#
#cd /etc/crypto-policies/back-ends
#ln -sf "../../../usr/share/crypto-policies/DEFAULT/gnutls.txt" "/etc/crypto-policies/back-ends"/"gnutls.config" ; ls -l /etc/crypto-policies/back-ends/gnutls.config
#
#ln -sf ../../../bin/echo ./echo
#
#ln -sf "../../../usr/share/crypto-policies/DEFAULT/gnutls.txt" ./"gnutls.config" ; ls -l /etc/crypto-policies/back-ends/gnutls.config
#
# ATTENTION
#rm -f "/etc/crypto-policies/back-ends"/"gnutls.config" ; ln -sf "../../../usr/share/crypto-policies/DEFAULT/gnutls.txt" "/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/_local/ubcp/cygwin/etc/crypto-policies/back-ends"/"gnutls.config" ; ls -l /etc/crypto-policies/back-ends/gnutls.config

SCRATCH


<< 'EXPLANATION'

Cygwin installations may create links which are not portable.

Two mitigation passes are done by _mitigate-ubcp .

First pass forces scenario 2 if additional conditions are met.

Second pass forces scenario 3 .

EXPLANATION

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
	( [[ "$mitigate_ubcp_replaceSymlink" == 'true' ]] || [[ "$mitigate_ubcp_modifySymlink" == 'true' ]] ) && rm -f "$1"/usr/bin
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





