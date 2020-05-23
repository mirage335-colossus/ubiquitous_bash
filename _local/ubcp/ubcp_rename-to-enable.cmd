@echo off
setlocal enabledelayedexpansion
set "CWD=%cd%"
set CYGWIN_DRIVE=%~d0
set "CYGWIN_ROOT=%~dp0cygwin"

set "CYGWIN_PATH=%SystemRoot%\system32;%SystemRoot%;%CYGWIN_ROOT%\bin"
for /f "tokens=*" %%i in ('where adb.exe 2^>NUL') do set "CYGWIN_PATH=%CYGWIN_PATH%;%%i\.."
for /f "tokens=*" %%i in ('where docker.exe 2^>NUL') do set "CYGWIN_PATH=%CYGWIN_PATH%;%%i\.."
set "PATH=%CYGWIN_PATH%"

set "ALLUSERSPROFILE=%CYGWIN_ROOT%\.ProgramData"
set "ProgramData=%ALLUSERSPROFILE%"
set CYGWIN=nodosfilewarning

set "USERNAME=root"
set "HOME=/home/%USERNAME%"
set SHELL=/bin/bash
set HOMEDRIVE=%CYGWIN_DRIVE%
set "HOMEPATH=%CYGWIN_ROOT%\home\%USERNAME%"
set GROUP=None
set GRP=

REM echo Replacing [/etc/fstab]...
(
    echo # /etc/fstab
    echo # IMPORTANT: this files is recreated on each start by cygwin-portable.cmd
    echo #
    echo #    This file is read once by the first process in a Cygwin process tree.
    echo #    To pick up changes, restart all Cygwin processes.  For a description
    echo #    see https://cygwin.com/cygwin-ug-net/using.html#mount-table
    echo.
    echo # noacl = disable Cygwin's - apparently broken - special ACL treatment which prevents apt-cyg and other programs from working
    echo none /cygdrive cygdrive binary,noacl,posix=0,user 0 0
) > "%CYGWIN_ROOT%\etc\fstab"

%CYGWIN_DRIVE%
chdir "%CYGWIN_ROOT%\bin"
REM echo Loading [%CYGWIN_ROOT%\portable-init.sh]...
REM Performed later to (possibly) save time. bash "%CYGWIN_ROOT%\portable-init.sh"

set "arg1=%~1"
setlocal EnableDelayedExpansion
if "!arg1!" == "" (
  
  bash "%CYGWIN_ROOT%\portable-init.sh"
  
  start "" "%~dp0conemu\ConEmu64.exe" -Title cygwin-portable  -QuitOnClose
) else (
  if "!arg1!" == "no-mintty" (
	
	bash "%CYGWIN_ROOT%\portable-init.sh"
	
    bash --login -i
	
  ) else (
    
	REM TODO: Calling from same shell may improve performance.
	bash "%CYGWIN_ROOT%\portable-init.sh"
	
	REM Faster, but may not set environment variables and such.
	REM bash -- %*
	
	REM Parameters may not be interpreted correctly.
	REM bash --login -c %*
	
	REM Better chance of correctly interpreting parameters.
	bash --login -- %*
  )
)

cd "%CWD%"
