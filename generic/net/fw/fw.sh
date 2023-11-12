

_dns() {
    _messagePlain_nominal '_dns: ip'
    _writeFW_ip-googleDNS-port
    _writeFW_ip-cloudfareDNS-port
    
    _messagePlain_nominal '_dns: resolv: google'
    _ip-googleDNS | sed -e 's/^/nameserver /g' | sudo -n tee /etc/resolv.conf > /dev/null
}


_ufw_check_portALLOW_warn() {
	! ufw status verbose | grep -F ''"$1"'  ' | grep -i 'ALLOW IN' > /dev/null 2>&1 && _messagePlain_warn 'warn: missing: default: ''ufw allow '"$1"''
	! ufw show added | grep -xF 'ufw allow '"$1"'' > /dev/null 2>&1 && _messagePlain_warn 'warn: missing: default: ''ufw allow '"$1"''
	[[ "$?" == '0' ]] && return 1
}
_ufw_check_portALLOW_bad() {
	! ufw status verbose | grep -F ''"$1"'  ' | grep -i 'ALLOW IN' > /dev/null 2>&1 && _messagePlain_bad 'bad: missing: ''ufw allow '"$1"''
	! ufw show added | grep -xF 'ufw allow '"$1"'' > /dev/null 2>&1 && _messagePlain_bad 'bad: missing: ''ufw allow '"$1"''
	[[ "$?" == '0' ]] && return 1
}
_ufw_portEnable() {
	_messagePlain_nominal '_ufw_portEnable: '"$1"
	_ufw_check_portALLOW_warn "$1"
	ufw allow "$1"
	if ! _ufw_check_portALLOW_bad "$1"
	then
		_messagePlain_good 'enable (apparently): ufw: '"$1"
		return 0
	else
		_messagePlain_request 'request: ufw allow '"$1"
		return 1
	fi
}

_ufw_check_portDENY_warn() {
	! ufw status verbose | grep -F ''"$1"'  ' | grep -i 'DENY IN' > /dev/null 2>&1 && _messagePlain_warn 'warn: missing: default: ''ufw deny '"$1"''
	! ufw show added | grep -xF 'ufw deny '"$1"'' > /dev/null 2>&1 && _messagePlain_warn 'warn: missing: default: ''ufw deny '"$1"''
	[[ "$?" == '0' ]] && return 1
}
_ufw_check_portDENY_bad() {
	! ufw status verbose | grep -F ''"$1"'  ' | grep -i 'DENY IN' > /dev/null 2>&1 && _messagePlain_bad 'bad: missing: ''ufw deny '"$1"''
	! ufw show added | grep -xF 'ufw deny '"$1"'' > /dev/null 2>&1 && _messagePlain_bad 'bad: missing: ''ufw deny '"$1"''
	[[ "$?" == '0' ]] && return 1
}
_ufw_portDisable() {
	_messagePlain_nominal '_ufw_portDisable: '"$1"
	_ufw_check_portDENY_warn "$1"
	ufw deny "$1"
	if ! _ufw_check_portDENY_bad "$1"
	then
		_messagePlain_good 'disable (apparently): ufw: '"$1"
		return 0
	else
		_messagePlain_request 'request: ufw deny '"$1"
		return 1
	fi
}

