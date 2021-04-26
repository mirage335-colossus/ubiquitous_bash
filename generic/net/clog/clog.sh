#clog


_clog_interface() {
	# Upstream 'wondershaper' version beyond that from Debian (ie. 'stable') 10 .
	#./wondershaper -a "$1" -u 10000 -d 10000
	
	# Debian (ie. 'stable') 10 .
	#wondershaper [ interface ] [ downlink ] [ uplink ]
	
	sudo -n tc qdisc add dev "$1" root tbf rate 10mbit burst 256kbit latency 133ms
}

# ATTENTION: Override with 'core.sh' , 'netvars.sh' , or similar .
# ATTENTION: Ideally should attempt to 'clog' all 'external' (ie. 'WiFi' or 'Ethernet') interfaces to some low value like 10Mbits/s or 2Mbits/s , to avoid unexpected bandwidth exhaustion or costs.
# List interfaces with ' sudo -n ip addr show ' .
# https://github.com/magnific0/wondershaper
# https://netbeez.net/blog/how-to-use-the-linux-traffic-control/
_clog() {
	true
	
	_clog_interface eth0
	_clog_interface eth1
	_clog_interface eth2
	_clog_interface eth3
	
	_clog_interface enp0s0
	_clog_interface enp1s0
	_clog_interface enp2s0
	_clog_interface enp3s0
}

_clog_crontab() {
	_mustGetSudo
	echo '@reboot '"$scriptAbsoluteLocation"' _clog' | sudo -n crontab -
}


_test_clog() {
	_getDep tc
	_getDep wondershaper
}
