_me_divert() {
	_buffer_me_processor_divert "$@"
}

#Registers an output to a diversion directory for processors which may support more than two inputs. Expected to be used with special processors creating their own unique registrations (ie. _reg/special).
_buffer_me_processor_divert() {
	mkdir -p "$metaReg"/"$1"/divert
	mkdir -p "$metaReg"/"$2"/divert
	
	
	_relink "$metaDir"/ao "$metaReg"/"$1"/divert/"$metaID"
	_relink "$metaDir"/bo "$metaReg"/"$2"/divert/"$metaID"
}
