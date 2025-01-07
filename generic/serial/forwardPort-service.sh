
#export getMost_backend="chroot"
# _serial_server-service /dev/serial/by-id/... 22 4000000
_serial_server-service_sequence() {
    _start
    
    # ATTENTION: Default backend is "direct" . Override to "chroot" or "ssh" as desired .
    # WARNING: Backends other than "direct" may be untested.
    #export getMost_backend="chroot"

    _messageNormal 'init: _serial_server-service'
    
    local SERIAL_DEV
    local WEB_PORT
    local BAUD_RATE
    
    [[ "$1" == "" ]] && _messagePlain_bad 'missing: SERIAL_DEV' && _messageFAIL && _stop 1

    SERIAL_DEV="${1:-/dev/ttyUSB0}"
    WEB_PORT="${2:-22}"
    #BAUD_RATE="${3:-4000000}"

    _messagePlain_nominal '_serial_server-service: _getMost_backend'
    
	_set_getMost_backend
	_set_getMost_backend_debian
	_test_getMost_backend

    _messagePlain_probe_var getMost_backend
    
    _messagePlain_nominal '_serial_server-service: copy: binary'
    cat "$scriptAbsoluteLocation" | _getMost_backend tee /usr/local/bin/serial_forwardPort.sh > /dev/null
    _getMost_backend chmod 755 /usr/local/bin/serial_forwardPort.sh

    _messagePlain_nominal '_serial_server-service: write: server-serial.service'
    
    #/lib/systemd/system/ssh.service
    cat << CZXWXcRMTo8EmM8i4d | _getMost_backend tee /etc/systemd/system/server-serial.service
[Unit]
Description=Server Socat Port Forwarder through Serial Port
#After=systemd-user-sessions.service getty-pre.target
#After=rc-local.service
#After=network-online.target
#After=network.target auditd.service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
#ExecStart=/usr/local/bin/serial_forwardPort.sh _serial_server "$SERIAL_DEV" "$WEB_PORT" "$BAUD_RATE"
ExecStart=/usr/local/bin/serial_forwardPort.sh _serial_server_program "$SERIAL_DEV" "$WEB_PORT" "$BAUD_RATE"
#ExecStart=socat -d -d OPEN:"$SERIAL_DEV",sane,rawer,echo=0,b"$BAUD_RATE",cs8,ixon=0,ixoff=0,crtscts=1,clocal=0,parenb,cstopb=0 TCP:127.0.0.1:"$WEB_PORT"
Restart=always
RestartSec=1
User=root

[Install]
WantedBy=multi-user.target
CZXWXcRMTo8EmM8i4d

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1

    _messagePlain_nominal '_serial_server-service: enable: /etc/systemd/system/multi-user.target.wants/server-serial.service'
    #_getMost_backend tee /etc/systemd/system/server-serial.service
    _getMost_backend chmod 644 /etc/systemd/system/server-serial.service
    _messagePlain_probe_cmd _getMost_backend systemctl stop server-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1

    _messagePlain_probe_cmd _getMost_backend systemctl enable server-serial.service
    _messagePlain_probe_cmd _getMost_backend ln -sf /etc/systemd/system/server-serial.service /etc/systemd/system/multi-user.target.wants/server-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1
    _messagePlain_probe_cmd _getMost_backend systemctl start server-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl status server-serial.service | cat


    _messagePlain_nominal '_serial_server-service: cron'
    # Do NOT rely on systemd to ensure the service is started. Add cron job to guarantee such critical services are started.
    if ! _getMost_backend /bin/bash -l -c 'crontab -l' | grep 'server-serial' > /dev/null
    then
        ( _getMost_backend /bin/bash -l -c 'crontab -l' ; echo '*/1 * * * * systemctl start server-serial.service' ) | _getMost_backend /bin/bash -l -c 'crontab -'
    fi
    ! _getMost_backend /bin/bash -l -c 'crontab -l' | grep 'server-serial' > /dev/null && _messagePlain_bad 'fail: crontab' && _messageFAIL && _stop 1

    _stop
}
_serial_server-service() {
    "$scriptAbsoluteLocation" _serial_server-service_sequence "$@"
}







