#Override, cygwin.

# WARNING: Multiple reasons to instead consider direct detection by other commands -  ' uname -a | grep -i cygwin > /dev/null 2>&1 ' , ' [[ -e '/cygdrive' ]] ' , etc .
_if_cygwin() {
	if uname -a 2>/dev/null | grep -i cygwin > /dev/null 2>&1
	then
		return 0
	fi
	return 1
}


# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
#/usr/local/bin:/usr/bin:/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/usr/bin:/usr/lib/lapack:/cygdrive/x:/cygdrive/x/_bin:/cygdrive/x/_bundle:/opt/ansible/bin:/opt/nodejs/current:/opt/testssl:/home/root/bin
#/cygdrive/c/WINDOWS/system32:/cygdrive/c/WINDOWS:/usr/bin:/usr/lib/lapack:/cygdrive/x:/cygdrive/x/_bin:/cygdrive/x/_bundle:/opt/ansible/bin:/opt/nodejs/current:/opt/testssl:/home/root/bin
if [[ "$PATH" == "/cygdrive"* ]] || ( [[ "$PATH" == *"/cygdrive"* ]] && [[ "$PATH" != *"/usr/local/bin"* ]] )
then
	if [[ "$PATH" == "/cygdrive"* ]]
	then
		export PATH=/usr/local/bin:/usr/bin:/bin:"$PATH"
	fi
	
	[[ "$PATH" != *"/usr/local/bin"* ]] && export PATH=/usr/local/bin:"$PATH"
	[[ "$PATH" != *"/usr/bin"* ]] && export PATH=/usr/bin:"$PATH"
	[[ "$PATH" != *"/bin:"* ]] && export PATH=/bin:"$PATH"
fi


# ATTENTION: Workaround - Cygwin Portable - append MSW PATH if reasonable.
# NOTICE: Also see '_test-shell-cygwin' .
# MSWEXTPATH lengths up to 33, 38, are known reasonable values.
# As of 2025-05-20 , a development system, VSCode PowerShell terminal, has been known to impose 45 such lines on MSWEXTPATH , other PowerShell terminal imposed 41 such lines. Limit of 44 lines at the time was exceeded.
if [[ "$MSWEXTPATH" != "" ]] && ( [[ "$PATH" == *"/cygdrive"* ]] || [[ "$PATH" == "/cygdrive"* ]] ) && [[ "$convertedMSWEXTPATH" == "" ]] && _if_cygwin
then
        if [[ $(echo "$MSWEXTPATH" | grep -o ';' | wc -l | tr -dc '0-9') -le 99 ]] && [[ $(echo "$PATH" | grep -o ':' | wc -l | tr -dc '0-9') -le 99 ]]
        then
                export convertedMSWEXTPATH=$(cygpath -p "$MSWEXTPATH")
                export PATH=/usr/bin:"$convertedMSWEXTPATH":"$PATH"
        fi
fi



# ATTENTION: Workaround - Cygwin Portable - change directory to current directory as detected by 'ubcp.cmd' .
if [[ "$CWD" != "" ]] && [[ "$cygwin_CWD_onceOnly_done" != 'true' ]] && uname -a | grep -i cygwin > /dev/null 2>&1
then
	! cd "$CWD" && exit 1
	export cygwin_CWD_onceOnly_done='true'
fi



# ATTENTION: Workaround - Cygwin Portable - symlink home directory if nonexistent .
# https://stackoverflow.com/questions/39551802/how-to-fix-cygwin-using-wrong-ssh-directory-no-matter-what-i-do
#  'OpenSSH never honors $HOME.'
# https://sourceware.org/legacy-ml/cygwin/2016-06/msg00404.html
#  'OpenSSH never honors $HOME.'
# https://cygwin.com/cygwin-ug-net/ntsec.html
if [[ "$HOME" == "/home/root" ]] && [[ ! -e /home/"$USER" ]] && _if_cygwin
then
	ln -s --no-target-directory "/home/root" /home/"$USER" > /dev/null 2>&1
fi



# Forces Cygwin symlinks to best compatibility. Should be set by default elsewhere. Use sparingly only if necessary (eg. _setup_ubcp) .
_force_cygwin_symlinks() {
	! _if_cygwin && return 0
	[[ "$CYGWIN" != *"winsymlinks:lnk"* ]] && export CYGWIN="winsymlinks:lnk ""$CYGWIN"
}


# ATTENTION: User must launch "tmux" (no parameters) in a graphical Cygwin terminal.
# Launches graphical application through "tmux new-window" if available.
# https://superuser.com/questions/531787/starting-windows-gui-program-in-windows-through-cygwin-sshd-from-ssh-client
_workaround_cygwin_tmux() {
	if pgrep -u "$USER" ^tmux$ > /dev/null 2>&1
	then
		tmux new-window "$@"
		return "$?"
	fi
	
	"$@"
	return "$?"
}


# DANGER: Severely differing functionality. Intended only to stand in for "ip addr show" and similar.
if ! type ip > /dev/null 2>&1 && type 'ipconfig' > /dev/null 2>&1 && uname -a | grep -i cygwin > /dev/null 2>&1
then
	ip() {
		if [[ "$1" == "addr" ]] && [[ "$2" == "show" ]]
		then
			ipconfig
			return $?
		fi
		
		return 1
	}
fi



