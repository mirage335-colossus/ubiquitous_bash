
# ATTENTION: DANGER: Obsolete. Not included by default. No known production use.


_test_deveclipse() {
	_wantGetDep eclipse
	
	! [[ -e /usr/share/eclipse/dropins/cdt ]] && echo 'warn: missing: /usr/share/eclipse/dropins/cdt'
}

#"$1" == workspaceDir
_prepare_eclipse_workspace() {
	local local_workspace_import="$1"/_import
	
	mkdir -p "$local_workspace_import"
	
	local local_workspace_abstract
	
	#Scope
	if [[ "$ub_specimen" != "" ]] && [[ "$ub_scope" != "" ]]
	then
		local_workspace_abstract=$(_name_abstractfs "$ub_specimen")
		
		mkdir -p "$local_workspace_import"/"$local_workspace_abstract"
		
		_relink "$ub_specimen" "$local_workspace_import"/"$local_workspace_abstract"/specimen
		_relink "$ub_scope" "$local_workspace_import"/"$local_workspace_abstract"/scope
		
		#Export directories to be used for projects/sets to be stored in shared repositories.
		mkdir -p "$ub_specimen"/_export
		_relink "$ub_specimen"/_export "$local_workspace_import"/"$local_workspace_abstract"/_export
		
		_messagePlain_good 'eclipse: install: specimen, scope: '"$local_workspace_import"/"$local_workspace_abstract"
	fi
	
	#Arbitary Project
	if [[ "$arbitraryProjectDir" != "" ]]
	then
		local_workspace_abstract=$(_name_abstractfs "$arbitraryProjectDir")
		
		mkdir -p "$local_workspace_import"/"$local_workspace_abstract"
		
		_relink "$arbitraryProjectDir" "$local_workspace_import"/"$local_workspace_abstract"
		
		#Export directories to be used for projects/sets to be stored in shared repositories.
		mkdir -p "$arbitraryProjectDir"/_export
		_relink "$arbitraryProjectDir"/_export "$local_workspace_import"/"$local_workspace_abstract"/_export
		
		_messagePlain_good 'eclipse: install: arbitraryProjectDir: '"$local_workspace_import"/"$local_workspace_abstract"
	fi
}

#Creates user and export directories for eclipse instance. User directories to be used for project specific workspace. Export directories to be used for projects/sets to be stored in shared repositories.
#"$eclipse_path" (eg. "$ub_specimen")
#"eclipse_root" (eg. ".eclipser")
_prepare_eclipse() {
	#Special meaning of "$PWD" when run under _abstractfs ("$localPWD") is intended.
	if [[ "$eclipse_path" == "" ]]
	then
		export eclipse_path=$(_getAbsoluteLocation "$PWD"/..)
		[[ "$ub_specimen" != "" ]] && export eclipse_path=$(_getAbsoluteLocation "$ub_specimen"/..)
		#[[ "$ub_scope" != "" ]] && export eclipse_path=$(_getAbsoluteLocation "$ub_scope")
	fi
	
	if [[ "$eclipse_root" == "" ]]
	then
		export eclipse_root=$(_name_abstractfs "$ub_specimen")
		export eclipse_root="$eclipse_root".ecr
		#export eclipse_root='eclipser'
		#export eclipse_root='.eclipser'
	fi
	
	export eclipse_user='user'
	
	#export eclipse_export='_export'
	
	export eclipse_data='workspace'
	export eclipse_config='configuration'
	
	mkdir -p "$eclipse_path"/"$eclipse_root"
	mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_user"
	#mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_export"
	mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_data"
	mkdir -p "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config"
	
	#_mustcarry 'eclipser/' "$eclipse_path"/"$eclipse_root"/.gitignore
	_mustcarry "$eclipse_user"/ "$eclipse_path"/"$eclipse_root"/.gitignore
	_mustcarry "$eclipse_data"/ "$eclipse_path"/"$eclipse_root"/.gitignore
	_mustcarry "$eclipse_user"/"$eclipse_config"/ "$eclipse_path"/"$eclipse_root"/.gitignore
}

_install_fakeHome_eclipse() {	
	_link_fakeHome "$eclipse_path"/"$eclipse_root"/"$eclipse_data" workspace
	
	_link_fakeHome "$eclipse_path"/"$eclipse_root"/"$eclipse_user" .eclipse
	#_link_fakeHome "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config" .eclipse/configuration
}

_eclipse_procedure() {
	_prepare_eclipse
	_prepare_eclipse_workspace "$eclipse_path"/"$eclipse_root"/"$eclipse_data"
	_messagePlain_probe eclipse -data "$eclipse_path"/"$eclipse_root"/"$eclipse_data" -configuration "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config" "$@"
	eclipse -data "$eclipse_path"/"$eclipse_root"/"$eclipse_data" -configuration "$eclipse_path"/"$eclipse_root"/"$eclipse_user"/"$eclipse_config" "$@"
}

_eclipse_config() {
	_eclipse_procedure "$@"
}

_eclipse_stock() {
	_prepare_eclipse_workspace "$HOME"/workspace
	eclipse -data "$HOME"/workspace "$@"
}

_eclipse_home() {
	_prepare_eclipse_workspace "$HOME"/workspace
	_messagePlain_probe eclipse -data "$HOME"/workspace -configuration "$HOME"/.eclipse/configuration "$@"
	eclipse -data "$HOME"/workspace -configuration "$HOME"/.eclipse/configuration "$@"
}

_eclipse_edit() {
	_prepare_eclipse
	
	export actualFakeHome="$shortFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="true"
	export keepFakeHome="true"
	
	_install_fakeHome_eclipse
	
	_fakeHome "$scriptAbsoluteLocation" --parent _eclipse_home "$@"
}

_eclipse_user() {
	_prepare_eclipse
	
	export actualFakeHome="$shortFakeHome"
	#export actualFakeHome="$globalFakeHome"
	export fakeHomeEditLib="false"
	export keepFakeHome="true"
	
	_install_fakeHome_eclipse
	
	_fakeHome "$scriptAbsoluteLocation" --parent _eclipse_home "$@"
}





_eclipse() {
	_eclipse_config "$@"
}
