#Triggers before "user" and "edit" virtualization commands, to allow a single installation of a virtual machine to be used by multiple ubiquitous labs.
#Does NOT trigger for all non-user commands (eg. open, docker conversion), as these are intended for developers with awareness of associated files under "$scriptLocal".

# WARNING
# DISABLED by default. Must be explicitly enabled by setting "$ubVirtImageLocal" to "false" in "ops".

#toImage

#_closeChRoot

#_closeVBoxRaw

#_editQemu
#_editVBox

#_userChRoot
#_userQemu
#_userVBox

#_userDocker

#_dockerCommit
#_dockerLaunch
#_dockerAttach
#_dockerOn
#_dockerOff

_findInfrastructure_virtImage() {
	[[ "$ubVirtImageLocal" != "false" ]] && return 0
	
	[[ -e "$scriptLocal"/vm.img ]] && export ubVirtImageLocal="true" && return 0
	[[ -e "$scriptLocal"/vm.vdi ]] && export ubVirtImageLocal="true" && return 0
	[[ -e "$scriptLocal"/vmvdiraw.vmdi ]] && export ubVirtImageLocal="true" && return 0
	
	_checkSpecialLocks && export ubVirtImageLocal="true" && return 0
	
	_findInfrastructure_virtImage_script "$@"
}

# WARNING
#Overloading with "ops" is recommended.
_findInfrastructure_virtImage_script() {
	local infrastructureName=$(basename "$scriptAbsoluteFolder")
	
	local recursionExec
	
	recursionExec="$scriptAbsoluteFolder"/../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
# 	recursionExec="$scriptAbsoluteFolder"/../core/lab/"$infrastructureName"/ubiquitous_bash.sh
# 	if _recursion_guard "$recursionExec"
# 	then
# 		"$recursionExec" "$@"
# 		return
# 	fi
	
	recursionExec="$scriptAbsoluteFolder"/../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
# 	recursionExec="$scriptAbsoluteFolder"/../../core/lab/"$infrastructureName"/ubiquitous_bash.sh
# 	if _recursion_guard "$recursionExec"
# 	then
# 		"$recursionExec" "$@"
# 		return
# 	fi
	
	recursionExec="$scriptAbsoluteFolder"/../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
# 	recursionExec="$scriptAbsoluteFolder"/../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh
# 	if _recursion_guard "$recursionExec"
# 	then
# 		"$recursionExec" "$@"
# 		return
# 	fi
	
	recursionExec="$scriptAbsoluteFolder"/../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
# 	recursionExec="$scriptAbsoluteFolder"/../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh
# 	if _recursion_guard "$recursionExec"
# 	then
# 		"$recursionExec" "$@"
# 		return
# 	fi
	
	recursionExec="$scriptAbsoluteFolder"/../../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
# 	recursionExec="$scriptAbsoluteFolder"/../../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh
# 	if _recursion_guard "$recursionExec"
# 	then
# 		"$recursionExec" "$@"
# 		return
# 	fi
	
	recursionExec="$scriptAbsoluteFolder"/../../../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
# 	recursionExec="$scriptAbsoluteFolder"/../../../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh
# 	if _recursion_guard "$recursionExec"
# 	then
# 		"$recursionExec" "$@"
# 		return
# 	fi
	
	recursionExec="$scriptAbsoluteFolder"/../../../../../../../core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
# 	recursionExec="$scriptAbsoluteFolder"/../../../../../../../core/lab/"$infrastructureName"/ubiquitous_bash.sh
# 	if _recursion_guard "$recursionExec"
# 	then
# 		"$recursionExec" "$@"
# 		return
# 	fi
	
	recursionExec="$HOME"/core/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
	recursionExec="$HOME"/extra/infrastructure/vm/"$infrastructureName"/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
	recursionExec="$HOME"/core/infrastructure/nixexevm/ubiquitous_bash.sh
	[[ "$virtOStype" == 'MSW'* ]] && recursionExec="$HOME"/core/infrastructure/winexevm/ubiquitous_bash.sh
	[[ "$virtOStype" == 'Windows'* ]] && recursionExec="$HOME"/core/infrastructure/winexevm/ubiquitous_bash.sh
	[[ "$vboxOStype" == 'Windows'* ]] && recursionExec="$HOME"/core/infrastructure/winexevm/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
	
	recursionExec="$HOME"/extra/infrastructure/nixexevm/ubiquitous_bash.sh
	[[ "$virtOStype" == 'MSW'* ]] && recursionExec="$HOME"/core/infrastructure/winexevm/ubiquitous_bash.sh
	[[ "$virtOStype" == 'Windows'* ]] && recursionExec="$HOME"/core/infrastructure/winexevm/ubiquitous_bash.sh
	[[ "$vboxOStype" == 'Windows'* ]] && recursionExec="$HOME"/core/infrastructure/winexevm/ubiquitous_bash.sh
	if _recursion_guard "$recursionExec"
	then
		"$recursionExec" "$@"
		return
	fi
}
