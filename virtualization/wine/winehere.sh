_setBottleDir() {
	export wineExeDir
	export wineBottle
	export WINEPREFIX
	
	export sharedHostProjectDir
	export sharedGuestProjectDir
	export processedArgs
	
	local wineAppDir
	local oldWineAppDir
	
	#wineExeDir=$(_searchBaseDir "$@" "$PWD")
	wineExeDir="$PWD"
	
	[[ -e "$1" ]] && [[ "$1" == *".exe" ]] && wineExeDir=$(_getAbsoluteFolder "$1")
	
	
	if uname -m | grep 64 > /dev/null 2>&1
	then
		wineAppDir=${wineExeDir/\/_wbottle*}
		wineBottle="$wineAppDir"/_wbottle
		
		#Optional support for older naming convention.
		#oldWineAppDir=${wineExeDir/\/wineBottle*}
		#[[ -e "$oldWineAppDir"/wineBottle ]] && wineBottle="$oldWineAppDir"/wineBottle
	else
		wineAppDir=${wineExeDir/\/_wine32*}
		wineBottle="$wineAppDir"/_wine32
		export WINEARCH
		WINEARCH=win32
	fi
	
	
	mkdir -p "$wineBottle"
	
	export WINEPREFIX="$wineBottle"/
	
	sharedHostProjectDir=/
	sharedGuestProjectDir='Z:'
	
	_virtUser "$@"
	
}

_wine() {
	_setBottleDir "$@"
	
	wine "${processedArgs[@]}"
}
