_report_metaengine() {
	_messagePlain_nominal 'init: _report_metaengine'
	
	[[ ! -e "$metaTmp" ]] && _messagePlain_bad 'missing: metaTmp'
	
	
	[[ "$metaBase" == "" ]] && _messagePlain_warn 'blank: metaBase'
	[[ "$metaObjName" == "" ]] && _messagePlain_warn 'blank: metaObjName'
	
	#[[ "$metaType" == "" ]] && _messagePlain_warn 'blank: metaID'
	
	[[ "$metaID" == "" ]] && _messagePlain_warn 'blank: metaID'
	
	[[ "$metaPath" == "" ]] && _messagePlain_warn 'blank: metaPath'
	
	[[ "$metaDir_tmp" == "" ]] && _messagePlain_warn 'blank: metaDir_tmp'
	[[ "$metaDir_base" == "" ]] && _messagePlain_warn 'blank: metaDir_base'
	[[ "$metaDir" == "" ]] && _messagePlain_warn 'blank: metaDir'
	
	[[ "$metaReg" == "" ]] && _messagePlain_warn 'blank: metaReg'
	
	[[ "$metaConfidence" == "" ]] && _messagePlain_warn 'blank: metaConfidence'
	
	[[ ! -e "$metaBase" ]] && _messagePlain_warn 'missing: metaBase'
	
	[[ ! -e "$metaDir_tmp" ]] && _messagePlain_warn 'missing: metaDir_tmp'
	[[ ! -e "$metaDir_base" ]] && _messagePlain_warn 'missing: metaDir_base'
	[[ ! -e "$metaDir" ]] && _messagePlain_warn 'missing: metaDir'
	
	[[ ! -e "$metaReg" ]] && _messagePlain_warn 'missing: metaReg'
	
	[[ ! -e "$metaDir"/ao ]] && _messagePlain_warn 'missing: "$metaDir"/ao'
	[[ ! -e "$metaDir"/bo ]] && _messagePlain_warn 'missing: "$metaDir"/bo'
	
	[[ ! -e "$in_me_a_path" ]] && _messagePlain_warn 'missing: in_me_a_path'
	[[ ! -e "$in_me_b_path" ]] && _messagePlain_warn 'missing: in_me_b_path'
}

_report_metaengine_relink_in() {
	[[ ! -e "$metaDir"/ai ]] && _messagePlain_warn 'missing: "$metaDir"/ai'
	[[ ! -e "$metaDir"/bi ]] && _messagePlain_warn 'missing: "$metaDir"/bi'
}

_report_metaengine_relink_out() {
	[[ ! -e "$out_me_a_path" ]] && _messagePlain_warn 'missing: out_me_a_path'
	[[ ! -e "$out_me_b_path" ]] && _messagePlain_warn 'missing: out_me_b_path'
}

_message_me_vars() {
	_message_me_set
	_message_me_coordinates
	_message_me_name
}

_message_me_set() {
	_messagePlain_probe '########## SET'
	
	_messageVar metaBase
	_messageVar metaObjName
	echo
	_messageVar metaID
	echo
	_messageVar metaPath
	_messageVar metaDir_tmp
	_messageVar metaDir_base
	_messageVar metaDir
	_messageVar metaReg
	_messageVar metaConfidence
	echo
	_message_me_path
}

_message_me_path() {
	_messagePlain_probe '########## PATH'
	_messageVar in_me_a_path
	_messageVar in_me_b_path
	_messageVar out_me_a_path
	_messageVar out_me_b_path
	echo
}

_message_me_coordinates() {
	_messagePlain_probe '########## IO - COORDINATES'
	_messagePlain_probe '##### ai'
	_messageVar in_me_a_z
	_messageVar in_me_a_x
	_messageVar in_me_a_y
	echo
	_messagePlain_probe '##### bi'
	_messageVar in_me_b_z
	_messageVar in_me_b_x
	_messageVar in_me_b_y
	echo
	_messagePlain_probe '##### ao'
	_messageVar out_me_a_z
	_messageVar out_me_a_x
	_messageVar out_me_a_y
	echo
	_messagePlain_probe '##### bo'
	_messageVar out_me_b_z
	_messageVar out_me_b_x
	_messageVar out_me_b_y
	echo
}

_message_me_name() {
	_messagePlain_probe '########## IO - NAMES'
	_messageVar in_me_a_name
	_messageVar in_me_b_name
	_messageVar out_me_a_name
	_messageVar out_me_b_name
}
