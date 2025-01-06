
# ATTRIBUTION-AI ChatGPT o1 2025-01-06 ... partially

# _serial_server /dev/serial/by-id/... 22 256000
_serial_server_sequence() {
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
    BAUD_RATE="${3:-256000}"

    echo "Starting socat to forward ${SERIAL_DEV} <--> localhost:${WEB_PORT}"
    echo "Baud rate: ${BAUD_RATE}"

    # -d -d     : enable debug messages twice (for more verbosity)
    # -v        : verbose traffic logging
    # OPEN:...  : open the serial device, set it raw, no echo, at the chosen baud
    # TCP:...   : connect to localhost:WEB_PORT
    #
    # If you want to watch hex dumps of data, you can also add '-x'.
    socat -d -d -v OPEN:"${SERIAL_DEV}",raw,echo=0,b${BAUD_RATE} TCP:127.0.0.1:${WEB_PORT}
}
_serial_server() {
    "$scriptAbsoluteLocation" _serial_server_sequence "$@"
}

# _serial_server /dev/serial/by-id/... 10022 256000
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
    #   BAUD_RATE="256000"
    #   REMOTE_LISTEN_PORT="10022"
    #
    # This listens on TCP port 8080 and forwards the data to/from the serial device.
    # --------------------------------------------------------------------

    local SERIAL_DEV
    local REMOTE_LISTEN_PORT
    local BAUD_RATE

    SERIAL_DEV="${1:-/dev/ttyACM0}"
    REMOTE_LISTEN_PORT="${2:-10022}"
    BAUD_RATE="${3:-256000}"

    echo "Remote side: listening on 0.0.0.0:${REMOTE_LISTEN_PORT}, forwarding to ${SERIAL_DEV} (baud ${BAUD_RATE})"
    echo "Press Ctrl-C to stop."

    socat -d -d -v \
    TCP-LISTEN:${REMOTE_LISTEN_PORT},bind=127.0.0.1,fork,reuseaddr \
    OPEN:"${SERIAL_DEV}",raw,echo=0,b${BAUD_RATE}

    _stop
}
_serial_client() {
    "$scriptAbsoluteLocation" _serial_client_sequence "$@"
}



