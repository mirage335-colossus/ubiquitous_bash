_relink_metaengine_coordinates() {
	_messagePlain_nominal 'init: _relink_metaengine_coordinates'
	
	mkdir -p "$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x"
	_relink "$in_me_a_path" "$metaDir"/ai
	
	mkdir -p "$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x"
	_relink "$in_me_b_path" "$metaDir"/bi
	
	mkdir -p "$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x"
	_relink "$metaDir"/ao "$out_me_a_path"
	
	mkdir -p "$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x"
	_relink "$metaDir"/bo "$out_me_b_path"
	
	_messagePlain_good 'return: complete'
	return 0
}

_rmlink_metaengine_coordinates() {
	#_rmlink "$metaDir"/ai > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_a_z"/"$in_me_a_x" > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_a_z" > /dev/null 2>&1
	
	#_rmlink "$metaDir"/bi > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_b_z"/"$in_me_b_x" > /dev/null 2>&1
	#rmdir "$metaReg"/grid/"$in_me_b_z" > /dev/null 2>&1
	
	_rmlink "$out_me_a_path" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_a_z"/"$out_me_a_x" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_a_z" > /dev/null 2>&1
	
	_rmlink "$out_me_b_path" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_b_z"/"$out_me_b_x" > /dev/null 2>&1
	rmdir "$metaReg"/grid/"$out_me_b_z" > /dev/null 2>&1
}



_relink_metaengine_name() {
	_messagePlain_nominal 'init: _relink_metaengine_name'
	
	#No known production relevance.
	[[ -e "$metaReg"/name/"$metaID" ]] _messageError 'FAIL: unexpected safety' && _stop 1
	
	mkdir -p "$metaReg"/name/"$in_me_a_name"
	_relink "$in_me_a_path" "$metaDir"/ai
	mkdir -p "$metaReg"/name/"$in_me_b_name"
	_relink "$in_me_b_path" "$metaDir"/bi
	
	mkdir -p "$metaReg"/name/"$out_me_a_name"
	_relink "$metaDir"/ao "$out_me_a_path"
	mkdir -p "$metaReg"/name/"$out_me_b_name"
	_relink "$metaDir"/bo "$out_me_b_path"
	
	_messagePlain_good 'return: complete'
	return 0
}

_rmlink_metaengine_name() {
	
	#_rmlink "$metaDir"/ai > /dev/null 2>&1
	#rmdir "$metaReg"/name/"$in_me_a_name" > /dev/null 2>&1
	#_rmlink "$metaDir"/bi > /dev/null 2>&1
	#rmdir "$metaReg"/name/"$in_me_a_name" > /dev/null 2>&1
	
	_rmlink "$out_me_a_path" > /dev/null 2>&1
	rmdir "$metaReg"/name/"$out_me_a_name" > /dev/null 2>&1
	_rmlink "$out_me_b_path" > /dev/null 2>&1
	rmdir "$metaReg"/name/"$out_me_b_name" > /dev/null 2>&1
}



_relink_metaengine() {
	_messagePlain_nominal 'init: _relink_metaengine'
	
	! _check_me_coordinates && ! _check_me_name && _messageError 'FAIL: invalid IO coordinates and names' && _stop 1
	
	_check_me_name && _messagePlain_good 'valid: name' && _prepare_metaengine_name && _relink_metaengine_name && && _messagePlain_good 'return: success' return 0
	
	_check_me_coordinates && _messagePlain_good 'valid: coordinates' && _prepare_metaengine_coordinates && _relink_metaengine_coordinates && && _messagePlain_good 'return: success' return 0
	
	_messagePlain_bad 'stop: undefined failure'
	_stop 1
}


_prepare_metaengine_coordinates() {
	mkdir -p "$metaReg"/grid
	mkdir -p "$metaReg"/x
	mkdir -p "$metaReg"/y
	mkdir -p "$metaReg"/z
}

_prepare_metaengine_name() {
	mkdir -p "$metaReg"/name
}

_prepare_metaengine() {
	mkdir -p "$metaTmp"
	
	[[ "$metaDir_tmp" != "" ]] && mkdir -p "$metaDir_tmp"
	[[ "$metaDir" != "" ]] && mkdir -p "$metaDir"
	
	mkdir -p "$metaDir"/ao
	mkdir -p "$metaDir"/bo
}

_start_metaengine_host() {
	[[ -e "$engineTmp" ]] && _messageError 'FAIL: safety: meta conflicts engine' && _stop 1
	
	_messageNormal 'init: _start_metaengine_host'
	
	_start
	
	mkdir -p "$metaTmp"
	
	_relink "$safeTmp"/.pid "$metaTmp"/.pid
}

_start_metaengine() {
	[[ -e "$engineTmp" ]] && _messageError 'FAIL: safety: meta conflicts engine' && _stop 1
	
	_messageNormal 'init: _start_metaengine_host'
	
	_start
	
	_set_me
	_prepare_metaengine
	_relink_metaengine
	
	_report_metaengine
	
	echo $$ > "$metaDir"/.pid
	echo "$sessionid" > "$metaDir"/.sessionid
	_embed_here > "$metaDir"/.embed.sh
	chmod 755 "$metaDir"/.embed.sh
}

_ready_me_in() {
	! [[ -e "$in_me_a_path" ]] && _messagePlain_warn 'missing: in_me_a_path= '"$in_me_a_path" && return 1
	! [[ -e "$in_me_b_path" ]] && _messagePlain_warn 'missing: in_me_b_path= '"$in_me_b_path" && return 1
	
	_messagePlain_good 'ready: in path'
	return 0
}

# ATTENTION: Overload with "core.sh" if appropriate.
_wait_metaengine() {
	_messagePlain_nominal 'init: _wait_metaengine'
	
	! _ready_me_in && sleep 0.1
	! _ready_me_in && sleep 0.3
	! _ready_me_in && sleep 1
	! _ready_me_in && sleep 3
	! _ready_me_in && sleep 10
	! _ready_me_in && sleep 10
	! _ready_me_in && sleep 10
	! _ready_me_in && sleep 20
	! _ready_me_in && sleep 20
	! _ready_me_in && sleep 20
	
	#while ! _ready_me_in
	#do
	#	sleep 0.1
	#done
}
