
# NOTICE: Recommend 'ssh -C' (ie. compression) for a lower-latency more 'snappy' experience.
# NOTICE: Some USB serial converters are apparently based on microcontrollers, compatible with at least 4m baud.


#./compile.sh ; ./ubiquitous_bash.sh _serial_server-service /dev/serial/by-id/... ; ./ubiquitous_bash.sh _serial_client-service /dev/serial/by-id/...


#stty -F /dev/serial/by-id/...1 raw -echo -ixon -ixoff -crtscts 115200

#stty -F /dev/serial/by-id/...2 raw -echo -ixon -ixoff -crtscts 115200

#cat /dev/urandom | head -c 1000000 > fill

#cat /dev/serial/by-id/...1 | head -c 1000000 | cksum

#cat ./fill > /dev/serial/by-id/...2

#cksum ./fill




#b115200
#b230400
#b460800
#b4000000


# TODO: ATTENTION: WARNING: CAUTION: If any issues are encountered forwarding other network services (eg. HTTP, HTTPS, VPN, etc), the FIRST thing to do is disable the redundant TERMIOS_OPT setting by socat instead of exclusively by stty . Apparently, socat terminal options may be somewhat more fragile and less documented.

_set_serial_serverClient() {
    # rawer   avoid, known to fail
    # hupcl=0?   stty documentation suggests +hupcl disables hup, equivalent to hup-
    # istrip=1,iuclc=1   stty documentation suggests these are unhelpful
    # raw   -ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr -icrnl -ixon -ixoff -icanon -opost -isig -iuclc -ixany -imaxbel -xcase
    # sane   cread -ignbrk brkint -inlcr -igncr icrnl icanon iexten echo echoe echok -echonl -noflsh -ixoff -iutf8 -iuclc -ixany imaxbel -xcase -olcuc -ocrnl opost -ofill onlcr -onocr -onlret nl0 cr0 tab0 bs0  vt0  ff0  isig -tostop -ofdel -echoprt echoctl echoke -extproc -flusho
    export forwardPort_serial_default_BAUD=4000000
    #export forwardPort_serial_default_TERMIOS_OPT=cs8,ixon=0,ixoff=0,crtscts=1,clocal=0,parenb=1,cstopb=0
    #export forwardPort_serial_default_TERMIOS_OPT=raw,echo=0,ixon=0,ixoff=0,crtscts=1,cs8,parenb=1,cstopb=0,clocal=0,hupcl=0
    export forwardPort_serial_default_TERMIOS_OPT=raw,echo=0,ixon=0,ixoff=0,crtscts=1,cs8,parenb=1,cstopb=0,clocal=0,hupcl=1
    #export forwardPort_serial_default_TERMIOS_OPT=rawer,echo=0,ixon=0,ixoff=0,crtscts=1,cs8,parenb=1,cstopb=0,clocal=0,hupcl=1
}

_serial_serverClient_stty() {
    #parenb -cstopb clocal 
    #_messagePlain_probe_cmd stty -F "$1" raw -echo -ixon -ixoff crtscts cs8 parenb -cstopb -clocal "$2"
    #_messagePlain_probe_cmd stty -F "$1" raw -echo -ixon -ixoff crtscts cs8 parenb cstopb -clocal hup "$2"
    _messagePlain_probe_cmd stty -F "$1" raw -echo -ixon -ixoff crtscts cs8 parenb -cstopb -clocal hup "$2"
}


# ATTRIBUTION-AI ChatGPT o1 2025-01-06 ... partially

