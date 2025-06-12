
# CAUTION: Compatibility with shells other than bash is apparently important .
# CAUTION: Compatibility with bash shell is important (eg. for '_dropBootdisc' ) .
_setupUbiquitous_accessories_here-plasma_hook() {
	cat << CZXWXcRMTo8EmM8i4d

# sourced by /usr/lib/x86_64-linux-gnu/libexec/plasma-sourceenv.sh

LANG=C
export LANG

CZXWXcRMTo8EmM8i4d

	_setupUbiquitous_accessories_here-nixenv-bashrc

	
}





_setupUbiquitous_accessories_here-vimrc() {
	cat << CZXWXcRMTo8EmM8i4d



" ubcore

" https://stackoverflow.com/questions/27871937/markdown-syntax-coloring-for-less-pager
" https://www.benpickles.com/articles/88-vim-syntax-highlight-markdown-code-blocks
" https://github.com/tpope/vim-markdown
let g:markdown_fenced_languages = ['html', 'js=javascript', 'ruby', 'python', 'bash=sh']
let g:markdown_minlines = 1750


CZXWXcRMTo8EmM8i4d
}





# ATTENTION: Override with 'ops.sh' , 'core.sh' , or similar.
_setupUbiquitous_accessories_here-gnuoctave() {
	cat << CZXWXcRMTo8EmM8i4d

%# https://stackoverflow.com/questions/8260619/how-can-i-suppress-the-output-of-a-command-in-octave
%# oldpager = PAGER('/dev/null');
%# oldpso = page_screen_output(1);
%# oldpoi = page_output_immediately(1);


format long g;


deci = 10^-1;
centi = 10^-2;
milli = 10^-3;
micro = 10^-6;
nano =-10^-9;
pico = 10^-12;
femto = 10^-15;
atto = 10^-18;

kilo = 10^3;
mega = kilo * 10^3;
giga = mega * 10^3;
tera = giga * 10^3;


bit = 1;
byte = bit * 8;
Byte = bit * 8;

kilobit = kilo * bit;
megabit = mega * bit;
gigabit = giga * bit;
terabit = tera * bit;

kb = kilobit;
Kb = kilobit;
Mb = megabit;
Gb = gigabit;
Tb = terabit;

kiloByte = kilobit * Byte;
megaByte = megabit * Byte;
gigaByte = gigabit * Byte;
teraByte = terabit * Byte;

kilobyte = kilobit * Byte;
megabyte = megabit * Byte;
gigabyte = gigabit * Byte;
terabyte = terabit * Byte;

kB = kiloByte;
KB = kiloByte;
MB = megaByte;
GB = gigaByte;
TB = teraByte;


kibi = 1024;
mebi = kibi * 1024;
gibi = mebi * 1024;
tebi = gibi * 1024;

kibibit = kibi * bit;
mebibit = mebi * bit;
gibibit = gibi * bit;
tebibit = tebi * bit;

Kib = kibibit;
Mib = mebibit;
Gib = gibibit;
Tib = tebibit;

kibiByte = kibi * Byte;
mebiByte = mebi * Byte;
gibiByte = gibi * Byte;
tebiByte = tebi * Byte;

kibibyte = kibi * Byte;
mebibyte = mebi * Byte;
gibibyte = gibi * Byte;
tebibyte = tebi * Byte;

KiB = kibiByte;
MiB = mebiByte;
GiB = gibiByte;
TiB = tebiByte;



meter = 1;

kilometer = kilo * meter;
megameter = mega * meter;
Megameter = megameter;

decimeter = deci * meter;
centimeter = centi * meter;
millimeter = milli * meter;
micrometer = micro * meter;
nanometer = nano * meter;
picometer = pico * meter;
femtometer = femto * meter;
attometer = atto * meter;



%# 1 * lightsecond ~= 300 * Mega * meter
lightsecond = 299792458 * meter;
lightSecond = lightsecond;

lightyear = lightsecond * 365 * 24 * 3600;
lightYear = lightyear;



hertz = 1;

kilohertz = kilo * hertz;
megahertz = mega * hertz;
gigahertz = giga * hertz;
terahertz = tera * hertz;

kHz = kilohertz;
KHz = kilohertz;
MHz = megahertz;
GHz = gigahertz;
THz = terahertz;



unix("true");
system("true");

cd;

%# Equivalent to Ctrl-L . 
%# https://stackoverflow.com/questions/11269571/how-to-clear-the-command-line-in-octave
clc;


%# PAGER(oldpager);
%# page_screen_output(oldpso);
%# page_output_immediately(oldpoi);

CZXWXcRMTo8EmM8i4d


	! _if_cygwin && cat << CZXWXcRMTo8EmM8i4d

pkg load symbolic;

syms a b c d e f g h i j k l m n o p q r s t u v w x y z;


%# https://octave.sourceforge.io/symbolic/overview.html
nsolve = @vpasolve;

CZXWXcRMTo8EmM8i4d

}


