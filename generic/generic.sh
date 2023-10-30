

_binToHex() {
	xxd -p | tr -d '\n'
}

_hexToBin() {
	xxd -r -p
}