#export getMost_backend="chroot"
# _serial_server-service /dev/serial/by-id/... 22 4000000
_serial_client-service_sequence() {
    _start
    
    # ATTENTION: Default backend is "direct" . Override to "chroot" or "ssh" as desired .
    # WARNING: Backends other than "direct" may be untested.
    #export getMost_backend="chroot"

    _messageNormal 'init: _serial_client-service'
    
    local SERIAL_DEV
    local REMOTE_LISTEN_PORT
    local BAUD_RATE
    
    [[ "$1" == "" ]] && _messagePlain_bad 'missing: SERIAL_DEV' && _messageFAIL && _stop 1

    SERIAL_DEV="${1:-/dev/ttyUSB0}"
    REMOTE_LISTEN_PORT="${2:-10022}"
    #BAUD_RATE="${3:-4000000}"

    _messagePlain_nominal '_serial_client-service: _getMost_backend'
    
	_set_getMost_backend
	_set_getMost_backend_debian
	_test_getMost_backend

    _messagePlain_probe_var getMost_backend
    
    _messagePlain_nominal '_serial_client-service: copy: binary'
    cat "$scriptAbsoluteLocation" | _getMost_backend tee /usr/local/bin/serial_forwardPort.sh > /dev/null
    _getMost_backend chmod 755 /usr/local/bin/serial_forwardPort.sh

    _messagePlain_nominal '_serial_client-service: write: client-serial.service'
    
    #/lib/systemd/system/ssh.service
    cat << CZXWXcRMTo8EmM8i4d | _getMost_backend tee /etc/systemd/system/client-serial.service
[Unit]
Description=Server Socat Port Forwarder through Serial Port
#After=systemd-user-sessions.service getty-pre.target
#After=rc-local.service
#After=network-online.target
#After=network.target auditd.service
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
#ExecStart=/usr/local/bin/serial_forwardPort.sh _serial_client "$SERIAL_DEV" "$REMOTE_LISTEN_PORT" "$BAUD_RATE"
ExecStart=/usr/local/bin/serial_forwardPort.sh _serial_client_program "$SERIAL_DEV" "$REMOTE_LISTEN_PORT" "$BAUD_RATE"
#ExecStart=socat -d -d TCP-LISTEN:"$REMOTE_LISTEN_PORT",bind=127.0.0.1,fork,reuseaddr OPEN:"$SERIAL_DEV",sane,rawer,echo=0,b"$BAUD_RATE",cs8,ixon=0,ixoff=0,crtscts=1,clocal=0,parenb=1,cstopb=0
Restart=always
RestartSec=1
User=root

[Install]
WantedBy=multi-user.target
CZXWXcRMTo8EmM8i4d

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1

    _messagePlain_nominal '_serial_client-service: enable: /etc/systemd/system/multi-user.target.wants/client-serial.service'
    #_getMost_backend tee /etc/systemd/system/client-serial.service
    _getMost_backend chmod 644 /etc/systemd/system/client-serial.service
    _messagePlain_probe_cmd _getMost_backend systemctl stop client-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1

    _messagePlain_probe_cmd _getMost_backend systemctl enable client-serial.service
    _messagePlain_probe_cmd _getMost_backend ln -sf /etc/systemd/system/client-serial.service /etc/systemd/system/multi-user.target.wants/client-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl daemon-reload
    sleep 1
    _messagePlain_probe_cmd _getMost_backend systemctl start client-serial.service

    _messagePlain_probe_cmd _getMost_backend systemctl status client-serial.service | cat


    _messagePlain_nominal '_serial_client-service: cron'
    # Do NOT rely on systemd to ensure the service is started. Add cron job to guarantee such critical services are started.
    if ! _getMost_backend /bin/bash -l -c 'crontab -l' | grep 'client-serial' > /dev/null
    then
        ( _getMost_backend /bin/bash -l -c 'crontab -l' ; echo '*/1 * * * * systemctl start client-serial.service' ) | _getMost_backend /bin/bash -l -c 'crontab -'
    fi
    ! _getMost_backend /bin/bash -l -c 'crontab -l' | grep 'client-serial' > /dev/null && _messagePlain_bad 'fail: crontab' && _messageFAIL && _stop 1

    _stop
}
_serial_client-service() {
    "$scriptAbsoluteLocation" _serial_client-service_sequence "$@"
}





















