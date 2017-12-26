_test_transferimage() {
	_mustGetSudo
	
	_getDep rsync
}

_toImage() {
	#_openImage || return 1
	_openChRoot || return 1
	
	#rsync -avx -A -X "$1" "$globalVirtFS"/"$2"
	rsync -avx "$1" "$globalVirtFS"/"$2"
}

_toImageDir() {
	mkdir -p "$globalVirtFS"/"$2"
	_toImage "$1" "$2"
}

_fromImage() {
	#_openImage || return 1
	_openChRoot || return 1
	
	#rsync -avx -A -X "$globalVirtFS""$1" "$2"
	rsync -avx "$globalVirtFS""$1" "$2"
}

_fromImageDir() {
	mkdir -p "$2"
	_fromImage "$1" "$2"
}

_imageToArc() {
	[[ "$globalArcFS" == "" ]] && return 1
	[[ "$globalArcFS" == "/" ]] && return 1
	
	mkdir -p "$globalArcFS" || return 1
	
	_fromImageDir /home/user/. "$globalArcFS"/home/user
	_fromImageDir /etc/skel/. "$globalArcFS"/etc/skel
}

_imageFromArc() {
	[[ "$globalArcFS" == "" ]] && return 1
	[[ "$globalArcFS" == "/" ]] && return 1
	
	mkdir -p "$globalArcFS" || return 1
	
	_toImageDir "$globalArcFS"/home/user/. /home/user
	_toImageDir "$globalArcFS"/etc/skel/. /etc/skel
}

#Example. Translates permissions and copies ".arduino" directory.
_buildFromImage() {
	_mustGetSudo
	
	[[ "$globalBuildDir" == "" ]] && return 1
	[[ "$globalBuildDir" == "/" ]] && return 1
	
	mkdir -p "$globalBuildDir" || return 1
	
	sudo -n "$scriptAbsoluteLocation" _fromImageDir /home/user/.arduino/. "$globalBuildDir"/.arduino
	#sudo -n "$scriptAbsoluteLocation" _fromImageDir /etc/skel/.arduino/. "$globalBuildDir"/.arduino
	
	_safePath "$globalBuildDir"/.arduino && sudo -n chown -R "$USER":"$GROUP" "$globalBuildDir"/.arduino
}

#Example. Translates permissions and copies ".arduino" directory.
_buildToImage() {
	_mustGetSudo
	
	[[ "$globalBuildDir" == "" ]] && return 1
	[[ "$globalBuildDir" == "/" ]] && return 1
	
	mkdir -p "$globalBuildDir" || return 1
	
	sudo -n "$scriptAbsoluteLocation" _toImageDir "$globalBuildDir"/.arduino/. /home/user/.arduino
	sudo -n "$scriptAbsoluteLocation" _toImageDir "$globalBuildDir"/.arduino/. /etc/skel/.arduino
	
	_chroot chown -R user:user /home/user/.arduino
	_chroot chown -R root:root /etc/skel/.arduino
}

