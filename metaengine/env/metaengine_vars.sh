_set_me_host() {
	_set_me_base
	
	export metaTmp="$scriptAbsoluteFolder""$tmpPrefix"/.m_"$sessionid"
	export metaProc="$metaBase""$tmpPrefix"/.m_"$sessionid"
}

_reset_me_host() {
	_reset_me_base
	
	export metaTmp=
	export metaProc
}

_set_me() {
	_messagePlain_nominal 'init: _set_me'
	
	#_set_me_base
	#_set_me_objname
	
	_set_me_uid
	
	_set_me_path
	_set_me_dir
	_set_me_reg
	
	_set_me_io_in
	_set_me_io_out
	
	_message_me_set
}

_reset_me() {
	#_reset_me_base
	#_reset_me_objname
	
	_reset_me_host
	
	_reset_me_uid
	
	_reset_me_path
	_reset_me_dir
	_reset_me_reg
	
	_reset_me_name
	_reset_me_coordinates
	
	_reset_me_type
	
	_reset_me_io
	
	_stop_metaengine_allow
}

_set_me_uid() {
	[[ "$metaEmbed" == "true" ]] && return 0
	export metaID=$(_uid)
}

_reset_me_uid() {
	export metaID=
}

_set_me_path() {
	export metaPath="$metaID"
}

_reset_me_path() {
	export metaPath=
}

# ATTENTION: Overload with "core.sh" if appropriate.
_set_me_dir() {
	export metaDir_tmp="$metaTmp"/"$metaPath"
	
	export metaDir_base="$metaProc"/"$metaPath"
	
	export metaDir="$metaDir_tmp"
	[[ "$metaType" == "base" ]] && export metaDir="$metaDir_base" && _messagePlain_warn 'metaDir= base'
	[[ "$metaType" == "" ]] && _messagePlain_good 'metaDir= tmp'
}

_reset_me_dir() {
	export metaDir_tmp=
	export metaDir_base=
	
	export metaDir=
}

# ATTENTION: Overload with "core.sh" if appropriate.
_set_me_reg() {
	export metaReg="$metaTmp"/_reg
	[[ "$metaType" == "base" ]] && export metaReg="$metaBase"/_reg && _messagePlain_warn 'metaReg= base'
	[[ "$metaType" == "" ]] && _messagePlain_good 'metaReg= tmp'
}

_reset_me_reg() {
	export metaReg=
}




# ATTENTION: Overload with "core.sh" if appropriate.
_set_me_base() {
	export metaBase=
	
	export metaBase="$outerPWD"
	
	#[[ "$@" != "" ]] && export metaengine_base=$(_searchBaseDir "$@")
	#[[ "$metaengine_base" == "" ]] && export metaengine_base=$(_searchBaseDir "$@" "$virtUserPWD")
	
	#export metaengine_base="$scriptAbsoluteLocation"
}

_reset_me_base() {
	export metaBase=
}

# ATTENTION: Overload with "core.sh" if appropriate.
# WARNING: No default production use.
_set_me_objname() {
	export metaObjName=
	
	export metaObjName="$objectName"
}

_reset_me_objname() {
	export metaObjName=
}



_reset_me_coordinates_ai() {
	export in_me_a_x=
	export in_me_a_y=
	export in_me_a_z=
}

_reset_me_coordinates_bi() {
	export in_me_b_x=
	export in_me_b_y=
	export in_me_b_z=
}

_reset_me_coordinates_ao() {
	export out_me_a_x=
	export out_me_a_y=
	export out_me_a_z=
}

_reset_me_coordinates_bo() {
	export out_me_b_x=
	export out_me_b_y=
	export out_me_b_z=
}

_reset_me_coordinates() {
	_reset_me_coordinates_ai
	_reset_me_coordinates_bi
	_reset_me_coordinates_ao
	_reset_me_coordinates_bo
}


