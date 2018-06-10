_check_prog() {
	! _typeDep dependency && return 1
	
	return 0
}

_test_prog() {
	_getDep dependency
	
	! _check_prog && echo 'missing: dependency mismatch' && stop 1
	return 0
}
