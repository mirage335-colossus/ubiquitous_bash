# recoll

_test_recoll() {
	_getDep recoll
	
	_getDep recollindex
	_getDep recollq
	_getDep xadump
}





_set_recoll() {
	_messagePlain_nominal 'init: _set_recoll'
	_set_search "$@"
	
	# DANGER: Consistent directory naming.
	# Force creation of 'project.afs' .
	export afs_nofs='false'
	export ubAbstractFS_enable_projectafs_dir='true'
	
	_messagePlain_nominal "set: recoll"
	export current_configDir_search_recoll="$current_configDir_search"/recoll_config
	_messagePlain_probe_var current_configDir_search_recoll
}

_prepare_recoll() {
	_messagePlain_nominal 'init: _prepare_recoll'
	#_set_search "$@"
	_set_recoll "$@"
	
	
	_messagePlain_nominal '_prepare_recoll: dir'
	#"$scriptAbsoluteLocation" _abstractfs _messagePlain_probe_cmd mkdir -p "$current_configDir_search_recoll"
	_messagePlain_probe_cmd mkdir -p "$current_configDir_search_recoll"
}


_recoll_procedure() {
	_messageNormal '_recoll: program'
	cd "$current_projectDir_search"
	#"$scriptAbsoluteLocation" _abstractfs bash
	
	( ! [[ -e "$current_configDir_search_recoll"/recoll.conf ]] || ! [[ -s "$current_configDir_search_recoll"/recoll.conf ]] ) && cat << CZXWXcRMTo8EmM8i4d >> "$current_configDir_search_recoll"/recoll.conf
topdirs = $current_abstractDir_search
skippedPaths = $current_abstractDir_search/w_* $current_abstractDir_search/_local $current_abstractDir_search/core
skippedNames+ = *.kate-swp .embed .pid .recoll .search .sessionid _recoll \
project.afs recoll recoll_config search
CZXWXcRMTo8EmM8i4d
	
	( ! [[ -e "$current_configDir_search_recoll"/mimeview ]] || ! [[ -s "$current_configDir_search_recoll"/mimeview ]] ) && cat << 'CZXWXcRMTo8EmM8i4d' >> "$current_configDir_search_recoll"/mimeview
xallexcepts- = application/pdf application/postscript application/x-dvi
xallexcepts+ = text/html
[view]
text/html = chromium  %f
CZXWXcRMTo8EmM8i4d
	
	
	# https://www.lesbonscomptes.com/recoll/pages/custom.html#_alternating_result_backgrounds
	# https://www.lesbonscomptes.com/recoll/pages/custom.html#_zooming_the_paragraph_font_size
	# must set 'background: #ffffff;' or similar - otherwise results may nearly be undreadable
	_messagePlain_request 'request: Some project specific configuration of '"'recoll'"'may be necessary.'
	_messagePlain_request 'request: topdirs = '"$current_abstractDir_search"''
	_messagePlain_request 'request: skippedPaths = '"$current_abstractDir_search"'/w_*'
	_messagePlain_request 'request: skippedNames+ =
project.afs
recoll_config
.search
.recoll
search
recoll
_recoll
*.kate-swp

.embed.sh
.pid
.sessionid'
	_messagePlain_request 'request: mimeview:
xallexcepts- = application/pdf application/postscript application/x-dvi
xallexcepts+ = text/html text/x-shellscript
[view]
text/x-shellscript = kwrite
text/html = chromium %f'
	_messagePlain_request 'request: <table class="respar" style="background: #ffffff;">'
	"$scriptAbsoluteLocation" _abstractfs recoll -c "$current_configDir_search_recoll"
}
_recoll() {
	_messageNormal 'Begin: _recoll'
	_prepare_search
	_prepare_recoll
	
	_recoll_procedure "$@"
	
	_messageNormal 'End: _recoll'
}