_cfgFW_procedure() {
	if [[ $(id -u) != 0 ]]
	then
		echo "This must be run as root!"
		exit 1
		exit
	fi
	
	
	_messagePlain_nominal '_cfgFW: '' ufw'
	
	if ! type -p ufw > /dev/null 2>&1
	then
		_messagePlain_bad 'fail: missing: ufw'
		_messagePlain_request 'request: install: ufw'
		return 1
	fi
	
	echo '-'
	ufw show added
	echo '--'
	ufw status verbose
	echo '-'
	
	# STRONGLY DISCOURAGED - 'ufw --force reset' .
	
	# DHCP, DNS, SSH, HTTPS .
	ufw allow 67
	ufw allow 68
	ufw allow 53
    if [[ "$ub_cfgFW" == "desktop" ]] || [[ "$ub_cfgFW" == "terminal" ]]
    then
        true
    else
        ufw allow 22
	    ufw allow 443
    fi

	if [[ "$ub_cfgFW" == "desktop" ]] || [[ "$ub_cfgFW" == "terminal" ]]
    then
        ufw default deny incoming
    else
        # Still disabled, but later.
        #ufw default deny incoming
        true
    fi
    if [[ "$ub_cfgFW" == "terminal" ]]
    then
        ufw default deny outgoing
    else
        ufw default allow outgoing
    fi

	echo y | ufw --force enable
	
    if [[ "$ub_cfgFW" == "desktop" ]] || [[ "$ub_cfgFW" == "terminal" ]]
    then
        _ufw_portDisable 67
        _ufw_portDisable 68
        _ufw_portDisable 53
        _ufw_portDisable 22
        #_ufw_portEnable 80
        _ufw_portDisable 443
        #_ufw_portEnable 9001
        #_ufw_portEnable 9030
        
        # TODO: Allow typical offset ports/ranges.
        _ufw_portDisable 8443
        ufw deny 10001:49150/tcp
        ufw deny 10001:49150/udp
    else
	ufw allow 22/tcp
	ufw allow out from any to any port 22 proto tcp
	ufw allow 53/tcp
	ufw allow out from any to any port 53 proto tcp
	
	ufw allow out from any to any port 80 proto tcp
	ufw allow out from any to any port 443 proto tcp
	
	
        _ufw_portEnable 67
        _ufw_portEnable 68
        _ufw_portEnable 53
        _ufw_portEnable 22
        #_ufw_portEnable 80
        _ufw_portEnable 443
        #_ufw_portEnable 9001
        #_ufw_portEnable 9030
        
        # TODO: Allow typical offset ports/ranges.
        _ufw_portEnable 8443
        ufw allow 10001:49150/tcp
        ufw deny 10001:49150/udp
    fi
	
	
	# Deny typical insecure service ports.
	# Tor
	_ufw_portDisable 9050
	
	# Tor Privoxy
	_ufw_portDisable 8118
	
	# i2p
	_ufw_portDisable 4444
	_ufw_portDisable 4445
	
	# kconnectd
	_ufw_portDisable 1716
	
	# pulseaudio
	_ufw_portDisable 4713
	
	# HTTPD Default Installation
	_ufw_portDisable 80
	
	
    

	sudo -n apt-get remove -y avahi-daemon
	sudo -n apt-get remove -y avahi-utils
	sudo -n apt-get remove -y ipp-usb

	sudo -n apt-get remove -y kdeconnect


	# avahi/mdns/etc
	# CAUTION: Due to use of random high number port, avahi-daemon should be completely removed.
	# https://github.com/lathiat/avahi/issues/254
	# apt-get -y remove avahi-daemon
	pgrep avahi > /dev/null 2>&1 && _messagePlain_bad 'bad: detected: avahi' && _messagePlain_request 'request: remove: avahi'
	_ufw_portDisable 5353
	
	# ntp
	_ufw_portDisable 123
	
	# netbios
	_ufw_portDisable 137
	_ufw_portDisable 138
	_ufw_portDisable 139
	
	# Microsoft-DS (Active Directory, Windows Shares, SMB)
	_ufw_portDisable 445
	
	
	# SMTP
	_ufw_portDisable 25
	_ufw_portDisable 465
	_ufw_portDisable 587
	_ufw_portDisable 3535
	
	# IPP/CUPS
	_ufw_portDisable 631
	
	# webmin
	_ufw_portDisable 10000
	
	
	
	# Deny ports typically not used for intentional services.
	ufw deny 2:1023/tcp
	ufw deny 2:1023/udp
	ufw deny 1024:10000/tcp
	ufw deny 1024:10000/udp
	ufw deny 49152:65535/tcp
	ufw deny 49152:65535/udp
	
	
	! ufw status verbose | grep '^Default' | grep -F 'deny (incoming)' > /dev/null 2>&1 && _messagePlain_warn 'warn: missing: default: ''ufw default deny incoming'
	ufw default deny incoming
	if ! ufw status verbose | grep '^Default' | grep -F 'deny (incoming)' > /dev/null 2>&1
	then
		_messagePlain_bad 'bad: missing: default: ''ufw default deny incoming'
	else
		_messagePlain_good 'deny (apparently): ufw: ''incoming'
	fi
	
	# CAUTION: Virtual Machines of various types - especially Xen, Docker - have been known to bypass IPTables and UFW firewall rules, either by adding new rules, or through networking topologies which bypass such rules.
	# WARNING: 'If you are running Docker, by default Docker directly manipulates iptables. Any UFW rules that you specify do not apply to Docker containers.'
	# https://www.linode.com/docs/security/firewalls/configure-firewall-with-ufw/
	# https://www.techrepublic.com/article/how-to-fix-the-docker-and-ufw-security-flaw/
	# https://stackoverflow.com/questions/38592003/why-does-using-docker-opts-iptables-false-break-the-dns-discovery-for-docker/38593533
	# https://serverfault.com/questions/357268/ufw-portforwarding-to-virtualbox-guest
	# https://mike632t.wordpress.com/2015/04/06/configure-ufw-to-work-with-bridged-network-interfaces-using-taptun/
	# https://docs.docker.com/network/none/
	#ufw allow out dns
	#ufw allow ssh
	#ufw allow https
	#ufw default deny outgoing
	#ufw default deny incoming
	
	ufw status verbose
	
	return 0
}

