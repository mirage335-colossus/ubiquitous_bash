@rem(){ :;};@rem echo '
@echo off
@goto b
' > /dev/null 2>&1 ;
rem(){ :;};rem

# ATTENION: NOTICE: No production use! Different from other 'anchor' scripts and unusual in that this specifically calls only the bash environment at the standard  "$HOME"/core/infrastructure  ,  'p/zCore/infrastructure'  locations normally used for development of 'ubiquitous_bash' itself .

# Useful for 'factory' development and use, for which '_factory*' and '__factoryCreate*' function code is more often revised .









# UNIX/Linux
export force_profileScriptLocation="$HOME"/core/infrastructure/ubiquitous_bash/ubcore.sh
export force_profileScriptFolder="$HOME"/core/infrastructure/ubiquitous_bash
"$HOME"/core/infrastructure/ubiquitous_bash/_bash.bat "$@"
exit "$?"



exit 1

:b




REM Cygwin/MSW
set "force_profileScriptLocation=/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash/ubcore.sh"
set "force_profileScriptFolder=/cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash"
CALL "C:\q\p\zCore\infrastructure\ubiquitous_bash\_bash.bat" %*
EXIT /B



goto :end

:end
