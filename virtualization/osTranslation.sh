
#Removes 'file://' often used by browsers.
_removeFilePrefix() {
	local translatedFileParam
	translatedFileParam=${1/#file:\/\/}
	
	echo "$translatedFileParam"
}

#Translates back slash parameters (UNIX paths) to forward slash parameters (MSW paths).
_slashBackToForward() {
	local translatedFileParam
	translatedFileParam=${1//\//\\}
	
	echo "$translatedFileParam"
}

_nixToMSW() {
	echo -e -n 'Z:'
	local localAbsoluteFirstParam
	localAbsoluteFirstParam=$(_getAbsoluteLocation "$1")
	_slashBackToForward "$localAbsoluteFirstParam"
}