_cfgFW-desktop() {
    _messageNormal 'init: _cfgFW-desktop'

    export ub_cfgFW="desktop"
    sudo -n --preserve-env=ub_cfgFW "$scriptAbsoluteLocation" _cfgFW_procedure "$@"
}
_cfgFW-limited() {
    _messageNormal 'init: _cfgFW-limited'

    export ub_cfgFW="desktop"
    sudo -n --preserve-env=ub_cfgFW "$scriptAbsoluteLocation" _cfgFW_procedure "$@"

    _writeFW_ip-DUBIOUS
    _writeFW_ip-DUBIOUS-more

    _messageNormal '_cfgFW-terminal: deny'
    _messagePlain_probe 'probe: ufw deny to   DUBIOUS'
    sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw deny out from any to < <(cat /ip-DUBIOUS.txt | grep -v '^#')

    _messageNormal '_cfgFW-terminal: status'
    #sudo -n ufw status verbose
    sudo -n ufw reload
}

_cfgFW-terminal_prog() {
    #_messageNormal 'init: _cfgFW-terminal_prog'
    true
}
# https://serverfault.com/questions/907607/slow-rules-inserting-in-ufw
#  Possibly might be less reliable.
#  DANGER: Syntax may be different for 'output' instead of 'input' .
_cfgFW-terminal() {
    _messageNormal 'init: _cfgFW-terminal'
    export ub_cfgFW="terminal"
    
    #_start
    _writeFW_ip-github-port
    #_writeFW_ip-google-port
    #_writeFW_ip-misc-port
    _writeFW_ip-googleDNS-port
    _writeFW_ip-cloudfareDNS-port
    #_writeFW_ip-DUBIOUS
    #_writeFW_ip-DUBIOUS-more

    sudo -n --preserve-env=ub_cfgFW "$scriptAbsoluteLocation" _cfgFW_procedure "$@"

    _messageNormal '_cfgFW-terminal: _cfgFW-github'
    sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-github-port.txt | grep -v '^#')

    _messageNormal '_cfgFW-terminal: allow'
    #_messagePlain_probe 'probe: ufw allow to   Google'
    #sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-google-port.txt | grep -v '^#')
    #_messagePlain_probe 'probe: ufw allow to   misc'
    #sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-misc-port.txt | grep -v '^#')

    _messagePlain_probe 'probe: ufw allow to   DNS'
    sudo -n xargs -r -L 1 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-googleDNS-port.txt | grep -v '^#')
    sudo -n xargs -r -L 1 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-cloudfareDNS-port.txt | grep -v '^#')

    _messageNormal '_cfgFW-terminal: _dns'
    _dns "$@"

    _cfgFW-terminal_prog "$@"

    _messageNormal '_cfgFW-terminal: status'
    sudo -n ufw status verbose
    sudo -n ufw reload

    #_stop
}



