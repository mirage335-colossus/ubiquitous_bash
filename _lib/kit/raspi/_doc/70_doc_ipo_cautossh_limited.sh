# ATTENTION: Syntax highlighted documentation. Description of typical [Input]-[Process]-[Output] (IPO) .
# DANGER: Adhere to this specification.


# INPUT - CAUTOSSH LIMITED
_INPUT_COMMENT() {

"$custom_netName"
"$custom_user"
"$custom_hostname"

export custom_cautossh_limited_dirname="$custom_netName"-limited
export custom_cautossh_limited_reversePort_all=( $("$custom_cautossh_limited_src_exe" _show_reversePorts '*' 2> /dev/null) )

"$scriptLib"/"$custom_cautossh_limited_dirname"
/cautossh
/_config/_config/
	netvars.sh		# Define at most two 'reversePort' - desired and default . OPTIONAL reference, MANDATORY compile !
/_local/
	/ssh/			# NO IDENTITY FILES !
		ops.sh		# Gateways only.
		known_hosts	# Gateways only. Offending entries removed. OPTIONAL !
	/tor/sshd/		# ONLY one, matching 'reversePort' .
...
/compile.sh			# OPTIONAL !
/_lib/				# OPTIONAL !
/_prog/				# OPTIONAL !

}

# OUTPUT - CAUTOSSH LIMITED
_OUTPUT_COMMENT() {

"$globalVirtFS"/home/"$custom_user"/core/"$custom_cautossh_limited_dirname"
/_local/
	/ssh/
		/entity/		# OPTIONAL !
			id_rsa		# OPTIONAL !
			id_rsa.pub	# OPTIONAL !
		id_rsa
		id_rsa.pub
...

"$scriptLocal"/self
	id_rsa
	id_rsa.pub			# Does NOT grant login to constructed machine.

"$scriptLocal"/_custom/crontab

}