_check_me_coordinates_ai() {
	[[ "$in_me_a_x" == "" ]] && return 1
	[[ "$in_me_a_y" == "" ]] && return 1
	[[ "$in_me_a_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_bi() {
	[[ "$in_me_b_x" == "" ]] && return 1
	[[ "$in_me_b_y" == "" ]] && return 1
	[[ "$in_me_b_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_ao() {
	[[ "$out_me_a_x" == "" ]] && return 1
	[[ "$out_me_a_y" == "" ]] && return 1
	[[ "$out_me_a_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_bo() {
	[[ "$out_me_b_x" == "" ]] && return 1
	[[ "$out_me_b_y" == "" ]] && return 1
	[[ "$out_me_b_z" == "" ]] && return 1
	return 0
}

_check_me_coordinates_in() {
	! _check_me_coordinates_ai && return 1
	! _check_me_coordinates_bi && return 1
	return 0
}

_check_me_coordinates_out() {
	! _check_me_coordinates_ao && return 1
	! _check_me_coordinates_bo && return 1
	return 0
}

_check_me_coordinates() {
	! _check_me_coordinates_ai && return 1
	! _check_me_coordinates_bi && return 1
	! _check_me_coordinates_ao && return 1
	! _check_me_coordinates_bo && return 1
	return 0
}

_reset_me_name_ai() {
	export in_me_a_name=
}

_reset_me_name_bi() {
	export in_me_b_name=
}

_reset_me_name_ao() {
	export out_me_a_name=
}

_reset_me_name_bo() {
	export out_me_b_name=
}

_reset_me_rand() {
	_reset_me_name_ai
	_reset_me_name_bi
	_reset_me_name_ao
	_reset_me_name_bo
}
_reset_me_name() {
	_reset_me_name_ai
	_reset_me_name_bi
	_reset_me_name_ao
	_reset_me_name_bo
}

_check_me_name_in() {
	[[ "$in_me_a_name" == "" ]] && return 1
	[[ "$in_me_b_name" == "" ]] && return 1
	return 0
}

_check_me_name_out() {
	[[ "$out_me_a_name" == "" ]] && return 1
	[[ "$out_me_b_name" == "" ]] && return 1
	return 0
}

_check_me_name() {
	[[ "$in_me_a_name" == "" ]] && return 1
	[[ "$in_me_b_name" == "" ]] && return 1
	[[ "$out_me_a_name" == "" ]] && return 1
	[[ "$out_me_b_name" == "" ]] && return 1
	return 0
}
_check_me_rand() {
	_check_me_name
}


_set_me_io_name_in() {
	_messagePlain_nominal 'init: _set_me_io_name_in'
	
	export in_me_a_path="$metaReg"/name/"$in_me_a_name"/ao
		[[ "$in_me_a_name" == "null" ]] && export in_me_a_path=/dev/null
	export in_me_b_path="$metaReg"/name/"$in_me_b_name"/bo
		[[ "$in_me_b_name" == "null" ]] && export in_me_b_path=/dev/null
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_name_out() {
	_messagePlain_nominal 'init: _set_me_io_name_out'
	
	export out_me_a_path="$metaReg"/name/"$out_me_a_name"/ao
		[[ "$out_me_a_name" == "null" ]] && export out_me_a_path=/dev/null
	export out_me_b_path="$metaReg"/name/"$out_me_b_name"/bo
		[[ "$out_me_b_name" == "null" ]] && export out_me_b_path=/dev/null
	
	_messagePlain_good 'return: success'
	return 0
}

#No production use.
_set_me_io_name() {
	_messagePlain_nominal 'init: _set_me_io_name'
	
	export in_me_a_path="$metaReg"/name/"$in_me_a_name"/ao
		[[ "$in_me_a_name" == "null" ]] && export in_me_a_path=/dev/null
	export in_me_b_path="$metaReg"/name/"$in_me_b_name"/bo
		[[ "$in_me_b_name" == "null" ]] && export in_me_b_path=/dev/null
	export out_me_a_path="$metaReg"/name/"$out_me_a_name"/ao
		[[ "$out_me_a_name" == "null" ]] && export out_me_a_path=/dev/null
	export out_me_b_path="$metaReg"/name/"$out_me_b_name"/bo
		[[ "$out_me_b_name" == "null" ]] && export out_me_b_path=/dev/null
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_coordinates_in() {
	_messagePlain_nominal 'init: _set_me_io_coordinates_in'
	
	export in_me_a_path="$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x"/"$in_me_a_y"
	export in_me_b_path="$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x"/"$in_me_b_y"
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_coordinates_out() {
	_messagePlain_nominal 'init: _set_me_io_coordinates_out'
	
	export out_me_a_path="$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x"/"$out_me_a_y"
	export out_me_b_path="$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x"/"$out_me_b_y"
	
	_messagePlain_good 'return: success'
	return 0
}

#No production use.
_set_me_io_coordinates() {
	_messagePlain_nominal 'init: _set_me_io_coordinates'
	
	export in_me_a_path="$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x"/"$in_me_a_y"
	export in_me_b_path="$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x"/"$in_me_b_y"
	export out_me_a_path="$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x"/"$out_me_a_y"
	export out_me_b_path="$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x"/"$out_me_b_y"
	
	_messagePlain_good 'return: success'
	return 0
}

_set_me_io_in() {
	_messagePlain_nominal 'init: _set_me_io'
	
	! _check_me_coordinates_in && ! _check_me_name_in && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _set_me_io_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_in && _messagePlain_good 'valid: name_in' && _set_me_io_name_in && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _set_me_io_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_in && _messagePlain_good 'valid: coordinates_in' && _set_me_io_coordinates_in && _messagePlain_good 'return: success' && return 0
	
	_messageError 'FAIL: undefined failure'
	_stop 1
}

_set_me_io_out() {
	_messagePlain_nominal 'init: _set_me_io'
	
	! _check_me_coordinates_out && ! _check_me_name_out && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _set_me_io_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_out && _messagePlain_good 'valid: name_out' && _set_me_io_name_out && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _set_me_io_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_out && _messagePlain_good 'valid: coordinates_out' && _set_me_io_coordinates_out && _messagePlain_good 'return: success' && return 0
	
	_messageError 'FAIL: undefined failure'
	_stop 1
}

#No production use.
_set_me_io() {
	_messagePlain_nominal 'init: _set_me_io'
	
	! _check_me_coordinates && ! _check_me_name && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	#_check_me_name && _messagePlain_good 'valid: name' && _set_me_io_name && _messagePlain_good 'return: success' && return 0
	_check_me_name_in && _messagePlain_good 'valid: name_in' && _set_me_io_name_in && _messagePlain_good 'return: success' && return 0
	_check_me_name_out && _messagePlain_good 'valid: name_out' && _set_me_io_name_out && _messagePlain_good 'return: success' && return 0
	
	#_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _set_me_io_coordinates && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_in && _messagePlain_good 'valid: coordinates_in' && _set_me_io_coordinates_in && _messagePlain_good 'return: success' && return 0
	_check_me_coordinates_out && _messagePlain_good 'valid: coordinates_out' && _set_me_io_coordinates_out && _messagePlain_good 'return: success' && return 0
	
	_messageError 'FAIL: undefined failure'
	_stop 1
}

_reset_me_io() {
	export in_me_a_path=
	export in_me_b_path=
	export out_me_a_path=
	export out_me_b_path=
}