_setupUbiquitous_accessories_here-gnuoctave_hook() {
	cat << CZXWXcRMTo8EmM8i4d

%# oldpager = PAGER('/dev/null');
%# oldpso = page_screen_output(1);
%# oldpoi = page_output_immediately(1);

%# ubcore
run("$ubcore_accessoriesFile_gnuoctave_ubhome");

%# PAGER(oldpager);
%# page_screen_output(oldpso);
%# page_output_immediately(oldpoi);

CZXWXcRMTo8EmM8i4d
}




_setupUbiquitous_accessories_here-cloud_bin() {
	cat << CZXWXcRMTo8EmM8i4d

if [[ "\$PATH" != *'.ebcli-virtual-env/executables'* ]] && [[ -e "$HOME"/.ebcli-virtual-env/executables ]]
then
	# WARNING: Must interpret "$HOME" as is at this point and NOT after any "$HOME" override.
	export PATH="$HOME"/.ebcli-virtual-env/executables:"\$PATH"
fi


if [[ "\$PATH" != *'.gcloud/google-cloud-sdk'* ]] && [[ -e "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc ]] && [[ -e "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc ]]
then
	. "$HOME"/.gcloud/google-cloud-sdk/completion.bash.inc
	. "$HOME"/.gcloud/google-cloud-sdk/path.bash.inc
fi

CZXWXcRMTo8EmM8i4d
}





_setupUbiquitous_accessories_here-python() {
	
	_generate_lean-lib-python_here "$@"
	
} 

_setupUbiquitous_accessories_here-python_hook() {
	cat << CZXWXcRMTo8EmM8i4d

# ATTENTION: Without either 'exec(exec(open()))' or 'execfile()' , 'from ubcorerc_pythonrc import *' must take effect!
# If 'exec(exec(open()))' is substituted for 'from ubcorerc_pythonrc import *' then copying home directory files independent of '.ubcore' 
import os
if os.path.exists(r"$ubcore_accessoriesFile_python"):
	import sys
	import os
	# https://stackoverflow.com/questions/2349991/how-to-import-other-python-files
	sys.path.append(os.path.abspath(r"$ubcoreDir_accessories_python"))
	from $ubcore_ubcorerc_pythonrc import *





import sys
# https://stackoverflow.com/questions/436198/what-is-an-alternative-to-execfile-in-python-3
if sys.hexversion > 0x03000000:
	exec(r'exec(open( r"$ubcore_accessoriesFile_python_ubhome" ).read() )')
else:
	execfile(r"$ubcore_accessoriesFile_python_ubhome")




CZXWXcRMTo8EmM8i4d
}



_setupUbiquitous_accessories_here-python_bashrc() {
	cat << CZXWXcRMTo8EmM8i4d

# Interactive bash shell will default to calling 'python3' while scripts invoking '#! /usr/bin/env python' or similar may still be given 'python2' equivalent.
[[ "\$_PATH_pythonDir" == "" ]] && alias python=python3

[[ "\$_PATH_pythonDir" == "" ]] && [[ "\$_PYTHONSTARTUP" == "" ]] && export PYTHONSTARTUP="$HOME"/.pythonrc

[[ "\$_PATH_pythonDir" != "" ]] && _set_msw_python_procedure

CZXWXcRMTo8EmM8i4d
}




