_testQEMU_x64-raspi() {
	_testQEMU_x64-x64
	_checkDep qemu-arm-static
	_checkDep qemu-armeb-static
}
