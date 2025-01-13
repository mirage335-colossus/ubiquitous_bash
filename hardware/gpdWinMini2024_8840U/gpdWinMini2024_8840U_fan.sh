
# WARNING: May be untested.
# TODO: Detect 'gpd' device, ceasing if not a 'gpd' device.
# TODO: Temperature sensing may be untested.

# ATTENTION
#_chroot sudo -n -u user bash -c 'cd /home/user/core/infrastructure/ubiquitous_bash ; ./ubiquitous_bash.sh _gpdWinMini2024_8840U_fan_install'
_gpdWinMini2024_8840U_fan_install() {
    # DUBIOUS . May be untested.
    #( crontab -l ; echo '#*/1 * * * * sleep 0.1 ; sleep 210 ; /home/user/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _gpdWinMini2024_8840U_fan_cron > /dev/null 2>&1' ) | crontab -

    if ! crontab -l | grep _gpdWinMini2024_8840U_fan_cron > /dev/null
	then
        (
            crontab -l
            cat << 'CZXWXcRMTo8EmM8i4d'
*/1 * * * * sleep 0.1 ; sleep 210 ; /home/user/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _gpdWinMini2024_8840U_fan_cron > /dev/null 2>&1
CZXWXcRMTo8EmM8i4d
        ) | crontab -
	fi
}


_gpdWinMini2024_8840U_fan_cfg-write() {
	#echo "options gpd-fan fan_control=1" | sudo -n tee /etc/modprobe.d/gpd_fan.conf
    true
}

_gpdWinMini2024_8840U_fan_cfg-modprobe() {
	sudo -n modprobe -rv gpd-fan
	sudo -n modprobe -v gpd-fan
}

_gpdWinMini2024_8840U_fan_cfg() {
	#echo watchdog 120 | sudo -n tee /proc/acpi/gpd/fan
    true
}

# cron recommended
#*/1 * * * * sleep 0.1 ; /home/user/.ubcore/ubcore.sh _gpdWinMini2024_8840U_hardware_cron > /dev/null 2>&1
#*/1 * * * * sleep 0.1 ; /home/user/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _gpdWinMini2024_8840U_hardware_cron > /dev/null 2>&1
_gpdWinMini2024_8840U_fan_cron() {
	#! sudo -n dmidecode -s system-family | grep 'gpdWinMini2024_8840U' && return 0
    #! [[ -e /sys/devices/platform/gpd_fan ]] && return 0
	
	_gpdWinMini2024_8840U_fan
	
	return 0
}

# cron recommended
#*/1 * * * * sleep 0.1 ; /home/user/.ubcore/ubiquitous_bash/ubcore.sh _gpdWinMini2024_8840U_fan > /dev/null 2>&1
#*/1 * * * * sleep 0.1 ; /home/user/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh _gpdWinMini2024_8840U_hardware_cron > /dev/null 2>&1
# https://github.com/Cryolitia/gpd-fan-driver
_gpdWinMini2024_8840U_fan() {
	_gpdWinMini2024_8840U_fan_cfg
	
    # ATTENTION: TODO: WARNING: May be untested.
	local currentTemp_coretemp0
	read currentTemp_coretemp0 < /sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input

    if [[ -e "$HOME"/fanFast ]]
    then
        # 0: disable (full speed)
        # 1: manual
        # 2: auto
        echo 2 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable
        return 0
    fi

    if [[ -e "$HOME"/fanIdle ]]
    then
        # 0: disable (full speed)
        # 1: manual
        # 2: auto
        echo 1 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable

        echo 92 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0

        return 0
    fi

    #Suggested fan curve:
    #35% 50degC
    #38% 65degC
    #38% 70degC
    #100% 80degC
    # range: 0-255

    # 0: disable (full speed)
    # 1: manual
    # 2: auto
    echo 1 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable
	
    #35% 50degC
	[[ "$currentTemp_coretemp0" -lt 50000 ]] && echo 92 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0

    [[ "$currentTemp_coretemp0" -lt 53000 ]] && echo 93 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0
    [[ "$currentTemp_coretemp0" -lt 60000 ]] && echo 94 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0
    [[ "$currentTemp_coretemp0" -lt 63000 ]] && echo 95 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0

    #38% 65degC
	[[ "$currentTemp_coretemp0" -lt 65000 ]] && echo 97 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0

    #38% 70degC
    [[ "$currentTemp_coretemp0" -lt 70000 ]] && echo 97 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0

    #100% 80degC
    [[ "$currentTemp_coretemp0" -lt 80000 ]] && echo 255 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0
}

_gpdWinMini2024_8840U_idle() {
	_gpdWinMini2024_8840U_fan_cfg
	
	while true
	do
		echo powersave | sudo -n tee /sys/devices/system/cpu/cpufreq/*/scaling_governor

        rm -f "$HOME"/fanFast
        rm -f "$HOME"/fanIdle

        echo > "$HOME"/fanIdle
		
        # 0: disable (full speed)
        # 1: manual
        # 2: auto
		echo 1 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable

        echo 92 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1 && return 0
		
		sleep 45
	done
}

_gpdWinMini2024_8840U_normal() {
	echo schedutil | sudo -n tee /sys/devices/system/cpu/cpufreq/*/scaling_governor

    rm -f "$HOME"/fanFast
    rm -f "$HOME"/fanIdle

    echo 2 | sudo -n tee /sys/devices/platform/gpd_fan/hwmon/hwmon*/pwm1_enable
}