_setupUbiquitous_accessories_here-nixenv-bashrc() {
	cat << CZXWXcRMTo8EmM8i4d

[[ -e "$HOME"/.nix-profile/etc/profile.d/nix.sh ]] && . "$HOME"/.nix-profile/etc/profile.d/nix.sh

# WARNING: Binaries from Nix should not be prepended to Debian PATH, as they may be incompatible with other Debian software (eg. incorrect Python version).
# Scripts that need to rely preferentially on Nix binaries should detect this situation, defining and calling an appropriate wrapper function.
# CAUTION: SEVERE - Issue unresolved. PATH written out to log file matches ' [[ "\$PATH" == *"nix-profile/bin"* ]] ' when run through interactive shell, but, with the exact same PATH value, not when called through some script contexts (eg. 'plasma-workspace/env' ) . Yet grep does match .
#  Hidden or invalid characters in "\$PATH" would seem a sensible cause, but how grep would disregard this while bash would not, seems difficult to explain.
#  Expected cause is interpretation by a shell other than bash .
#   CAUTION: Compatability with shells other than bash may be important .
# CAUTION: Compatibility with bash shell is important (eg. for '_dropBootdisc' ) .
if echo "\$PATH" | grep 'nix-profile/bin' > /dev/null 2>&1 || [[ "\$PATH" == *"nix-profile/bin"* ]]
then
	PATH=\$(echo "\$PATH" | sed 's|:'"$HOME"'/.nix-profile/bin||g;s|'"$HOME"'/.nix-profile/bin:||g')
	export PATH
	PATH="\$PATH":"$HOME"/.nix-profile/bin
	export PATH
fi

CZXWXcRMTo8EmM8i4d
}









_setupUbiquitous_accessories_here-coreoracle_bashrc() {
	
	if _if_cygwin
	then
		cat << CZXWXcRMTo8EmM8i4d

if [[ -e /cygdrive/c/core/infrastructure/coreoracle ]]
then
	export shortcutsPath_coreoracle=/cygdrive/c/"core/infrastructure/coreoracle"
	. /cygdrive/c/core/infrastructure/coreoracle/_shortcuts-cygwin.sh
elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle-msw ]]
then
	export shortcutsPath_coreoracle=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/coreoracle-msw"
	. /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle-msw/_shortcuts-cygwin.sh
#elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle ]]
#then
	#export shortcutsPath_coreoracle=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/coreoracle"
	#. /cygdrive/c/core/infrastructure/extendedInterface/_lib/coreoracle/_shortcuts-cygwin.sh
fi


if [[ -e /cygdrive/c/core/infrastructure/quickWriter ]]
then
	export shortcutsPath_quickWriter=/cygdrive/c/"core/infrastructure/quickWriter"
	. /cygdrive/c/core/infrastructure/quickWriter/_shortcuts-cygwin.sh
elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter-msw ]]
then
	export shortcutsPath_quickWriter=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/quickWriter-msw"
	. /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter-msw/_shortcuts-cygwin.sh
elif [[ -e /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter ]]
then
	export shortcutsPath_quickWriter=/cygdrive/c/"core/infrastructure/extendedInterface/_lib/quickWriter"
	. /cygdrive/c/core/infrastructure/extendedInterface/_lib/quickWriter/_shortcuts-cygwin.sh
fi

CZXWXcRMTo8EmM8i4d
	else
		cat << CZXWXcRMTo8EmM8i4d

if type sudo > /dev/null 2>&1 && groups | grep -E 'wheel|sudo' > /dev/null 2>&1 && ! uname -a | grep -i cygwin > /dev/null 2>&1
then
	# Greater or equal, '_priority_critical_pid_root' .
	sudo -n renice -n -15 -p \$\$ > /dev/null 2>&1
	sudo -n ionice -c 2 -n 2 -p \$\$ > /dev/null 2>&1
