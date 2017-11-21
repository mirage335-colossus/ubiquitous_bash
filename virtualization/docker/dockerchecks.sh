_checkBaseDirRemote_docker() {
	#-e LOCAL_USER_ID=`id -u $USER`
	if ! _permitDocker docker run -it --name "$dockerContainerObjectNameInstanced"_cr --rm "$dockerImageObjectName" /bin/bash -c '[[ -e "'"$1"'" ]] && ! [[ -d "'"$1"'" ]] && [[ "'"$1"'" != "." ]] && [[ "'"$1"'" != ".." ]] && [[ "'"$1"'" != "./" ]] && [[ "'"$1"'" != "../" ]]'
	then
		return 1
	fi
	return 0
}
