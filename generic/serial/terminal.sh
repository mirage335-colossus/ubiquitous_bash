
# Creates autologin terminal at specified serial port device, preferably serial/by-id or similar.
# ATTENTION: STRONGLY RECOMMENDED to use serial/by-id instead of ttyUSB0 , etc . The entire point of these functions is to offer that functionality, rather than using the exiting serial-getty@ttyUSB0 services with that inherent unreliability.


# WARNING: Do NOT login as same user as display manager (ie. 'sddm') login! Must continue to exist after all 'user' processes are terminated!
# https://wiki.gentoo.org/wiki/Automatic_login_to_virtual_console
# https://forums.debian.net/viewtopic.php?t=140452
# https://forums.debian.net/viewtopic.php?f=16&t=123694
# https://man7.org/linux/man-pages/man8/agetty.8.html
# https://unix.stackexchange.com/questions/459942/using-systemctl-edit-via-bash-script
#ExecStart=-/sbin/agetty -o '-p -- \\u' --noclear %I $TERM
#ExecStart=-/sbin/agetty --autologin user --noclear %I 38400 linux
#export getMost_backend="chroot" ; _autologin_serial "serial/by-id/..."
#export getMost_backend="" ; _autologin_serial "serial/by-id/..."
_autologin_serial_sequence() {
    _start
    
    # ATTENTION: Default backend is "direct" . Override to "chroot" or "ssh" as desired .
    # WARNING: Backends other than "direct" may be untested.
    #export getMost_backend="chroot"

    _messageNormal 'init: _autologin_serial'

    local currentTerminal
    currentTerminal="$1"
    [[ "$currentTerminal" == "" ]] && _messagePlain_bad 'missing: currentTerminal' && _messageFAIL && _stop 1

    _messagePlain_nominal '_autologin_serial: _getMost_backend'
    
	_set_getMost_backend
	_set_getMost_backend_debian
	_test_getMost_backend

    _messagePlain_probe_var getMost_backend

    _messagePlain_nominal '_autologin_serial: write: terminal-serial.service'
    cat << CZXWXcRMTo8EmM8i4d | _getMost_backend tee /etc/systemd/system/terminal-serial.service
[Unit]
# /lib/systemd/system/serial-getty@.service
# /etc/systemd/system/getty.target.wants/getty@tty1.service
Description=Serial Port Terminal
#BindsTo=dev-%i.device
#After=dev-%i.device systemd-user-sessions.service plymouth-quit-wait.service getty-pre.target
After=systemd-user-sessions.service getty-pre.target
After=rc-local.service

# If additional gettys are spawned during boot then we should make
# sure that this is synchronized before getty.target, even though
# getty.target didn't actually pull it in.
Before=getty.target
IgnoreOnIsolate=yes

# IgnoreOnIsolate causes issues with sulogin, if someone isolates
# rescue.target or starts rescue.service from multi-user.target or
# graphical.target.
Conflicts=rescue.service
Before=rescue.service

[Service]
# The '-o' option value tells agetty to replace 'login' arguments with an
# option to preserve environment (-p), followed by '--' for safety, and then
# the entered username.
#ExecStart=-/sbin/agetty -o '-p -- \\u' --keep-baud 115200,57600,38400,9600 - "$currentTerminal"
#Type=idle
Type=simple
ExecStart=
#ExecStart=-/sbin/agetty --autologin root --keep-baud 230400,115200,57600,38400,9600 --noclear %I "$currentTerminal"
ExecStart=-/sbin/agetty --autologin root --local-line -p -h "$currentTerminal" 230400 xterm-256color
Restart=always
#UtmpIdentifier=%I
#UtmpIdentifier="$currentTerminal"
#StandardInput=tty
#StandardOutput=tty
#TTYPath=/dev/%I
#TTYPath=/dev/"$currentTerminal"
#TTYReset=yes
#TTYVHangup=yes
#IgnoreSIGPIPE=no
#SendSIGHUP=yes

[Install]
WantedBy=getty.target
CZXWXcRMTo8EmM8i4d

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1

    _messagePlain_nominal '_autologin_serial: enable: /etc/systemd/system/getty.target.wants/terminal-serial.service'
    #_getMost_backend tee /etc/systemd/system/terminal-serial.service
    _getMost_backend chmod 644 /etc/systemd/system/terminal-serial.service
    _messagePlain_probe_cmd _getMost_backend systemctl stop terminal-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1

    _messagePlain_probe_cmd _getMost_backend systemctl enable terminal-serial.service
    _messagePlain_probe_cmd _getMost_backend ln -sf /etc/systemd/system/terminal-serial.service /etc/systemd/system/getty.target.wants/terminal-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1
    _messagePlain_probe_cmd _getMost_backend systemctl start terminal-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl status terminal-serial.service | cat


    _messagePlain_nominal '_autologin_serial: cron'
    # Do NOT rely on systemd to ensure the service is started. Add cron job to guarantee such critical services are started.
    if ! _getMost_backend /bin/bash -l -c 'crontab -l' | grep 'terminal-serial' > /dev/null
    then
        ( _getMost_backend /bin/bash -l -c 'crontab -l' ; echo '*/1 * * * * systemctl start terminal-serial.service' ) | _getMost_backend /bin/bash -l -c 'crontab -'
    fi
    ! _getMost_backend /bin/bash -l -c 'crontab -l' | grep 'terminal-serial' > /dev/null && _messagePlain_bad 'fail: crontab' && _messageFAIL && _stop 1

    _stop
}
_autologin_serial() {
    "$scriptAbsoluteLocation" _autologin_serial_sequence "$@"
}
_terminal_serial() {
    _autologin_serial "$@"
}
# NOTICE: PREFERRED.
_serial_terminal() {
    _autologin_serial "$@"
}


#_serial_screen /dev/serial/by-id/...
_serial_screen() {
    [[ "$1" == "" ]] && _messagePlain_bad 'bad: missing: serial device' && _messageFAIL
    
    # Arguably not best practice, but this is only used for such things as a single laptop diagnosing a single server... seems like a reasonable convenience.
    pkill ^screen$ > /dev/null 2>&1 && sleep 1
    sudo -n pkill ^screen$ > /dev/null 2>&1 && sleep 1
    
    local currentTERM
    currentTERM="$TERM"
    [[ "$currentTERM" == "" ]] && currentTERM="xterm-256color"
    screen "$1" 230400 -T "$TERM"
}