fi



if [[ -e "$HOME"/core/infrastructure/coreoracle ]]
then
	export shortcutsPath_coreoracle="$HOME"/core/infrastructure/coreoracle/
	. "$HOME"/core/infrastructure/coreoracle/_shortcuts.sh
fi


if [[ -e "$HOME"/core/infrastructure/quickWriter ]]
then
	export shortcutsPath_quickWriter="$HOME"/core/infrastructure/quickWriter/
	. "$HOME"/core/infrastructure/quickWriter/_shortcuts.sh
fi



# Returns priority to normal.
# Greater or equal, '_priority_app_pid_root' .
#ionice -c 2 -n 3 -p \$\$
#renice -n -5 -p \$\$ > /dev/null 2>&1

# Returns priority to normal.
# Greater or equal, '_priority_app_pid' .
ionice -c 2 -n 4 -p \$\$
renice -n 0 -p \$\$ > /dev/null 2>&1


CZXWXcRMTo8EmM8i4d
	fi
}





_setupUbiquitous_accessories_here-convenience() {
		cat << CZXWXcRMTo8EmM8i4d

# Equivalence to Dockerfile .
#alias RUN=_bin
alias RUN=""
#  #RUN ( echo test )

CZXWXcRMTo8EmM8i4d

}





_setupUbiquitous_accessories_here-user_bashrc() {
	
	# Calls   "$HOME"/_bashrc   as a place for user defined functions, environment varialbes, etc, which should NOT follow dist/OS updates (eg. extendedInterface reinstallation) and should be copied after dist/OS reinstallation (ie. placed on an SDCard or similar before '_revert-fromLive /dev/sda' .
	#  WARNING: Nevertheless, bashrc is very bad practice . Instead, functionality should be pushed upstream (eg. to 'ubiquitous bash', etc) .
	#   The exception may be very specialized infrastructure (ie. conveniently calling specialized Virtual Machines).
	
	cat << CZXWXcRMTo8EmM8i4d

if [[ -e "$HOME"/_bashrc ]]
then
	. "$HOME"/_bashrc
fi

CZXWXcRMTo8EmM8i4d

}


_setupUbiquitous_accessories_here-container_environment() {
	
	cat << CZXWXcRMTo8EmM8i4d

# Coordinator/Worker, SSH Authorized
if [[ "\$SSH_pub_Coordinator_01" != "" ]] || [[ "\$PUBLIC_KEY" != "" ]]
then
	_ubcore_add_authorized_SSH() {
		[[ "\$1" == "" ]] && return 0

		mkdir -p "$HOME"/.ssh
		chmod 700 "$HOME"/.ssh 2> /dev/null
		
		local currentString=\$(printf '%s' "\$1" | awk '{print \$2}' | tr -dc 'a-zA-Z0-9')

		[[ ! -e "$HOME"/.ssh/authorized_keys ]] && echo -n > "$HOME"/.ssh/authorized_keys && chmod 600 "$HOME"/.ssh/authorized_keys
		if cat "$HOME"/.ssh/authorized_keys | tr -dc 'a-zA-Z0-9' | grep "\$currentString" > /dev/null 2>&1
		then
			return 0
		else
			echo "\$1" >> "$HOME"/.ssh/authorized_keys
			chmod 600 "$HOME"/.ssh/authorized_keys
			return 0
		fi
		return 1
	}

	_ubcore_add_authorized_SSH "\$PUBLIC_KEY"
	
	_ubcore_add_authorized_SSH "\$SSH_pub_Coordinator_01"
	_ubcore_add_authorized_SSH "\$SSH_pub_Coordinator_02"
	_ubcore_add_authorized_SSH "\$SSH_pub_Coordinator_03"

	unset _ubcore_add_authorized_SSH
fi

[[ -e /.dockerenv ]] && git config --global --add safe.directory '*' > /dev/null 2>&1

CZXWXcRMTo8EmM8i4d

}















