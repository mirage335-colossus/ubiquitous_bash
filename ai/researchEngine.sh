

_setup_researchEngine() {
	if [[ -e "$scriptLib"/kit/app/researchEngine ]]
	then
		export kit_dir_researchEngine="$scriptLib"/kit/app/researchEngine
		. "$scriptLib"/kit/app/researchEngine/kit/researchEngine.sh
		if [[ "$1" == "" ]]
		then
			_setup_researchEngine-kit
		else
			"$@"
		fi
		return
	fi
	
	if [[ -e "$scriptLib"/ubiquitous_bash/_lib/kit/app/researchEngine ]]
	then
		export kit_dir_researchEngine="$scriptLib"/ubiquitous_bash/_lib/kit/app/researchEngine
		. "$scriptLib"/ubiquitous_bash/_lib/kit/app/researchEngine/kit/researchEngine.sh
		if [[ "$1" == "" ]]
		then
			_setup_researchEngine-kit
		else
			"$@"
		fi
		return
	fi
	
	if [[ -e "$scriptLib"/ubDistBuild/_lib/ubiquitous_bash/_lib/kit/app/researchEngine ]]
	then
		export kit_dir_researchEngine="$scriptLib"/ubDistBuild/_lib/ubiquitous_bash/_lib/kit/app/researchEngine
		. "$scriptLib"/ubDistBuild/_lib/ubiquitous_bash/_lib/kit/app/researchEngine/kit/researchEngine.sh
		if [[ "$1" == "" ]]
		then
			_setup_researchEngine-kit
		else
			"$@"
		fi
		return
	fi
	
	_messagePlain_bad 'bad: missing: kit researchEngine'
	_messageFAIL
	_stop 1
}



_upgrade_researchEngine() {
	_setup_researchEngine _service_researchEngine-docker-chroot-start

	_setup_researchEngine _upgrade_researchEngine_searxng "$@"
	_setup_researchEngine _upgrade_researchEngine_openwebui "$@"

	_setup_researchEngine _service_researchEngine-docker-chroot-stop
}

_upgrade_researchEngine-nvidia() {
	_setup_researchEngine _service_researchEngine-docker-chroot-start
	
	_setup_researchEngine _upgrade_researchEngine_searxng "$@"
	_setup_researchEngine _upgrade_researchEngine_openwebui-nvidia "$@"

	_setup_researchEngine _service_researchEngine-docker-chroot-stop
}


# WARNING: May be untested.
# Avoids attempting to upgrade services more likely to break (ie. 'searxng'). 
_upgrade_researchEngine-safe() {
	_setup_researchEngine _service_researchEngine-docker-chroot-start

	#_setup_researchEngine _upgrade_researchEngine_searxng "$@"
	_setup_researchEngine _upgrade_researchEngine_openwebui "$@"

	_setup_researchEngine _service_researchEngine-docker-chroot-stop
}
_upgrade_researchEngine-safe-nvidia() {
	_setup_researchEngine _service_researchEngine-docker-chroot-start
	
	#_setup_researchEngine _upgrade_researchEngine_searxng "$@"
	_setup_researchEngine _upgrade_researchEngine_openwebui-nvidia "$@"

	_setup_researchEngine _service_researchEngine-docker-chroot-stop
}