if _if_cygwin
then
	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc
	# Prioritizes native git binaries if available. Mostly a disadvantage over the Cygwin/MSW git binaries, but adds more usable git-lfs , and works surprisingly well, apparently still defaulting to: Cygwin HOME '.gitconfig' , Cygwin '/usr/bin/ssh' , correctly understanding the overrides of '_gitBest' , etc.
	#  Alternatives:
	#   git-lfs compiled for Cygwin/MSW - requires installing 'go' compiler for Cygwin/MSW
	#   git fetch commands - manual effort
	#   wrapper script to detect git lfs error and retry with subsequent separate fetch - technically possible
	#   avoid git-lfs - usually sufficient
	_override_msw_git() {
		local git_path="/cygdrive/c/Program Files/Git/cmd"
		
		# Optionally iterate through additional drive letters:
		# for drive in c ; do
		# for drive in c d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W ; do
		#   local git_path="/cygdrive/${drive}/Program Files/Git/cmd"
		#   if [ -d "${git_path}" ]; then
		#     break
		#   fi
		# done
		
		[ -d "$git_path" ] || return 0  # Return quietly if the git_path is not a directory

		# ATTENTION: To use with 'ops.sh' or similar if necessary, appropriate, and safe.
		export PATH_pre_override_git="$PATH"
		
		local path_entry entry IFS=':'
		local new_path=""
		
		for entry in $PATH ; do
			# Skip adding if this entry matches git_path exactly
			[ "$entry" = "$git_path" ] && continue
			
			# Append current entry to the new_path
			if [ -z "$new_path" ]; then
				new_path="$entry"
			else
				new_path="${new_path}:${entry}"
			fi
		done

		# Finally, explicitly prepend the git path
		export PATH="${git_path}:${new_path}"

		#( _messagePlain_probe_var PATH >&2 ) > /dev/null
		#( _messagePlain_probe_var PATH_pre_override_git >&2 ) > /dev/null

		# CAUTION: DANGER: MSW native git binaries can perceive 'parent directories' outside the 'root' directory provided by Cygwin, equivalent to calling git binaries through remote (eg. SSH, etc) commands to a filesystem encapsulating a ChRoot !
		#  This function limits that behavior, especially for 'ubiquitous_bash' projects with MSW installers shipping standalone 'ubcp' environments.
		_override_msw_git_CEILING() {
			# On the unusual occasion "$scriptLocal" is defined as something other than "$scriptAbsoluteFolder"/_local, the 'ubcp' directory is not expected to have been included as a standard subdirectory under any other definition of "$scriptLocal" . Since this information is only used to add redundant configuration (ie. directories are not created, etc), no issues should be possible.
			#current_script_ubcp_msw=$(cygpath -w "$scriptLocal")
			current_script_ubcp_msw=$(cygpath -w "$scriptAbsoluteFolder"/_local)
			current_script_ubcp_msw_escaped="${current_script_ubcp_msw//\\/\\\\}"
			current_script_ubcp_msw_slash="${current_script_ubcp_msw//\\/\/}"

			# ONLY for the MSW git binaries override case (if "$git_path" is not valid, this function will already return before this)
			export GIT_CEILING_DIRECTORIES="/home/root/.ubcore/ubiquitous_bash;/home/root/.ubcore;/home/root;/cygdrive;/cygdrive/d/a/ubiquitous_bash/ubiquitous_bash;/cygdrive/c/a/ubiquitous_bash/ubiquitous_bash;C:\core\infrastructure\ubcp\cygwin;C:\q\p\zCore\infrastructure\ubiquitous_bash\_local\ubcp\cygwin;C:\core\infrastructure\extendedInterface\_local\ubcp;C:\core\infrastructure\ubDistBuild\_local\ubcp"
			
			[[ "$scriptAbsoluteFolder" != "" ]] && export GIT_CEILING_DIRECTORIES="$GIT_CEILING_DIRECTORIES"';'"$current_script_ubcp_msw"
		}
		#export -f _override_msw_git_CEILING
		_override_msw_git_CEILING
	}
	# CAUTION: Early in the script for a reason! Changing the PATH drastically later has been known to cause WSL 'bash' to override Cygwin 'bash' with very obviously unpredictable results.
	#  ATTENTION: There would be a '_test' function in 'ubiquitous_bash' for this, but the state of 'wsl' which may not be installed with 'ubdist', etc, is not necessarily predictable enough for a simple PASS/FAIL .
	#if [[ "$1" != "_setupUbiquitous" ]] && [[ "$ub_under_setupUbiquitous" != "true" ]]
	#then
		_override_msw_git
		#_override_msw_git_CEILING
	#fi

	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc  (partially)
	# ATTRIBUTION-AI: ChatGPT 4o  2025-04-12  web search  (partially)
	# ATTRIBUTION-AI: ChatGPT o3-mini-high  2025-04-12
	_write_configure_git_safe_directory_if_admin_owned_sequence() {
		local functionEntryPWD="$PWD"

		# DUBIOUS
		local functionEntry_GIT_DIR="$GIT_DIR"
		local functionEntry_GIT_WORK_TREE="$GIT_WORK_TREE"
		local functionEntry_GIT_INDEX_FILE="$GIT_INDEX_FILE"
		local functionEntry_GIT_OBJECT_DIRECTORY="$GIT_OBJECT_DIRECTORY"
		#local functionEntry_GIT_ALTERNATE_OBJECT_DIRECTORIES="$GIT_ALTERNATE_OBJECT_DIRECTORIES"
		local functionEntry_GIT_CONFIG="$GIT_CONFIG"
		local functionEntry_GIT_CONFIG_GLOBAL="$GIT_CONFIG_GLOBAL"
		local functionEntry_GIT_CONFIG_SYSTEM="$GIT_CONFIG_SYSTEM"
		local functionEntry_GIT_CONFIG_NOSYSTEM="$GIT_CONFIG_NOSYSTEM"
		#local functionEntry_GIT_AUTHOR_NAME="$GIT_AUTHOR_NAME"
		#local functionEntry_GIT_AUTHOR_EMAIL="$GIT_AUTHOR_EMAIL"
		#local functionEntry_GIT_AUTHOR_DATE="$GIT_AUTHOR_DATE"
		#local functionEntry_GIT_COMMITTER_NAME="$GIT_COMMITTER_NAME"
		#local functionEntry_GIT_COMMITTER_EMAIL="$GIT_COMMITTER_EMAIL"
		#local functionEntry_GIT_COMMITTER_DATE="$GIT_COMMITTER_DATE"
		#local functionEntry_GIT_EDITOR="$GIT_EDITOR"
		#local functionEntry_GIT_PAGER="$GIT_PAGER"
		local functionEntry_GIT_NAMESPACE="$GIT_NAMESPACE"
		local functionEntry_GIT_CEILING_DIRECTORIES="$GIT_CEILING_DIRECTORIES"
		local functionEntry_GIT_DISCOVERY_ACROSS_FILESYSTEM="$GIT_DISCOVERY_ACROSS_FILESYSTEM"
		#local functionEntry_GIT_SSL_NO_VERIFY="$GIT_SSL_NO_VERIFY"
		#local functionEntry_GIT_SSH="$GIT_SSH"
		#local functionEntry_GIT_SSH_COMMAND="$GIT_SSH_COMMAND"

		git config --global --add safe.directory "$1"
		#if [[ $(type -p git) != '/usr/bin/git' ]]
		#then
			##git config --global --add safe.directory "$2"
			git config --global --add safe.directory "$3"
			git config --global --add safe.directory "$4"
		#fi

		cd "$functionEntryPWD"

		# DUBIOUS
		GIT_DIR="$functionEntry_GIT_DIR"
		GIT_WORK_TREE="$functionEntry_GIT_WORK_TREE"
		GIT_INDEX_FILE="$functionEntry_GIT_INDEX_FILE"
		GIT_OBJECT_DIRECTORY="$functionEntry_GIT_OBJECT_DIRECTORY"
		#GIT_ALTERNATE_OBJECT_DIRECTORIES="$functionEntry_GIT_ALTERNATE_OBJECT_DIRECTORIES"
		GIT_CONFIG="$functionEntry_GIT_CONFIG"
		GIT_CONFIG_GLOBAL="$functionEntry_GIT_CONFIG_GLOBAL"
		GIT_CONFIG_SYSTEM="$functionEntry_GIT_CONFIG_SYSTEM"
		GIT_CONFIG_NOSYSTEM="$functionEntry_GIT_CONFIG_NOSYSTEM"
		#GIT_AUTHOR_NAME="$functionEntry_GIT_AUTHOR_NAME"
		#GIT_AUTHOR_EMAIL="$functionEntry_GIT_AUTHOR_EMAIL"
		#GIT_AUTHOR_DATE="$functionEntry_GIT_AUTHOR_DATE"
		#GIT_COMMITTER_NAME="$functionEntry_GIT_COMMITTER_NAME"
		#GIT_COMMITTER_EMAIL="$functionEntry_GIT_COMMITTER_EMAIL"
		#GIT_COMMITTER_DATE="$functionEntry_GIT_COMMITTER_DATE"
		#GIT_EDITOR="$functionEntry_GIT_EDITOR"
		#GIT_PAGER="$functionEntry_GIT_PAGER"
		GIT_NAMESPACE="$functionEntry_GIT_NAMESPACE"
		GIT_CEILING_DIRECTORIES="$functionEntry_GIT_CEILING_DIRECTORIES"
		GIT_DISCOVERY_ACROSS_FILESYSTEM="$functionEntry_GIT_DISCOVERY_ACROSS_FILESYSTEM"
		#GIT_SSL_NO_VERIFY="$functionEntry_GIT_SSL_NO_VERIFY"
		#GIT_SSH="$functionEntry_GIT_SSH"
		#GIT_SSH_COMMAND="$functionEntry_GIT_SSH_COMMAND"

		return 0
	}

	# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-11  with knowledge ubiquitous_bash, etc  (partially)
	# CAUTION: NOT sufficient to call this function only during installation (as Administrator, which is what normally causes this issue). If the user subsequently installs native 'git for Windows', additional '.gitconfig' entries are needed, with the different MSWindows native style path format.
	# Historically this was apparently at least mostly not necessary until prioritizing native git binaries (if available) instead of relying on Cygwin/MSW git binaries.
	_write_configure_git_safe_directory_if_admin_owned() {
		local current_path="$1"
		local win_path win_path_escaped win_path_slash cygwin_path
		win_path="$(cygpath -w "$current_path")"
		#cygwin_path="$(cygpath -u "$current_path")"  # explicit Cygwin POSIX path
		win_path_escaped="${win_path//\\/\\\\}"
		win_path_slash="${win_path//\\/\/}"

		# Single call to verify Administrators ownership explicitly (fast Windows API call)
		local owner_line
		owner_line="$(icacls "$win_path" 2>/dev/null)"
		if [[ "$owner_line" != *"BUILTIN\\Administrators"* ]]; then
			# Not Administrators-owned, no further action needed, immediate return
			return 0
		fi
		# Read "$HOME"/.gitconfig just once (efficient builtin file reading)
		local gitconfig_content
		if [[ -e "$HOME"/.gitconfig ]]; then
			gitconfig_content="$(< "$HOME"/.gitconfig)"

			## Check 1: Exact Windows path (C:\...)
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]]; then
				#return 0
			#fi

			## Check 2: Double-backslash-escaped Windows path (C:\\...)
			#win_path_escaped="${win_path//\\/\\\\}"
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]]; then
				#return 0
			#fi

			## Check 3: Normal-slash Windows path (C:/...)
			#win_path_slash="${win_path//\\/\/}"
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]]; then
				#return 0
			#fi

			## Check 4: Original Cygwin POSIX path (/cygdrive/c/...)
			#if [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]]; then
				#return 0
			#fi

			#( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]] ) && ( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]] ) && return 0

			# Slightly more performance efficient. No expected scenario in which a MSW path has been added but a UNIX path has not.
			( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_escaped"* ]] || [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $win_path_slash"* ]] ) && return 0
			cygwin_path="$(cygpath -u "$current_path")"  # explicit Cygwin POSIX path
			( [[ "$gitconfig_content" == *"[safe]"* && "$gitconfig_content" == *"directory = $cygwin_path"* ]] ) && return 0
		fi

		# Explicit message clearly communicating safe-configuration action for transparency
		#echo "Administrators ownership detected; configuring git safe.directory entry."

		# perform safe git configuration exactly once after all efficient checks
		# CAUTION: Tested to create functionally identical log entries through both '/usr/bin/git' and native git binaries. Ensure that remains the case if making any changes.
		#"$scriptAbsoluteLocation" _write_configure_git_safe_directory_if_admin_owned_sequence "$cygwin_path" "$win_path_escaped" "$win_path_slash" "$win_path"
		( _write_configure_git_safe_directory_if_admin_owned_sequence "$cygwin_path" "$win_path_escaped" "$win_path_slash" "$win_path" )
	}
	# Must be later, after set global variable "$scriptAbsoluteFolder" .
	#_write_configure_git_safe_directory_if_admin_owned "$scriptAbsoluteFolder"
	
	# NOTICE: Recent versions of Cygwin seem to have replaced or omitted '/usr/bin/gpg.exe', possibly in favor of a symlink to '/usr/bin/gpg2.exe' .
	# CAUTION: This override is specifically to ensure availability of 'gpg' binary through a function, but that could have the effect of presenting an incorrect gpg2 CLI interface to software expecting a gpg1 CLI interface.
	 # In practice, Debian Linux seem to impose gpg v2 as the CLI interface for gpg - 'gpg --version' responds v2 .
	# WARNING: All of which is a good reason to always automatically prefer a specified major version binary of gpg (ie. gpg2) in other software.
	if ! type -p gpg > /dev/null && type -p gpg2 > /dev/null
	then
		gpg() {
			gpg2 "$@"
		}
	fi
	
	
	# WARNING: Since MSW/Cygwin is hardly suitable for mounting UNIX/tmpfs/ramfs/etc filesystems, 'mountpoint' 'safety checks' are merely disabled.
	mountpoint() {
		true
	}
	losetup() {
		false
	}
	
	tc() {
		false
	}
	wondershaper() {
		false
	}
	
	ionice() {
		false
	}

	# ATTENTION: Sets the priority for '_wsl' as well as 'u' shortcuts. Override with '_bashrc' or similar as desired (eg. replace 'ubdist_embedded' with some specialized 3D printer firwmare/klipper dist/OS, etc).
	_wsl() {
		local currentBin_wsl
		#currentBin_wsl=$(type -p wsl)

		currentBin_wsl="wsl"

		if ( [[ "$1" != "-"* ]] || [[ "$1" == "-u" ]] || [[ "$1" == "-e" ]] || [[ "$1" == "--exec" ]] ) && ( [[ "$1" != "-d" ]] || [[ "$2" != "-d" ]] || [[ "$3" != "-d" ]] || [[ "$4" != "-d" ]] || [[ "$5" != "-d" ]] || [[ "$6" != "-d" ]] )
		then
			if "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^ubdist' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d ubdist "$@"
				"$currentBin_wsl" -d ubdist "$@"
				return
			elif "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^ubDistBuild' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d ubDistBuild "$@"
				"$currentBin_wsl" -d ubDistBuild "$@"
				return
			elif "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^ubdist_embedded' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d ubdist_embedded "$@"
				"$currentBin_wsl" -d ubdist_embedded "$@"
				return
			elif "$currentBin_wsl" --list | tr -dc 'a-zA-Z0-9\n' | grep '^Debian' > /dev/null 2>&1
			then
				#"$currentBin_wsl" -u root -d Debian "$@"
				"$currentBin_wsl" -d Debian "$@"
				return
			fi
			"$currentBin_wsl" "$@"
			return
		fi
		"$currentBin_wsl" "$@"
		return
	}
	#l() {
		#_wsl "$@"
	#}
	#alias l='_wsl'
	alias u='_wsl'
	
	# MSWindows native 'PowerSession' apparently does not support 'asciinema cat'.
	#alias asciinema='PowerSession'

	# Optional. Other than recording, and some issues with 'asciinema cat', pip installed 'asciinema' seems usable .
	# Use _asciinema_record to record .
	alias asciinema='wsl -d ubdist asciinema'

	#alias codex='wsl -d ubdist codex'
	alias codex='wsl -d ubdist "~/.ubcore/ubiquitous_bash/ubcore.sh" _codexBin-usr_bin_node'

	alias codexNative=$(type -P codex 2>/dev/null)