_cfgFW-misc_prog() {
    #_messageNormal 'init: _cfgFW-terminal_prog'
    true
}
_cfgFW-misc() {
    _messageNormal 'init: _cfgFW-misc'
    export ub_cfgFW="terminal"
    
    #_start
    _writeFW_ip-github-port
    _writeFW_ip-google-port
    _writeFW_ip-misc-port
    _writeFW_ip-googleDNS-port
    _writeFW_ip-cloudfareDNS-port
    #_writeFW_ip-DUBIOUS
    #_writeFW_ip-DUBIOUS-more

    sudo -n --preserve-env=ub_cfgFW "$scriptAbsoluteLocation" _cfgFW_procedure "$@"

    _messageNormal '_cfgFW-misc: _cfgFW-github'
    sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-github-port.txt | grep -v '^#')

    _messageNormal '_cfgFW-misc: allow'
    _messagePlain_probe 'probe: ufw allow to   Google'
    sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-google-port.txt | grep -v '^#')
    _messagePlain_probe 'probe: ufw allow to   misc'
    sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-misc-port.txt | grep -v '^#')

    _messagePlain_probe 'probe: ufw allow to   DNS'
    sudo -n xargs -r -L 1 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-googleDNS-port.txt | grep -v '^#')
    sudo -n xargs -r -L 1 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw allow out from any to < <(cat /ip-cloudfareDNS-port.txt | grep -v '^#')

    _messageNormal '_cfgFW-misc: _dns'
    _dns "$@"

    _cfgFW-misc_prog "$@"

    _messageNormal '_cfgFW-misc: status'
    sudo -n ufw status verbose
    sudo -n ufw reload

    #_stop
}

# Think: CI build . May need inbound SSH, but otherwise *very* limited functionality.
_cfgFW-ephemeral() {
    _messageNormal 'init: _cfgFW-ephemeral'

    export ub_cfgFW="ephemeral"
    sudo -n --preserve-env=ub_cfgFW "$scriptAbsoluteLocation" _cfgFW_procedure "$@"

    _writeFW_ip-DUBIOUS
    _writeFW_ip-DUBIOUS-more

    _messageNormal '_cfgFW-terminal: deny'
    _messagePlain_probe 'probe: ufw deny to   DUBIOUS'
    sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw deny out from any to < <(cat /ip-DUBIOUS.txt | grep -v '^#')

    _messageNormal '_cfgFW-terminal: deny'
    _messagePlain_probe 'probe: ufw deny from   DUBIOUS'
    sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw deny in to any from < <(cat /ip-DUBIOUS-more.txt | grep -v '^#')
    ##sudo -n xargs -r -L 1 -P 10 "$scriptAbsoluteLocation" _messagePlain_probe_cmd ufw deny in to any from < <(cat /ip-DUBIOUS.txt | grep -v '^#')

    _messageNormal '_cfgFW-terminal: status'
    #sudo -n ufw status verbose
    sudo -n ufw reload
}