# _serial_server /dev/serial/by-id/... 22 115200
_serial_server_sequence() {
    _set_serial_serverClient
    
    #_start
    
    ##
    # This script uses socat to forward any data from a USB serial device to
    # a local TCP port (e.g., 80 for HTTP).
    #
    # Usage:
    #   ./serial_to_http.sh /dev/ttyUSB0 115200 80
    #
    # Then on the remote side (the device connected to /dev/ttyUSB0), send raw
    # HTTP requests to retrieve the web page from the local server.
    ##

    local SERIAL_DEV
    local WEB_PORT
    local BAUD_RATE

    SERIAL_DEV="${1:-/dev/ttyUSB0}"
    WEB_PORT="${2:-22}"
    BAUD_RATE="${3:-$forwardPort_serial_default_BAUD}"
    
    # Mostly attempts to ensure physical dis/re-connection of USB serial adapters does not inappropriately re-use 'zombie' device files.
    if ! [[ -e "$SERIAL_DEV" ]]
    then
        while ! [[ -e "$SERIAL_DEV" ]]
        do
            sleep 1
        done
        sleep 45
    fi
    
    echo 'stty'
    #parenb -cstopb clocal 
    #_messagePlain_probe_cmd stty -F "${SERIAL_DEV}" raw -echo -ixon -ixoff crtscts cs8 parenb -cstopb -clocal "${BAUD_RATE}"
    _serial_serverClient_stty "${SERIAL_DEV}" "${BAUD_RATE}"
    sleep 0.1

    echo "Starting socat to forward ${SERIAL_DEV} <--> localhost:${WEB_PORT}"
    echo "Baud rate: ${BAUD_RATE}"

    # -d -d     : enable debug messages twice (for more verbosity)
    # -v        : verbose traffic logging
    # OPEN:...  : open the serial device, set it raw, no echo, at the chosen baud
    # TCP:...   : connect to localhost:WEB_PORT
    #
    # If you want to watch hex dumps of data, you can also add '-x'.
    #_messagePlain_probe_cmd socat -d -d -v OPEN:"${SERIAL_DEV}",rawer,echo=0,b"${BAUD_RATE}",cs8,ixon=0,ixoff=0,crtscts=1,clocal=0,parenb,cstopb=0 TCP:127.0.0.1:"${WEB_PORT}"
    #_messagePlain_probe_cmd socat -d -d OPEN:"${SERIAL_DEV}",rawer,echo=0,b"${BAUD_RATE}","$forwardPort_serial_default_TERMIOS_OPT" TCP:127.0.0.1:"${WEB_PORT}"
    _messagePlain_probe_cmd socat -d -d OPEN:"${SERIAL_DEV}",b"${BAUD_RATE}","$forwardPort_serial_default_TERMIOS_OPT" TCP:127.0.0.1:"${WEB_PORT}"
    #_messagePlain_probe_cmd socat -d -d OPEN:"${SERIAL_DEV}" TCP:127.0.0.1:"${WEB_PORT}"
    
    #_stop
}
_serial_server_program() {
    "$scriptAbsoluteLocation" _serial_server_sequence "$@"
}
_serial_server_loop() {
    while true
    do
        "$scriptAbsoluteLocation" _serial_server_sequence "$@"
        sleep 0.1
    done
}
_serial_server() {
    "$scriptAbsoluteLocation" _serial_server_loop "$@"
}

# _serial_server /dev/serial/by-id/... 10022 115200
_serial_client_sequence() {
    _set_serial_serverClient
    
    #_start

    # --------------------------------------------------------------------
    # serial_proxy_remote.sh
    #
    # Usage:
    #   ./serial_proxy_remote.sh [SERIAL_DEV] [BAUD_RATE] [REMOTE_LISTEN_PORT]
    #
    # Default values:
    #   SERIAL_DEV="/dev/ttyACM0"
    #   BAUD_RATE="115200"
    #   REMOTE_LISTEN_PORT="10022"
    #
    # This listens on TCP port 8080 and forwards the data to/from the serial device.
    # --------------------------------------------------------------------

    local SERIAL_DEV
    local REMOTE_LISTEN_PORT
    local BAUD_RATE

    SERIAL_DEV="${1:-/dev/ttyUSB0}"
    REMOTE_LISTEN_PORT="${2:-10022}"
    BAUD_RATE="${3:-$forwardPort_serial_default_BAUD}"
    
    # Mostly attempts to ensure physical dis/re-connection of USB serial adapters does not inappropriately re-use 'zombie' device files.
    if ! [[ -e "$SERIAL_DEV" ]]
    then
        while ! [[ -e "$SERIAL_DEV" ]]
        do
            sleep 1
        done
        sleep 45
    fi
    
    echo 'stty'
    #parenb -cstopb clocal 
    #_messagePlain_probe_cmd stty -F "${SERIAL_DEV}" raw -echo -ixon -ixoff crtscts cs8 parenb -cstopb -clocal "${BAUD_RATE}"
    _serial_serverClient_stty "${SERIAL_DEV}" "${BAUD_RATE}"
    sleep 0.1

    echo "Remote side: listening on 0.0.0.0:${REMOTE_LISTEN_PORT}, forwarding to ${SERIAL_DEV} (baud ${BAUD_RATE})"
    echo "Press Ctrl-C to stop."

    #_messagePlain_probe_cmd socat -d -d -v TCP-LISTEN:"${REMOTE_LISTEN_PORT}",bind=127.0.0.1,fork,reuseaddr OPEN:"${SERIAL_DEV}",rawer,echo=0,b"${BAUD_RATE}",cs8,ixon=0,ixoff=0,crtscts=1,clocal=0,parenb=1,cstopb=0
    #_messagePlain_probe_cmd socat -d -d TCP-LISTEN:"${REMOTE_LISTEN_PORT}",bind=127.0.0.1,fork,reuseaddr OPEN:"${SERIAL_DEV}",rawer,echo=0,b"${BAUD_RATE}","$forwardPort_serial_default_TERMIOS_OPT"
    _messagePlain_probe_cmd socat -d -d TCP-LISTEN:"${REMOTE_LISTEN_PORT}",bind=127.0.0.1,fork,reuseaddr OPEN:"${SERIAL_DEV}",b"${BAUD_RATE}","$forwardPort_serial_default_TERMIOS_OPT"
    #_messagePlain_probe_cmd socat -d -d TCP-LISTEN:"${REMOTE_LISTEN_PORT}",bind=127.0.0.1,fork,reuseaddr OPEN:"${SERIAL_DEV}"

    #_stop
}
_serial_client_program() {
    "$scriptAbsoluteLocation" _serial_client_sequence "$@"
}
_serial_client() {
    "$scriptAbsoluteLocation" _serial_client_sequence "$@"
}


