_write_bfq() {
	_messagePlain_nominal 'write_bfq: init'
	
	_mustGetSudo
	
	
	_messagePlain_nominal 'write_bfq: write'
	
	sudo -n cat << 'CZXWXcRMTo8EmM8i4d' | sudo tee '/etc/modules-load.d/bfq-'"$ubiquitiousBashIDshort"'.conf' > /dev/null
bfq

CZXWXcRMTo8EmM8i4d


	cat << 'CZXWXcRMTo8EmM8i4d' | sudo tee '/etc/udev/rules.d/60-scheduler-'"$ubiquitiousBashIDshort"'.rules' > /dev/null
ACTION=="add|change", KERNEL=="sd*[!0-9]|sr*", ATTR{queue/scheduler}="bfq"
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="bfq"

CZXWXcRMTo8EmM8i4d

	_messagePlain_good 'write_bfq: success'

}