fi
	
_sudo_cygwin-if_parameter-skip2() {
	[[ "$1" == "-u" ]] && return 0
	return 1
}
_sudo_cygwin-if_parameter-skip1() {
	[[ "$1" == "-n" ]] && return 0
	[[ "$1" == "--preserve-env"* ]] && return 0
	return 1
}

# CAUTION: Fragile, at best.
# DANGER: MSW apparently does not necessarily allow 'Administrator' access to all network 'drives'. Workaround copying of obvious files is limited.
# WARNING: Most likely, after significant delay, will 'prompt' the user with a very much obstructive, and not securing very much, dialog box.
# https://stackoverflow.com/questions/4090301/root-user-sudo-equivalent-in-cygwin
# https://superuser.com/questions/812018/run-a-command-in-another-cygwin-window-and-not-exit
_sudo_cygwin_sequence() {
	_start
	
	# 'If already admin, just run the command in-line.'
	# 'This works on my Win10 machine; dunno about others.'
	if id -G | grep -q ' 544 '
	then
		"$@"
		_stop "$?"
	fi
	
	# 'cygstart/runas doesn't handle arguments with spaces correctly so create'
	# 'a script that will do so properly.'
	echo "#!/bin/bash" >> "$safeTmp"/cygwin_sudo_temp.sh

	echo "cd \"$PWD"\" >> "$safeTmp"/cygwin_sudo_temp.sh

	echo "export PATH=\"$PATH\"" >> "$safeTmp"/cygwin_sudo_temp.sh

	# No production use.
	echo "export GH_TOKEN=\"$GH_TOKEN\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export INPUT_GITHUB_TOKEN=\"$INPUT_GITHUB_TOKEN\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export TOKEN=\"$TOKEN\"" >> "$safeTmp"/cygwin_sudo_temp.sh

	# No production use.
	echo "export nonet=\"$nonet\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export devfast=\"$devfast\"" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo "export skimfast=\"$skimfast\"" >> "$safeTmp"/cygwin_sudo_temp.sh

	local currentParam1
	while _sudo_cygwin-if_parameter-skip2 "$@" || _sudo_cygwin-if_parameter-skip1 "$@"
	do
		currentParam1="$1"

		if _sudo_cygwin-if_parameter-skip2 "$currentParam1"
		then
			! shift && _messageFAIL
			! shift && _messageFAIL
			currentParam1=""
		fi

		if _sudo_cygwin-if_parameter-skip1 "$currentParam1"
		then
			! shift && _messageFAIL
			currentParam1=""
		fi
	done

	#echo 'local currentExitStatus' >> "$safeTmp"/cygwin_sudo_temp.sh
	_safeEcho_newline "$safeTmp"/_bin.bat "$@" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'currentExitStatus=$?' >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'echo > "'"$safeTmp"'"/sequenceDone_'"$ubiquitousBashID" >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'sleep 3' >> "$safeTmp"/cygwin_sudo_temp.sh
	echo 'exit $currentExitStatus' >> "$safeTmp"/cygwin_sudo_temp.sh
	chmod u+x "$safeTmp"/cygwin_sudo_temp.sh
	
	
		
	cp "$scriptAbsoluteLocation" "$safeTmp"/
	local currentScriptBasename
	currentScriptBasename=$(basename "$scriptAbsoluteLocation")
	chmod u+x "$safeTmp"/"$currentScriptBasename"
	
	cp "$scriptLib"/ubiquitous_bash/_bin.bat "$safeTmp"/_bin.bat 2>/dev/null
	#cp /home/root/.ubcore/ubiquitous_bash/_bin.bat "$safeTmp"/_bin.bat 2>/dev/null
	cp -f "$scriptAbsoluteFolder"/_bin.bat "$safeTmp"/_bin.bat 2>/dev/null
	chmod u+x "$safeTmp"/_bin.bat

	[[ ! -e "$safeTmp"/_bin.bat ]] && _messagePlain_bad 'bad: missing: _bin.bat' && _messageFAIL && _stop 1

	if type _anchor_configure > /dev/null 2>&1
	then
		"$safeTmp"/"$currentScriptBasename" _anchor_configure "$safeTmp"/_bin.bat
	else
		_messagePlain_bad 'bad: missing: _anchor_configure'
		_messageFAIL && _stop 1
		_stop 1
	fi
	

	# 'Do it as Administrator.'
	#cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat bash
	
	if [[ "$scriptAbsoluteFolder" == "/cygdrive/c"* ]]
	then
		# WARNING: May be untested, or (especially under interactive shell) may call obsolete code.
		#cygstart --action=runas "$scriptAbsoluteFolder"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh

		cygstart --action=runas "$safeTmp"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh
	else
		cygstart --action=runas "$safeTmp"/_bin.bat "$safeTmp"/cygwin_sudo_temp.sh
	fi
	
	
	while ! [[ -e "$safeTmp"/sequenceDone_"$ubiquitousBashID" ]]
	do
		sleep 3
	done
	
	_stop "$?"
}
_sudo_cygwin() {
	"$scriptAbsoluteLocation" _sudo_cygwin_sequence "$@"
}

