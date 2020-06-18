

_set_java_arbitrary() {
	export ubJava="$1""$ubJavac"
}
_check_java_arbitrary() {
	type "$ubJava" > /dev/null 2>&1
}


_java_openjdkANY_check_filter() {
	head -n 1 | grep -i 'OpenJDK'
}
_java_openjdk11_check_filter() {
	_java_openjdkANY_check_filter | grep 'version.\{0,4\}11'
}
_java_openjdk11_debian_check() {
	local current_java_path='/usr/lib/jvm/java-11-openjdk-amd64/bin/java'
	
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	#! "$current_java_path" -version 2>&1 | _java_openjdk11_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdk11_debian() {
	if _java_openjdk11_debian_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdk11_usrbin_check() {
	local current_java_path='/usr/bin/java'
	
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	! "$current_java_path" -version 2>&1 | _java_openjdk11_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdk11_usrbin() {
	if _java_openjdk11_usrbin_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdk11_PATH_check() {
	local current_java_path=$(type -p java 2>/dev/null)
	
	[[ ! -e "$current_java_path" ]] && return 1
	[[ "$current_java_path" == "" ]] && return 1
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	! "$current_java_path" -version 2>&1 | _java_openjdk11_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdk11_PATH() {
	if _java_openjdk11_PATH_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdk11() {
	export ubJavac=""
	_java_openjdk11_debian "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk11_usrbin "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk11_PATH "$@"
	[[ "$?" == '0' ]] && return 0
}
_javac_openjdk11() {
	export ubJavac="c"
	_java_openjdk11_debian "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk11_usrbin "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk11_PATH "$@"
	[[ "$?" == '0' ]] && return 0
}
_set_java_openjdk11() {
	export ubJava_setOnly='true'
	_java_openjdk11
	export ubJava_setOnly='false'
	_check_java_arbitrary
}
_check_java_openjdk11() {
	_java_openjdk11_debian_check && return 0
	_java_openjdk11_usrbin_check && return 0
	_java_openjdk11_PATH_check && return 0
	return 1
}




# WARNING: Untested.
_java_openjdk8_check_filter() {
	_java_openjdkANY_check_filter | grep 'version.\{0,5\}8'
}
_java_openjdk8_debian_check() {
	local current_java_path='/usr/lib/jvm/java-8-openjdk-amd64/bin/java'
	
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	#! "$current_java_path" -version 2>&1 | _java_openjdk8_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdk8_debian() {
	if _java_openjdk8_debian_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdk8_usrbin_check() {
	local current_java_path='/usr/bin/java'
	
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	! "$current_java_path" -version 2>&1 | _java_openjdk8_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdk8_usrbin() {
	if _java_openjdk8_usrbin_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdk8_PATH_check() {
	local current_java_path=$(type -p java 2>/dev/null)
	
	[[ ! -e "$current_java_path" ]] && return 1
	[[ "$current_java_path" == "" ]] && return 1
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	! "$current_java_path" -version 2>&1 | _java_openjdk8_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdk8_PATH() {
	if _java_openjdk8_PATH_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdk8() {
	export ubJavac=""
	_java_openjdk8_debian "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk8_usrbin "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk8_PATH "$@"
	[[ "$?" == '0' ]] && return 0
}
_javac_openjdk8() {
	export ubJavac="c"
	_java_openjdk8_debian "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk8_usrbin "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk8_PATH "$@"
	[[ "$?" == '0' ]] && return 0
}
_set_java_openjdk8() {
	export ubJava_setOnly='true'
	_java_openjdk8
	export ubJava_setOnly='false'
	_check_java_arbitrary
}
_check_java_openjdk8() {
	_java_openjdk8_debian_check && return 0
	_java_openjdk8_usrbin_check && return 0
	_java_openjdk8_PATH_check && return 0
	return 1
}



_java_openjdkANY_debian() {
	_java_openjdk8_debian "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdk11_debian "$@"
	[[ "$?" == '0' ]] && return 0
}
_java_openjdkANY_usrbin_check() {
	local current_java_path='/usr/bin/java'
	
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	! "$current_java_path" -version 2>&1 | _java_openjdkANY_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdkANY_usrbin() {
	if _java_openjdkANY_usrbin_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdkANY_PATH_check() {
	local current_java_path=$(type -p java 2>/dev/null)
	
	[[ ! -e "$current_java_path" ]] && return 1
	[[ "$current_java_path" == "" ]] && return 1
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	! "$current_java_path" -version 2>&1 | _java_openjdkANY_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_openjdkANY_PATH() {
	if _java_openjdkANY_PATH_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
_java_openjdkANY() {
	export ubJavac=""
	_java_openjdkANY_debian "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdkANY_usrbin "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdkANY_PATH "$@"
	[[ "$?" == '0' ]] && return 0
}
_javac_openjdkANY() {
	export ubJavac="c"
	_java_openjdkANY_debian "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdkANY_usrbin "$@"
	[[ "$?" == '0' ]] && return 0
	_java_openjdkANY_PATH "$@"
	[[ "$?" == '0' ]] && return 0
}
_java_openjdk() {
	_java_openjdkANY "$@"
}
_set_java_openjdkANY() {
	export ubJava_setOnly='true'
	_java_openjdkANY
	export ubJava_setOnly='false'
	_check_java_arbitrary
}
_set_java_openjdk() {
	export ubJava_setOnly='true'
	_java_openjdk
	export ubJava_setOnly='false'
	_check_java_arbitrary
}
_check_java_openjdkANY() {
	_check_java_openjdk11 && return 0
	_check_java_openjdk8 && return 0
	_java_openjdkANY_usrbin_check && return 0
	_java_openjdkANY_PATH_check && return 0
	return 1
}




# DANGER: Oracle Java *strongly* discouraged. Support provided as rough example only.
_java_oraclejdk11_debian_check() {
	local current_java_path='/usr/lib/jvm/java-11-oracle/bin/java'
	
	! type "$current_java_path" > /dev/null 2>&1 && return 1
	
	#! "$current_java_path" -version 2>&1 | _java_oraclejdk11_check_filter > /dev/null 2>&1 && return 1
	
	_set_java_arbitrary "$current_java_path"
	
	return 0
}
_java_oraclejdk11_debian() {
	if _java_oraclejdk11_debian_check
	then
		[[ "$ubJava_setOnly" == 'true' ]] && return 0
		"$ubJava" "$@"
		_stop "$?"
	fi
	return 1
}
# _java_oraclejdk11_usrbin_check() {
# 	local current_java_path='/usr/bin/java'
# 	
# 	! type "$current_java_path" > /dev/null 2>&1 && return 1
# 	
# 	! "$current_java_path" -version 2>&1 | _java_oraclejdk11_check_filter > /dev/null 2>&1 && return 1
# 	
# 	_set_java_arbitrary "$current_java_path"
# 	
# 	return 0
# }
# _java_oraclejdk11_usrbin() {
# 	if _java_oraclejdk11_usrbin_check
# 	then
# 		[[ "$ubJava_setOnly" == 'true' ]] && return 0
# 		"$ubJava" "$@"
# 		_stop "$?"
# 	fi
# 	return 1
# }
# _java_oraclejdk11_PATH_check() {
# 	local current_java_path=$(type -p java 2>/dev/null)
# 	
# 	[[ ! -e "$current_java_path" ]] && return 1
# 	[[ "$current_java_path" == "" ]] && return 1
# 	! type "$current_java_path" > /dev/null 2>&1 && return 1
# 	
# 	! "$current_java_path" -version 2>&1 | _java_oraclejdk11_check_filter > /dev/null 2>&1 && return 1
# 	
# 	_set_java_arbitrary "$current_java_path"
# 	
# 	return 0
# }
# _java_oraclejdk11_PATH() {
# 	if _java_oraclejdk11_PATH_check
# 	then
# 		[[ "$ubJava_setOnly" == 'true' ]] && return 0
# 		"$ubJava" "$@"
# 		_stop "$?"
# 	fi
# 	return 1
# }
_java_oraclejdk11() {
	_java_oraclejdk11_debian "$@"
	[[ "$?" == '0' ]] && return 0
# 	_java_oraclejdk11_usrbin "$@"
# 	[[ "$?" == '0' ]] && return 0
# 	_java_oraclejdk11_PATH "$@"
# 	[[ "$?" == '0' ]] && return 0
}
_set_java_oraclejdk11() {
	export ubJava_setOnly='true'
	_java_oraclejdk11
	export ubJava_setOnly='false'
	_check_java_arbitrary
}
_check_java_oraclejdk11() {
	_java_oraclejdk11_debian_check && return 0
	return 1
}
_java_oraclejdk_ANY() {
	_java_oraclejdk11 "$@"
	[[ "$?" == '0' ]] && return 0
}
_java_oraclejdk() {
	export ubJavac=""
	_java_oraclejdk_ANY "$@"
}
_javac_oraclejdk() {
	export ubJavac="c"
	_java_oraclejdk_ANY "$@"
}
_set_java_oraclejdk_ANY() {
	export ubJava_setOnly='true'
	_java_oraclejdk_ANY
	export ubJava_setOnly='false'
	_check_java_arbitrary
}
_set_java_oraclejdk() {
	export ubJava_setOnly='true'
	_java_oraclejdk
	export ubJava_setOnly='false'
	_check_java_arbitrary
}
_check_java_oraclejdk(){
	_check_java_oraclejdk11
}














# ATTENTION Overload with 'core.sh' or similar ONLY if further specialization is actually required!
_test_java() {
	_wantGetDep java
	
	! _check_java_openjdkANY && echo 'missing: openjdk'
	#! _check_java_openjdk8 && echo 'missing: openjdk8'
	#! _check_java_openjdk11 && echo 'missing: openjdk11'
	
	# DANGER: Oracle Java *strongly* discouraged. Support provided as rough example only.
	#! _check_java_oraclejdk && echo 'missing: oraclejdk'
	#! _check_java_oraclejdk11  && echo 'missing: oraclejdk11'
	
	return 0
}

# ATTENTION Overload with 'core.sh' or similar ONLY if further specialization is actually required!
_set_java() {
	export ubJava_setOnly='true'
	_java
	export ubJava_setOnly='false'
	_check_java_arbitrary
}

# ATTENTION Overload with 'core.sh' or similar ONLY if further specialization is actually required!
_java() {
	_java_openjdk11 "$@"
	_java_openjdk8 "$@"
	_java_openjdkANY "$@"
	
	# DANGER: Oracle Java *strongly* discouraged. Support provided as rough example only.
	#_java_oraclejdk11 "$@"
	#_java_oraclejdk "$@"
}

_javac() {
	_javac_openjdk11 "$@"
	_javac_openjdk8 "$@"
	_javac_openjdkANY "$@"
	
	# DANGER: Oracle Java *strongly* discouraged. Support provided as rough example only.
	#_javac_oraclejdk11 "$@"
	#_javac_oraclejdk "$@"
}

