
_setupUbiquitous_safe_bashrc() {

cat << CZXWXcRMTo8EmM8i4d
#Generates semi-random alphanumeric characters, default length 18.
#_uid() {
	#local currentLengthUID
	#currentLengthUID="\$1"
	#[[ "\$currentLengthUID" == "" ]] && currentLengthUID=18
	#cat /dev/random 2> /dev/null | base64 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | tr -d 'acdefhilmnopqrsuvACDEFHILMNOPQRSU14580' | head -c "\$currentLengthUID" 2> /dev/null
	#return
#}
_safe_declare_uid
CZXWXcRMTo8EmM8i4d

}

_setupUbiquitous_here() {
	! uname -a | grep -i cygwin > /dev/null 2>&1 && cat << CZXWXcRMTo8EmM8i4d

if type sudo > /dev/null 2>&1 && groups | grep -E 'wheel|sudo' > /dev/null 2>&1 && ! uname -a | grep -i cygwin > /dev/null 2>&1
then
	# Greater or equal, '_priority_critical_pid_root' .
	sudo -n renice -n -15 -p \$\$ > /dev/null 2>&1
	sudo -n ionice -c 2 -n 2 -p \$\$ > /dev/null 2>&1
fi

# ^
# Ensures admin user shell startup, including Ubiquitous Bash, is relatively quick under heavy system load.
# Near-realtime priority may be acceptable, due to reliability of relevant Ubiquitous Bash functions.
# WARNING: Do NOT prioritize highly enough to interfere with embedded hard realtime processes.

# WARNING: Do NOT use 'ubKeep_LANG' unless necessary!
# nix-shell --run "locale -a" -p bash
#  C   C.utf8   POSIX
[[ "\$ubKeep_LANG" != "true" ]] && [[ "\$LANG" != "C" ]] && export LANG="C"

# Not known or expected to cause significant issues. Not known to affect 'ubiquitous_bash' bash scripts, may affect the separate python 'lean.py' script.
if [[ "\$USER" == "" ]]
then
	[[ "\$UID" == "0" ]] && export USER="root"
	[[ "\$USER" == "" ]] && export USER=\$(id -u -n 2>/dev/null)
fi

CZXWXcRMTo8EmM8i4d


	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && cat << CZXWXcRMTo8EmM8i4d

[[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1 && echo -n '_'

[[ "\$profileScriptLocation" == "" ]] && export profileScriptLocation_new='true'

#[[ -e "/etc/ssl/openssl_legacy.cnf" ]] && export OPENSSL_CONF="/etc/ssl/openssl_legacy.cnf"
[[ -e "/etc/ssl/openssl.cnf" ]] && export OPENSSL_CONF="/etc/ssl/openssl.cnf"

CZXWXcRMTo8EmM8i4d

	# WARNING: CAUTION: Precautionary. No known issues, may be unnecessary. Unusual.
	#However, theoretically nix package manager could otherwise override default programs (eg. python , gschem , pcb) before 'ubiquitous_bash' , causing severely incompatible shell environment configuration .
	_setupUbiquitous_accessories_here-nixenv-bashrc


	cat << CZXWXcRMTo8EmM8i4d
PS1_lineNumber=""


# WARNING: Importing complete 'ubiquitous_bash.sh' may cause other scripts to call functions inappropriate for their needs during "_test" and "_setup" .
# This may be acceptable if the user has already run "_setup" from the imported script .
#export profileScriptLocation="$ubcoreUBdir"/ubiquitous_bash.sh
export profileScriptLocation="$ubcoreUBdir"/ubcore.sh
#export profileScriptLocation="$ubcoreUBdir"/lean.sh
export profileScriptFolder="$ubcoreUBdir"
[[ "\$scriptAbsoluteLocation" != "" ]] && . "\$scriptAbsoluteLocation" --parent _importShortcuts
[[ "\$scriptAbsoluteLocation" == "" ]] && . "\$profileScriptLocation" --profile _importShortcuts
[[ "\$ub_setScriptChecksum_disable" == 'true' ]] && export ub_setScriptChecksum_disable="" && unset ub_setScriptChecksum_disable

# Hardware serial terminals connected through screen require explicit resize to change number of columns/lines. Usually doing this once will at least increase the usable 'screen real estate' from the very small defaults.
# Ignored by Cygwin/MSW, etc.
type -p resize > /dev/null 2>&1 && resize > /dev/null

# Returns priority to normal.
# Greater or equal, '_priority_app_pid_root' .
#ionice -c 2 -n 3 -p \$\$
#renice -n -5 -p \$\$ > /dev/null 2>&1

# Returns priority to normal.
# Greater or equal, '_priority_app_pid' .
ionice -c 2 -n 4 -p \$\$
renice -n 0 -p \$\$ > /dev/null 2>&1

[[ -e "$ubcoreDir"/cloudrc ]] && . "$ubcoreDir"/cloudrc

true

CZXWXcRMTo8EmM8i4d


	# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
	_if_cygwin && cat << CZXWXcRMTo8EmM8i4d

if [[ "\$HOME" == "/home/root" ]] && [[ ! -e /home/"\$USER" ]]
then
	ln -s --no-target-directory "/home/root" /home/"\$USER" > /dev/null 2>&1
fi

if [[ -e '/cygdrive' ]] && uname -a | grep -i cygwin > /dev/null 2>&1
then
	#echo -n '.'
	#clear
	
	# https://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
	echo -e -n '.\r'
	
	if [[ "\$profileScriptLocation_new" == 'true' ]]
	then
		export profileScriptLocation_new=''
		unset profileScriptLocation_new
		
		# May have prevented issues from services (eg. ssh-pageant) that now do not continue to cause such issues, have been disabled, or have been removed, etc. Uncomment 'sleep 0.1' commands, replacing the other true/noop/sleep, if necessary or desired.
		#sleep 0.1
		true
		echo '_'
		#sleep 0.1
		true
		echo '_'
		#sleep 0.1
		true
		
		clear
	fi
fi

true

CZXWXcRMTo8EmM8i4d

}


_setupUbiquitous_bashProfile_here() {
	! uname -a | grep -i cygwin > /dev/null 2>&1 && cat << CZXWXcRMTo8EmM8i4d

if [[ -e "$HOME"/.bashrc ]] && [[ "\$ubiquitousBashID" == "" ]]
then
	source "$HOME"/.bashrc
fi

CZXWXcRMTo8EmM8i4d
}