# CAUTION: BROKEN !
# (at least historically this did not work reliably though it may or may not be reliable now)
if _if_cygwin && type cygstart > /dev/null 2>&1
then
	sudo_cygwin() {
		#[[ "$1" == "-n" ]] && shift
		if type cygstart > /dev/null 2>&1
		then
			_sudo_cygwin "$@"
			#cygstart --action=runas "$@"
			#"$@"
			return
		fi
		
		"$@"
		return
		
		return 1
	}
	sudoc() {
		#[[ "$1" == "-n" ]] && return 1
		sudo_cygwin "$@"
	}
	alias sudo=sudoc
fi




# Calls MSW native programs from Cygwin/MSW with file parameter translation.
#_userMSW kate /etc/fstab
_userMSW() {
	if ! _if_cygwin || ! type cygpath > /dev/null 2>&1
	then
		"$@"
		return
	fi
	
	
	local currentArg
	local currentResult
	processedArgs=()
	for currentArg in "$@"
	do
		if [[ -e "$currentArg" ]] || [[ "$currentArg" == "/cygdrive/"* ]] || [[ "$currentArg" == "/home/"* ]] || [[ "$currentArg" == "/root/"* ]]
		then
			currentResult=$(cygpath -w "$currentArg")
		else
			currentResult="$currentArg"
		fi
		
		processedArgs+=("$currentResult")
	done
	
	
	"${processedArgs[@]}"
}

_discover_powershell() {
	local currentPowershellBinary
    currentPowershellBinary=$(find /cygdrive/c/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /cygdrive/d/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /cygdrive/e/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /cygdrive/f/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
	
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /mnt/c/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /mnt/d/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /mnt/e/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)
    [[ "$currentPowershellBinary" == "" ]] && currentPowershellBinary=$(find /mnt/f/Windows/System32/WindowsPowerShell/ -name powershell.exe 2>/dev/null | head -n 1)

	_safeEcho "$currentPowershellBinary"
	[[ "$currentPowershellBinary" != "" ]] && return 0
	return 1
}

