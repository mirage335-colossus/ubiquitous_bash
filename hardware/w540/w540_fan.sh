
_w540_fan_cfg-write() {
	echo "options thinkpad_acpi fan_control=1" | sudo -n tee /etc/modprobe.d/thinkfan.conf
}

_w540_fan_cfg-modprobe() {
	sudo -n modprobe -rv thinkpad_acpi
	sudo -n modprobe -v thinkpad_acpi
}

_w540_fan_cfg() {
	echo watchdog 120 | sudo -n tee /proc/acpi/ibm/fan
}

# cron recommended
#*/1 * * * * sleep 0.1 ; /home/user/.ubcore/ubcore.sh _w540_hardware_cron > /dev/null 2>&1
_w540_hardware_cron() {
	! sudo -n dmidecode -s system-family | grep 'ThinkPad W540' && return 0
	
	_w540_fan
	
	return 0
}

# cron recommended
#*/1 * * * * sleep 0.1 ; /home/user/.ubcore/ubiquitous_bash/ubcore.sh _w540_fan > /dev/null 2>&1
_w540_fan() {
	_w540_fan_cfg
	
	local currentTemp_coretemp0
	read currentTemp_coretemp0 /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input
	
	#[[ "$currentTemp_coretemp0" -lt 48000 ]] && echo level 1 | sudo tee /proc/acpi/ibm/fan && return 0
	#[[ "$currentTemp_coretemp0" -lt 68000 ]] && echo level 1 | sudo tee /proc/acpi/ibm/fan && return 0
	
	[[ "$currentTemp_coretemp0" -lt 68000 ]] && echo level 1 | sudo -n tee /proc/acpi/ibm/fan && return 0
}

_w540_idle() {
	_w540_fan_cfg
	
	while true
	do
		echo powersave | sudo -n tee /sys/devices/system/cpu/cpufreq/*/scaling_governor
		
		echo level 1 | sudo tee /proc/acpi/ibm/fan
		
		sleep 45
	done
}

_w540_normal() {
	echo schedutil | sudo -n tee /sys/devices/system/cpu/cpufreq/*/scaling_governor
}
