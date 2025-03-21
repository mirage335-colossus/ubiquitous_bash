

# _upgrade-import-assets corpName
_upgrade-import-assets() {
    local corpName="$1"


	_start
    export safeToDeleteGit="true"

	! cd "$safeTmp" && _messageFAIL

	if ! ( type _gitBest > /dev/null 2>&1 && _gitBest clone --depth 1 'git@github.com:soaringDistributions/zImport_corp_'"$corpName"'.git' )
	then
		if ls -1 "$HOME"/.ssh/id_* > /dev/null
		then
			if ! git clone --depth 1 'git@github.com:soaringDistributions/zImport_corp_'"$corpName"'.git'
			then
				_messagePlain_bad 'bad: upgrade-import-assets-'"$corpName"': git: FAIL: fail'
				_messageFAIL
				_stop 1
				exit 1
            fi
		else
			_messagePlain_bad 'bad: upgrade-import-assets-'"$corpName"': git: FAIL: no remote permissions'
			_messageFAIL
			_stop 1
			exit 1
		fi
	fi

	mkdir -p "$scriptLib"/zImport_corp_"$corpName"
	mv -f "$safeTmp"/zImport_corp_"$corpName"/*.sh "$scriptLib"/zImport_corp_"$corpName"/
	mv -f "$safeTmp"/zImport_corp_"$corpName"/*.yml "$scriptLib"/zImport_corp_"$corpName"/
	mv -f "$safeTmp"/zImport_corp_"$corpName"/*.txt "$scriptLib"/zImport_corp_"$corpName"/
	mv -f "$safeTmp"/zImport_corp_"$corpName"/*.md "$scriptLib"/zImport_corp_"$corpName"/

	_stop
}