_powershell() {
    local currentPowershellBinary
    currentPowershellBinary=$(_discover_powershell)

	#_userMSW "$currentPowershellBinary" "$@"
    "$currentPowershellBinary" "$@"
}



_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles() {
	local currentBinary
	currentBinary="$1"
	
	local currentBinary_functionName
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9\-_')
	
	local currentExpectedSubdir
	currentExpectedSubdir="$2"
	
	local forceNativeBinary
	forceNativeBinary='false'
	
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	local forceWorkaroundPrefix
	forceWorkaroundPrefix="$4"
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'/Program Files/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'"/"'"Program Files"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
		false
	fi
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'/Program Files (x86)/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q"'"/"'"Program Files (x86)"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
	fi
	type "$currentBinary_functionName" > /dev/null 2>&1 && export -f "$currentBinary" > /dev/null 2>&1 && return 0
	return 1
}

_discoverResource-cygwinNative-ProgramFiles-declaration-core() {
	local currentBinary
	currentBinary="$1"
	
	local currentBinary_functionName
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9\-_')
	
	local currentExpectedSubdir
	currentExpectedSubdir="$2"
	
	local forceNativeBinary
	forceNativeBinary='false'
	
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	local forceWorkaroundPrefix
	forceWorkaroundPrefix="$4"
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentCygdriveC_equivalent"'/core/installations/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentCygdriveC_equivalent"'"/"'"core/installations"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
	fi
	type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	if ! type "$currentBinary_functionName" > /dev/null 2>&1 && type '/cygdrive/'"$currentCygdriveC_equivalent"'/core/installations/'"$currentExpectedSubdir"'/'"$currentBinary".exe > /dev/null 2>&1
	then
		eval $currentBinary_functionName'() { '"$forceWorkaroundPrefix"'/cygdrive/"'"$currentCygdriveC_equivalent"'"/"'"core/installations"'"/"'"$currentExpectedSubdir"'"/"'"$currentBinary"'".exe "$@" ; }'
	fi
	type "$currentBinary_functionName" > /dev/null 2>&1 && export -f "$currentBinary" > /dev/null 2>&1 && return 0
	return 1
}

_discoverResource-cygwinNative-ProgramFiles() {
	local currentBinary
	currentBinary="$1"
	local currentBinary_functionName
	currentBinary_functionName=$(echo "$1" | tr -dc 'a-zA-Z0-9\-_')
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	export currentDriveLetter_cygwin_uk4uPhB663kVcygT0q="$currentCygdriveC_equivalent"
	_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles "$@"
	[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	
	# ATTENTION: Configure: 'c..w' (aka. 'w..c') .
	# WARNING: Program Files at drive letters other than 'c' may not be supported now or ever. Especially other than 'c,d,e'.
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	#for currentDriveLetter_cygwin_uk4uPhB663kVcygT0q in {c..w}
	for currentDriveLetter_cygwin_uk4uPhB663kVcygT0q in {c..f}
	do
		_discoverResource-cygwinNative-ProgramFiles-declaration-ProgramFiles "$@"
		[[ "$3" != "true" ]] && type "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	done
	
	_discoverResource-cygwinNative-ProgramFiles-declaration-core "$@"
	
	type "$currentBinary_functionName" > /dev/null 2>&1 && export -f "$currentBinary_functionName" > /dev/null 2>&1 && return 0
	return 1
}


_set_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	export functionEntry_USERPROFILE="$USERPROFILE"
	export functionEntry_HOMEDRIVE="$HOMEDRIVE"
	export functionEntry_HOMEPATH="$HOMEPATH"
	
	# https://docs.oracle.com/en/virtualization/virtualbox/6.0/admin/vboxconfigdata.html
	#  'Windows: $HOME/.VirtualBox.'
	# https://en.wikipedia.org/wiki/Home_directory
	# %USERPROFILE%
	# %HOMEDRIVE%%HOMEPATH%
	# echo $USERPROFILE
	# export USERPROFILE="$USERPROFILE"'\Downloads'
	# cmd
	# echo %USERPROFILE%
	
	if [[ "$HOME" != "/root" ]] && [[ "$HOME" != "/home/root" ]] && [[ "$HOME" != "/home/""$USER" ]]
	then
		export USERPROFILE=$(cygpath -w "$HOME")
		export HOMEDRIVE=$(echo "$USERPROFILE" | head -c 2)
		export HOMEPATH=$(echo "$USERPROFILE" | tail -c +3)
	fi
	
	# WARNING: Cygwin/MSW HOME directory redirection may be disabled for future versions of 'ubiquitous bash'.
	if [[ "$USERPROFILE" == "$functionEntry_USERPROFILE" ]] && [[ "$VBOX_USER_HOME_short" != "" ]]
	then
		export USERPROFILE=$(cygpath -w "$VBOX_USER_HOME_short")
		export HOMEDRIVE=$(echo "$VBOX_USER_HOME_short" | head -c 2)
		export HOMEPATH=$(echo "$VBOX_USER_HOME_short" | tail -c +3)
	fi
	
	export functionEntry_VBOXID="$VBOXID"
	export functionEntry_vBox_vdi="$vBox_vdi"
	export functionEntry_vBoxInstanceDir="$vBoxInstanceDir"
	export functionEntry_VBOX_ID_FILE="$VBOX_ID_FILE"
	export functionEntry_VBOX_USER_HOME="$VBOX_USER_HOME"
	export functionEntry_VBOX_USER_HOME_local="$VBOX_USER_HOME_local"
	export functionEntry_VBOX_USER_HOME_short="$VBOX_USER_HOME_short"
	export functionEntry_VBOX_IPC_SOCKETID="$VBOX_IPC_SOCKETID"
	export functionEntry_VBoxXPCOMIPCD_PIDfile="$VBoxXPCOMIPCD_PIDfile"
	
	[[ -e "$VBOXID" ]] && export VBOXID=$(cygpath -w "$VBOXID")
	[[ -e "$vBox_vdi" ]] && export vBox_vdi=$(cygpath -w "$vBox_vdi")
	[[ -e "$vBoxInstanceDir" ]] && export vBoxInstanceDir=$(cygpath -w "$vBoxInstanceDir")
	[[ -e "$VBOX_ID_FILE" ]] && export VBOX_ID_FILE=$(cygpath -w "$VBOX_ID_FILE")
	[[ -e "$VBOX_USER_HOME" ]] && export VBOX_USER_HOME=$(cygpath -w "$VBOX_USER_HOME")
	[[ -e "$VBOX_USER_HOME_local" ]] && export VBOX_USER_HOME_local=$(cygpath -w "$VBOX_USER_HOME_local")
	[[ -e "$VBOX_USER_HOME_short" ]] && export VBOX_USER_HOME_short=$(cygpath -w "$VBOX_USER_HOME_short")
	[[ -e "$VBOX_IPC_SOCKETID" ]] && export VBOX_IPC_SOCKETID=$(cygpath -w "$VBOX_IPC_SOCKETID")
	[[ -e "$VBoxXPCOMIPCD_PIDfile" ]] && export VBoxXPCOMIPCD_PIDfile=$(cygpath -w "$VBoxXPCOMIPCD_PIDfile")
}