_cfgFW-revert-ephemeral() {
	
	_ufw_delete_denyLow() {
		#local currentLine
		for currentLine in $(sudo -n ufw status numbered | grep '2:1023' | sed 's/.*\[//' | sed 's/].*//')
		do
			sudo -n ufw --force delete "$currentLine" 2>/dev/null
			sleep 3
		done
	}
	_ufw_delete_denyLow
	sleep 7
	_ufw_delete_denyLow
	sleep 7
	_ufw_delete_denyLow
	sleep 7
	_ufw_delete_denyLow
	
	sudo -n ufw delete deny 22
	
	sudo -n ufw allow 22/tcp
	sudo -n ufw allow out from any to any port 22 proto tcp
	sudo -n ufw allow 53/tcp
	sudo -n ufw allow out from any to any port 53 proto tcp
	
	sudo -n ufw allow out from any to any port 80 proto tcp
	sudo -n ufw allow out from any to any port 443 proto tcp
	
	sudo -n ufw deny 2:1023/tcp
	sudo -n ufw deny 2:1023/udp
}

_writeFW_ip-github-port() {
    [[ ! $(sudo -n wc -c "$1"/ip-github-port.txt 2>/dev/null | cut -f1 -d\  | tr -dc '0-9') -gt 2 ]] && "$scriptAbsoluteLocation" _ip-github | sed 's/$/ port 22,443 proto tcp/g' | sudo -n tee "$1"/ip-github-port.txt > /dev/null
}
_writeFW_ip-google-port() {
    [[ ! $(sudo -n wc -c "$1"/ip-google-port.txt 2>/dev/null | cut -f1 -d\  | tr -dc '0-9') -gt 2 ]] && "$scriptAbsoluteLocation" _ip-google | sed 's/$/ port 443/g' | sudo -n tee "$1"/ip-google-port.txt > /dev/null
}
_writeFW_ip-misc-port() {
    [[ ! $(sudo -n wc -c "$1"/ip-misc-port.txt 2>/dev/null | cut -f1 -d\  | tr -dc '0-9') -gt 2 ]] && "$scriptAbsoluteLocation" _ip-misc | sed 's/$/ port 443/g' | sudo -n tee "$1"/ip-misc-port.txt > /dev/null
}
_writeFW_ip-googleDNS-port() {
    [[ ! $(sudo -n wc -c "$1"/ip-googleDNS-port.txt 2>/dev/null | cut -f1 -d\  | tr -dc '0-9') -gt 2 ]] && "$scriptAbsoluteLocation" _ip-googleDNS | sed 's/$/ port 53/g' | sudo -n tee "$1"/ip-googleDNS-port.txt > /dev/null
}
_writeFW_ip-cloudfareDNS-port() {
    [[ ! $(sudo -n wc -c "$1"/ip-cloudfareDNS-port.txt 2>/dev/null | cut -f1 -d\  | tr -dc '0-9') -gt 2 ]] && "$scriptAbsoluteLocation" _ip-cloudfareDNS | sed 's/$/ port 53/g' | sudo -n tee "$1"/ip-cloudfareDNS-port.txt > /dev/null
}
_writeFW_ip-DUBIOUS() {
    [[ ! $(sudo -n wc -c "$1"/ip-DUBIOUS.txt 2>/dev/null | cut -f1 -d\  | tr -dc '0-9') -gt 2 ]] && "$scriptAbsoluteLocation" _ip-DUBIOUS | sudo -n tee "$1"/ip-DUBIOUS.txt > /dev/null
}
_writeFW_ip-DUBIOUS-more() {
    [[ ! $(sudo -n wc -c "$1"/ip-DUBIOUS-more.txt 2>/dev/null | cut -f1 -d\  | tr -dc '0-9') -gt 2 ]] && "$scriptAbsoluteLocation" _ip-DUBIOUS-more | sudo -n tee "$1"/ip-DUBIOUS-more.txt > /dev/null
}



_setup_fw() {
    _test_fw
}

_test_fw() {
    # Not incurring as a dependency... for now.
    return 0
    
    _if_cygwin && return 0

    _getDep ufw
    #_getDep gufw

    _getDep xargs
}
