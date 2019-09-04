# ATTENTION: Syntax highlighted documentation. Description of typical [Input]-[Process]-[Output] (IPO) .



# INPUT - CAUTOSSH
_INPUT_COMMENT() {

"$custom_netName"
"$custom_user"

"$scriptLib"/"$custom_cautossh_dirname"
/cautossh
/_config/_config/
	netvars.sh			# OPTIONAL reference, MANDATORY compile !
/_local/
	/ssh/
		/entity/		# OPTIONAL !
			id_rsa.pub	# OPTIONAL !
		id_rsa.pub
		ops.sh
		known_hosts		# Offending entries removed. OPTIONAL !
		...
...

}

# OUTPUT - CAUTOSSH
_OUTPUT_COMMENT() {

"$globalVirtFS"/home/"$custom_user"/core/"$custom_cautossh_dirname"
...

"$scriptLocal"/_custom/crontab

}




