

#stty -F /dev/serial/by-id/...1 raw -echo -ixon -ixoff -crtscts 115200

#stty -F /dev/serial/by-id/...2 raw -echo -ixon -ixoff -crtscts 115200

#cat /dev/urandom | head -c 1000000 > fill

#cat /dev/serial/by-id/...1 | head -c 1000000 | cksum

#cat ./fill > /dev/serial/by-id/...2

#cksum ./fill


# ATTENTION: Strangely, raw file copy/pipe through the serial port at the higher baud rate of 230400 is exactly correct, however, SSH through socat apparently does not work well above 115200 . This may be due to full duplex not working at the higher baud rate with some serial adapters, and if so, running a VPN (but NOT PPP or TCP generally to the upstream LAN/WAN/NAT, etc) through this serial port forwarding may be able to use the higher baud rate in some situations.

#b115200
#b230400
#b460800



# ATTRIBUTION-AI ChatGPT o1 2025-01-06 ... partially

# _serial_server /dev/serial/by-id/... 22 115200
_serial_server_sequence() {
    _start
    
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
    BAUD_RATE="${3:-115200}"
    
    echo 'stty'
    #parenb -cstopb clocal 
    _messagePlain_probe_cmd stty -F "${SERIAL_DEV}" raw -echo -ixon -ixoff crtscts cs8 -parenb cstopb -clocal "${BAUD_RATE}"
    sleep 0.1

    echo "Starting socat to forward ${SERIAL_DEV} <--> localhost:${WEB_PORT}"
    echo "Baud rate: ${BAUD_RATE}"

    # -d -d     : enable debug messages twice (for more verbosity)
    # -v        : verbose traffic logging
    # OPEN:...  : open the serial device, set it raw, no echo, at the chosen baud
    # TCP:...   : connect to localhost:WEB_PORT
    #
    # If you want to watch hex dumps of data, you can also add '-x'.
    _messagePlain_probe_cmd socat -d -d -v OPEN:"${SERIAL_DEV}",raw,echo=0,b"${BAUD_RATE}",cs8,ixon=0,ixoff=0,crtscts=1 TCP:127.0.0.1:"${WEB_PORT}"
    
    _stop
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
    _start

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
    BAUD_RATE="${3:-115200}"
    
    echo 'stty'
    #parenb -cstopb clocal 
    _messagePlain_probe_cmd stty -F "${SERIAL_DEV}" raw -echo -ixon -ixoff crtscts cs8 -parenb cstopb -clocal "${BAUD_RATE}"
    sleep 0.1

    echo "Remote side: listening on 0.0.0.0:${REMOTE_LISTEN_PORT}, forwarding to ${SERIAL_DEV} (baud ${BAUD_RATE})"
    echo "Press Ctrl-C to stop."

    _messagePlain_probe_cmd socat -d -d -v TCP-LISTEN:"${REMOTE_LISTEN_PORT}",bind=127.0.0.1,fork,reuseaddr OPEN:"${SERIAL_DEV}",raw,echo=0,b"${BAUD_RATE}",cs8,ixon=0,ixoff=0,crtscts=1

    _stop
}
_serial_client() {
    "$scriptAbsoluteLocation" _serial_client_sequence "$@"
}