_setFunctionEntry_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	export USERPROFILE="$functionEntry_USERPROFILE"
	export HOMEDRIVE="$functionEntry_HOMEDRIVE"
	export HOMEPATH="$functionEntry_HOMEPATH"
	
	export VBOXID="$functionEntry_VBOXID"
	export vBox_vdi="$functionEntry_vBox_vdi"
	export vBoxInstanceDir="$functionEntry_vBoxInstanceDir"
	export VBOX_ID_FILE="$functionEntry_VBOX_ID_FILE"
	export VBOX_USER_HOME="$functionEntry_VBOX_USER_HOME"
	export VBOX_USER_HOME_local="$functionEntry_VBOX_USER_HOME_local"
	export VBOX_USER_HOME_short="$functionEntry_VBOX_USER_HOME_short"
	export VBOX_IPC_SOCKETID="$functionEntry_VBOX_IPC_SOCKETID"
	export VBoxXPCOMIPCD_PIDfile="$functionEntry_VBoxXPCOMIPCD_PIDfile"
}

_prepare_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	mkdir -p "$HOME"
	
	_set_at_userMSW_discoverResource-cygwinNative-ProgramFiles "$@"
}


#_at_userMSW_discoverResource-cygwinNative-ProgramFiles VBoxManage Oracle/VirtualBox false
_at_userMSW_discoverResource-cygwinNative-ProgramFiles() {
	_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles "$@"
}

# WARNING: Output of 'probe' messages may interfere if program (eg. VBoxManage) output is expected not to include such messages.
#_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false
#_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles VBoxManage Oracle/VirtualBox false
_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles() {
	if declare -f orig_"$1" > /dev/null 2>&1
	then
		_messagePlain_probe 'exists: override: '"$1"
		return 0
	fi
	
	unset "$1"
	_discoverResource-cygwinNative-ProgramFiles "$1" "$2" "$3"
	
	! type "$1" > /dev/null 2>&1 && return 1
	
	
	# https://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function
	eval orig_"$(declare -f ""$1"")"
	
	unset "$1"
	eval "$1"'() { _prepare_at_userMSW_discoverResource-cygwinNative-ProgramFiles ; _userMSW _messagePlain_probe_cmd orig_'"$1"' "$@" ; _setFunctionEntry_at_userMSW_discoverResource-cygwinNative-ProgramFiles ; }'
}


_ops_cygwinOverride_allDisks() {
	# DANGER: Calling a script from every connected Cygwin/MSW drive arguably causes obvious problems, although any device or network directly connected to any MSW machine inevitably entails such risks.
	# WARNING: Looping through {w..c} completely may impose delays sufficient to break "_test_selfTime", "_test_broadcastPipe_page", etc, if extremely slow storage is attached.
	# ATTENTION: Configure: 'w..c' (aka. 'c..w') .
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
	for currentDriveLetter_cygwin_uk4uPhB663kVcygT0q in {w..c}
	do
		# WARNING: May require export of functions!
		[[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q ]] && [[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh ]] && . /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh
	done
	unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
}

# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
[[ "$profileScriptLocation_new" == 'true' ]] && echo -n '.'

if [[ -e /cygdrive ]] && _if_cygwin
then
	# WARNING: Reduces incidents of extremely slow storage attachment from breaking "_test_selfTime", "_test_broadcastPipe_page", etc, at risks of not recognizing newly installed 'native' programs for up to 20minutes .
	export cygwinOverride_measureDateB=$(date +%s%N | cut -b1-13)
	[[ "$cygwinOverride_measureDateA" == "" ]] && export cygwinOverride_measureDateA=$(bc <<< "$cygwinOverride_measureDateB - 900000000" | tr -dc '0-9')
	
	# WARNING: Experiment without checking checksum to ensure functions are exported correctly!
	if [[ $(bc <<< "$cygwinOverride_measureDateB - $cygwinOverride_measureDateA" | tr -dc '0-9') -gt 1200000 ]] || [[ "$ub_setScriptChecksum_contents_cygwinOverride" != "$ub_setScriptChecksum_contents" ]]
	then
		export cygwinOverride_measureDateA=$(date +%s%N | cut -b1-13)
		export ub_setScriptChecksum_contents_cygwinOverride="$ub_setScriptChecksum_contents"
		
		
		_discoverResource-cygwinNative-ProgramFiles 'ykman' 'Yubico/YubiKey Manager' false

		# For efficiency, do not search locations other than ' C:\ ' (aka. '/cygdrive/c' ).
		[[ -e '/cygdrive/c/Program Files/Yubico/Yubico PIV Tool/bin/yubico-piv-tool.exe' ]] && _discoverResource-cygwinNative-ProgramFiles 'yubico-piv-tool' 'Yubico/Yubico PIV Tool/bin' false
		
		
		# WARNING: Prefer to avoid 'nmap' for Cygwin/MSW .
		#_discoverResource-cygwinNative-ProgramFiles 'nmap' 'Nmap' false
		
		_discoverResource-cygwinNative-ProgramFiles 'qalc' 'Qalculate' false
		
		
		# WARNING: CAUTION: DANGER: UNIX EOL *MANDATORY* !
		[[ -e "$scriptAbsoluteFolder"/ops-cygwin.sh ]] && . "$scriptAbsoluteFolder"/ops-cygwin.sh
		
		# export ubiquitousBashID=uk4uPhB663kVcygT0q
		unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
		export currentDriveLetter_cygwin_uk4uPhB663kVcygT0q=$(cygpath -S | sed 's/\/Windows\/System32//g' | sed 's/^\/cygdrive\///')
		[[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q ]] && [[ -e /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh ]] && . /cygdrive/$currentDriveLetter_cygwin_uk4uPhB663kVcygT0q/ops-cygwin.sh
		
		#_ops_cygwinOverride_allDisks "$@"
		
		unset currentDriveLetter_cygwin_uk4uPhB663kVcygT0q
		
		
		
		# CAUTION: Performance - such '_discoverResource' functions are time consuming . If reasonable, instead call only from functions as necessary (eg. as part of '_userVBox') .
		# ATTENTION: Expect 0.500s for any program which is not found at 'C:\Program Files' or similar, and 0.200s for any program which is found quickly.
		# Other inefficiencies of Cygwin are usually more substantial if only a few entries are here.
		
		
		# WARNING: Native 'vncviewer.exe' is a GUI app, and cannot be launched directly from Cygwin SSH server.
		_discoverResource-cygwinNative-ProgramFiles 'vncviewer' 'TigerVNC' false '_workaround_cygwin_tmux '
		
		#_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false
		
		
		
		
		
		_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false > /dev/null 2>&1
	fi
	
	export override_cygwin_vncviewer="true"

	kwrite() {
		kate -n "$@"
	}

	code() {
		local current_workdir
		#current_workdir=$(_getAbsoluteFolder "$1")
		current_workdir=$(_searchBaseDir "$@")
		current_workdir=$(cygpath -w "$current_workdir")


		local currentArg
		local currentResult
		processedArgs=()
		for currentArg in "$@"
		do
			if [[ -e "$currentArg" ]] || [[ "$currentArg" == "/cygdrive/"* ]] || [[ "$currentArg" == "/home/"* ]] || [[ "$currentArg" == "/root/"* ]]
			then
				currentResult=$(cygpath -w "$currentArg")
			else
				currentResult="$currentArg"
			fi
			
			processedArgs+=("$currentResult")
		done

		"$(type -P code)" --new-window "${processedArgs[@]}" --new-window "$current_workdir"
	}

	_aria2c_cygwin_overide() {
		if _safeEcho_newline "$@" | grep '\--async-dns' > /dev/null
		then
			aria2c "$@"
			return
		else
			aria2c --async-dns=false "$@"
			return
		fi
	}
	alias aria2c=_aria2c_cygwin_overide

	##! type -p wslg
	#[[ -e '/cygdrive/c/WINDOWS/system32/wslg.exe' ]] && wsl() { '/cygdrive/c/WINDOWS/system32/wslg.exe' "$@" ; }
	[[ -e '/cygdrive/c/Program Files/WSL/wslg.exe' ]] && wslg() { '/cygdrive/c/Program Files/WSL/wslg.exe' "$@" ; } && wslg.exe() { wslg "$@" ; }
	##! type -p wsl
	#[[ -e '/cygdrive/c/WINDOWS/system32/wsl.exe' ]] && wsl() { '/cygdrive/c/WINDOWS/system32/wsl.exe' "$@" ; }
	[[ -e '/cygdrive/c/Program Files/WSL/wsl.exe' ]] && wsl() { '/cygdrive/c/Program Files/WSL/wsl.exe' "$@" ; } && wsl.exe() { wsl "$@" ; }
