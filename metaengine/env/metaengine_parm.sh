
_assign_me_objname() {
	export metaObjName="$1"
	_messagePlain_nominal 'set: metaObjName= '"$metaObjName"
}

_set_me_type_tmp() {
	export metaType=""
	_messagePlain_nominal 'set: metaType= (tmp)'"$metaType"
}

_set_me_type_base() {
	export metaType="base"
	_messagePlain_nominal 'set: metaType= '"$metaType"
}

_reset_me_type() {
	export metaType=
}


_cycle_me_name() {
	export in_me_a_name="$out_me_a_name"
	export in_me_b_name="$out_me_b_name"
	_set_me_rand_out
	
	_messagePlain_nominal 'cycle: in_me_a_name= (out_me_a_name)'"$in_me_a_name"' ''cycle: in_me_b_name= (out_me_b_name)'"$in_me_b_name"
	_messagePlain_probe 'rand: out_me_a_name= '"$out_me_a_name"' ''rand: out_me_b_name= '"$out_me_b_name"
}
_cycle_me() {
	_cycle_me_name
}


_assign_me_name_ai() {
	export in_me_a_name="$1"
}

_assign_me_name_bi() {
	export in_me_b_name="$1"
}

_assign_me_name_ao() {
	export out_me_a_name="$1"
}

_assign_me_name_bo() {
	export out_me_b_name="$1"
}

_assign_me_name_out() {
	_assign_me_name_ao "$1"
	_assign_me_name_bo "$1"
}



# WARNING: Coordinate assignment by centroid for 3D pipeline representation ONLY. Detailed spatial data to be completely represented in binary formatted named buffers.
#_assign_me_coordinates aiX aiY aiZ biX biY biZ aoX aoY aoZ boX boY boZ
_assign_me_coordinates() {
	_assign_me_coordinates_ai "$1" "$2" "$3"
		shift ; shift ; shift
	_assign_me_coordinates_bi "$1" "$2" "$3"
		shift ; shift ; shift
	_assign_me_coordinates_ao "$1" "$2" "$3"
		shift ; shift ; shift
	_assign_me_coordinates_bo "$1" "$2" "$3"
}

#_assign_me... X Y Z
_assign_me_coordinates_ai() {
	export in_me_a_x="$1"
		shift
	export in_me_a_y="$1"
		shift
	export in_me_a_z="$1"
}

#_assign_me... X Y Z
_assign_me_coordinates_bi() {
	export in_me_b_x="$1"
		shift
	export in_me_b_y="$1"
		shift
	export in_me_b_z="$1"
}

#_assign_me... X Y Z
_assign_me_coordinates_ao() {
	export out_me_a_x="$1"
		shift
	export out_me_a_y="$1"
		shift
	export out_me_a_z="$1"
}

#_assign_me... X Y Z
_assign_me_coordinates_bo() {
	export out_me_b_x="$1"
		shift
	export out_me_b_y="$1"
		shift
	export out_me_b_z="$1"
}

# No known production use.
_set_me_rand_in() {
	_messagePlain_nominal 'init: _set_me_rand_in'
	local rand_uid
	rand_uid=$(_uid)
	export in_me_a_name="$rand_uid"
	export in_me_b_name="$rand_uid"
}

_set_me_rand_out() {
	_messagePlain_nominal 'init: _set_me_rand_out'
	local rand_uid
	rand_uid=$(_uid)
	export out_me_a_name="$rand_uid"
	export out_me_b_name="$rand_uid"
}

# No known production use.
_set_me_rand() {
	_messagePlain_nominal 'init: _set_me_rand'
	_set_me_rand_in
	_set_me_rand_out
}

_set_me_null_in() {
	_messagePlain_nominal 'init: _set_me_null_in'
	_assign_me_name_ai null
	_assign_me_name_bi null
}

_set_me_null_out() {
	_messagePlain_nominal 'init: _set_me_null_out'
	_assign_me_name_ao null
	_assign_me_name_bo null
}

_set_me_null() {
	_messagePlain_nominal 'init: _set_me_null'
	_set_me_null_in
	_set_me_null_out
}