fi

# WARNING: What is otherwise considered bad practice may be accepted to reduce substantial MSW/Cygwin inconvenience .
[[ "$profileScriptLocation_new" == 'true' ]] && echo -n '.'







_discoverResource-cygwinNative-nmap() {
	type nmap > /dev/null 2>&1 && return 0
	# WARNING: Prefer to avoid 'nmap' for Cygwin/MSW .
	_if_cygwin && _discoverResource-cygwinNative-ProgramFiles 'nmap' 'Nmap' false
}





_setup_ubiquitousBash_cygwin_procedure_root() {
	local cygwinMSWdesktopDir
	local cygwinMSWmenuDir
	
	cygwinMSWdesktopDir=$(cygpath -u -a -A -D)
	cygwinMSWmenuDir=$(cygpath -u -a -A -P)
	
	mkdir -p "$cygwinMSWdesktopDir"
	mkdir -p "$cygwinMSWmenuDir"/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWdesktopDir"/
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	cygwinMSWdesktopDir=$(cygpath -u -a -D)
	cygwinMSWmenuDir=$(cygpath -u -a -P)
	
	chown -R "$USER":"$USER" "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash > /dev/null 2>&1
	chown -R "$USER":None "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	
	chown "$USER":"$USER" "$cygwinMSWdesktopDir"/_bash.bat > /dev/null 2>&1
	chown "$USER":None "$cygwinMSWdesktopDir"/_bash.bat
	chown -R "$USER":"$USER" "$cygwinMSWmenuDir"/ubiquitous_bash/ > /dev/null 2>&1
	chown -R "$USER":None "$cygwinMSWmenuDir"/ubiquitous_bash/
}

_setup_ubiquitousBash_cygwin_procedure() {
	#/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous
	[[ "$scriptAbsoluteFolder" != '/cygdrive'* ]] && _stop 1
	
	_messagePlain_nominal 'init: _setup_ubiquitousBash_cygwin'
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent="$1"
	[[ "$currentCygdriveC_equivalent" == "" ]] && currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	[[ "$1" == "/" ]] && currentCygdriveC_equivalent=$(echo "$PWD" | sed 's/\(\/cygdrive\/[a-zA-Z]*\).*/\1/')
	
	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	cd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/ubiquitous_bash.sh "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/lean.sh "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/ubcore.sh "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/lean.py "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	#cp "$scriptAbsoluteFolder"/_bash "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_bash.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	#cp "$scriptAbsoluteFolder"/_bin "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_bin.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_test "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_test.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_true "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_true.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_false "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_false.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_anchor "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_anchor.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_setup_ubcp.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/_setupUbiquitous.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	cp "$scriptAbsoluteFolder"/_setupUbiquitous_nonet.bat "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	cp "$scriptAbsoluteFolder"/fork "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/
	
	
	cp "$scriptAbsoluteFolder"/package.tar.xz "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/ > /dev/null 2>&1
	
	
	
	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp
	
	cp -a "$scriptLocal"/ubcp/_upstream "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp -a "$scriptLocal"/ubcp/overlay "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/.gitignore "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/agpl-3.0.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/cygwin-portable.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/cygwin-portable-updater.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/gpl-2.0.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/gpl-3.0.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/license.txt "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/README.md "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/ubcp.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/ubcp_rename-to-enable.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	cp "$scriptLocal"/ubcp/cygwin-portable-installer-config.cmd  "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	cp "$scriptLocal"/ubcp/ubcp-cygwin-portable-installer.cmd "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash/_local/ubcp/
	
	
	
	
	cygwinMSWdesktopDir=$(cygpath -u -a -A -D)
	cygwinMSWmenuDir=$(cygpath -u -a -A -P)
	
	mkdir -p "$cygwinMSWdesktopDir"
	mkdir -p "$cygwinMSWmenuDir"/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWdesktopDir"/
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	
	local cygwinMSWdesktopDir
	local cygwinMSWmenuDir
	cygwinMSWdesktopDir=$(cygpath -u -a -D)
	cygwinMSWmenuDir=$(cygpath -u -a -P)
	
	mkdir -p "$cygwinMSWdesktopDir"
	mkdir -p "$cygwinMSWmenuDir"/ubiquitous_bash
	
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWdesktopDir"/
	cp "$scriptAbsoluteFolder"/_bash.bat "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	
	chown -R "$USER":"$USER" "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash > /dev/null 2>&1
	chown -R "$USER":None "$currentCygdriveC_equivalent"/core/infrastructure/ubiquitous_bash
	
	chown "$USER":"$USER" "$cygwinMSWdesktopDir"/_bash.bat > /dev/null 2>&1
	chown "$USER":None "$cygwinMSWdesktopDir"/_bash.bat
	chown -R "$USER":"$USER" "$cygwinMSWmenuDir"/ubiquitous_bash/ > /dev/null 2>&1
	chown -R "$USER":None "$cygwinMSWmenuDir"/ubiquitous_bash/
	
	
	#sudo -n "$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure_root "$@"
	
	
	# ATTENTION: NOTICE: Any installer for developers which relies on unpacking directories to '/core/infrastructure' must also add this to '/' .
	# Having '_bash.bat' at '/' normally allows developers to get a bash prompt from both 'CMD' and 'PowerShell' terminal windows by '/_bash' command.
	cp "$scriptAbsoluteFolder"/_bash.bat "$currentCygdriveC_equivalent"/
	
	
	_messagePlain_good 'done: _setup_ubiquitousBash_cygwin: lean'
	sleep 1
}


_setup_ubiquitousBash_cygwin() {
	"$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure "$@"
}


_report_setup_ubcp() {
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent="$1"
	[[ "$currentCygdriveC_equivalent" == "" ]] && currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	[[ "$1" == "/" ]] && currentCygdriveC_equivalent=$(echo "$PWD" | sed 's/\(\/cygdrive\/[a-zA-Z]*\).*/\1/')


	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/
	#cd "$currentCygdriveC_equivalent"/core/infrastructure/


	find /bin/ /usr/bin/ /sbin/ /usr/sbin/ | tee "$currentCygdriveC_equivalent"/core/infrastructure/ubcp-binReport > /dev/null
	find /home/root/ | tee "$currentCygdriveC_equivalent"/core/infrastructure/ubcp-homeReport > /dev/null


	apt-cyg show | cut -f1 -d\ | tail -n +2 | tee "$currentCygdriveC_equivalent"/core/infrastructure/ubcp-packageReport > /dev/null
}


_setup_ubcp_procedure() {
	_messagePlain_nominal 'init: _setup_ubcp_procedure'
	! uname -a | grep -i cygwin > /dev/null 2>&1 && _stop 1
	
	tskill ssh-pageant > /dev/null 2>&1
	
	local currentCygdriveC_equivalent
	currentCygdriveC_equivalent="$1"
	[[ "$currentCygdriveC_equivalent" == "" ]] && currentCygdriveC_equivalent=$(cygpath -S | sed 's/\/Windows\/System32//g')
	[[ "$1" == "/" ]] && currentCygdriveC_equivalent=$(echo "$PWD" | sed 's/\(\/cygdrive\/[a-zA-Z]*\).*/\1/')
	
	export safeToDeleteGit="true"
	if [[ -e "$currentCygdriveC_equivalent"/core/infrastructure/ubcp ]]
	then
		# DANGER: Not only does this use 'rm -rf' without sanity checking, the behavior is undefined if this ubcp installation has been used to start this script!
		#[[ -e "$currentCygdriveC_equivalent"/core/infrastructure/ubcp ]] && rm -rf "$currentCygdriveC_equivalent"/core/infrastructure/ubcp
		
		_messageError 'FAIL: ubcp already installed locally and must be deleted prior to script!'
		sleep 10
		_stop 1
		exit 1
		return 1
	fi
	
	
	
	
	
	#cd "$scriptLocal"/
	
	mkdir -p "$currentCygdriveC_equivalent"/core/infrastructure/
	cd "$currentCygdriveC_equivalent"/core/infrastructure/
	
	#tar -xvf "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.gz
	#tar -xvf "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz

	if [[ "$skimfast" != "true" ]]
	then
		cat "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx | lz4 -d -c | tar -xvf -
	else
		cat "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx | lz4 -d -c | tar -xf -
		#tar -xf "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx
	fi
	
	_messagePlain_good 'done: _setup_ubcp_procedure: ubcp'
	sleep 10
	
	cd "$outerPWD"
}



# CAUTION: Do NOT hook to '_setup' .
# WARNING: ATTENTION: NOTICE: No production use. Developer feature.
# Highly irregular accommodation for usage of 'ubiquitous_bash' through 'ubcp' (cygwin portable) compatibility layer through MSW network drive (especially '_userVBox' MSW guest network drive) .
# WARNING: May require 'administrator' privileges under MSW. However, it may be better for this directory to be 'owned' by the 'primary' 'user' account. Particularly considering the VR/gaming/CAD software that remains 'exclusive' to MSW is 'legacy' software which for both licensing and technical reasons may be inherently incompatible with 'multi-user' access.
# WARNING: MSW 'administrator' 'privileges' may break 'ubcp' .
_setup_ubcp() {
	_force_cygwin_symlinks
	
	# WARNING: May break if 'mitigation' has not been applied!
	#! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.gz ]] && 
	#! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz ]] && 
	if ! [[ -e "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx ]] && [[ -e "$scriptLocal"/ubcp/cygwin ]]
	then
		export ubPackage_enable_ubcp='true'
		"$scriptAbsoluteLocation" _package_procedure-cygwinOnly
	fi
	
	"$scriptAbsoluteLocation" _setup_ubcp_procedure "$1"
	"$scriptAbsoluteLocation" _setup_ubiquitousBash_cygwin_procedure "$1"

	"$scriptAbsoluteLocation" _report_setup_ubcp "$1"
}






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
		
		[[ -e "$processedLinkDirective" ]] && rm -f "$currentLinkFolder"/"$currentLinkFile"
		
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
	find "$2" -type l -print0 | xargs -0 -x -s 3072 -L 6 -P $(nproc) bash -c '_mitigate-ubcp_rewrite_parallel "$@"' _
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
	"$scriptAbsoluteLocation" _mitigate-ubcp_directory "$@"
	
	export mitigate_ubcp_replaceSymlink='true'
	"$scriptAbsoluteLocation" _mitigate-ubcp_directory "$@"
}



_package_procedure-cygwinOnly() {
	_start
	mkdir -p "$safeTmp"/package
	
	# WARNING: Largely due to presence of '.gitignore' files in 'ubcp' .
	export safeToDeleteGit="true"
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.gz > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar.gz > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.gz > /dev/null 2>&1
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar.xz > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.xz > /dev/null 2>&1
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar > /dev/null 2>&1
	
	rm -f "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx > /dev/null 2>&1
	rm -f "$scriptLocal"/package_ubcp-cygwinOnly.tar.flx > /dev/null 2>&1
	rm -f "$scriptLocal"/ubcp/package_ubcp-cygwinOnly.tar.flx > /dev/null 2>&1
	
	if [[ "$ubPackage_enable_ubcp" == 'true' ]]
	then
		_package_ubcp_copy "$@"
	fi
	
	cd "$safeTmp"/package/
	_package_subdir
	
	# ATTENTION: Unusual. Expected to result in a package containing only 'ubcp' directory in the root.
	# WARNING: Having these subdirectories opened in MSW 'explorer' (file manager) may cause this directory to not exist.
	! cd "$safeTmp"/package/"$objectName"/_local && _stop 1
	
	#tar -czvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.gz .
	#env XZ_OPT="-5 -T0" tar -cJvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz .
	#env XZ_OPT="-0 -T0" tar -cJvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz .
	#tar -cvf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar .

	if [[ "$skimfast" != "true" ]]
	then
		tar -cvf - . | lz4 -z --fast=1 - "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx
	else
		tar -cf - . | lz4 -z --fast=1 - "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx
		#tar -cf "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx .
	fi
	
	mkdir -p "$scriptLocal"/ubcp/
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.gz "$scriptLocal"/ubcp/ > /dev/null 2>&1
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.xz "$scriptLocal"/ubcp/ > /dev/null 2>&1
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar "$scriptLocal"/ubcp/ > /dev/null 2>&1
	mv "$scriptAbsoluteFolder"/package_ubcp-cygwinOnly.tar.flx "$scriptLocal"/ubcp/
	
	_messagePlain_request 'request: review contents of _local/ubcp/cygwin/home and similar directories'
	sleep 20
	
	cd "$outerPWD"
	_stop
}




_package-cygwinOnly() {
	export ubPackage_enable_ubcp='true'
	"$scriptAbsoluteLocation" _package_procedure-cygwinOnly "$@"
}
_package-cygwin() {
	_package-cygwinOnly "$@"
}












