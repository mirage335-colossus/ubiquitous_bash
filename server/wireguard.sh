


# WARNING
# WARNING
# WARNING
#
# WARNING: May be untested.
#
# WARNING
# WARNING
# WARNING







# Very simple VPN service for temporary ad-hoc networks (ie. between 'factory' containers, some of which may be capable of different tasks, but which together are used as a factory to generate an output).

# Manually operated, as usual of 'factory' , 'server' , etc, functions . Does NOT necessarily install a service (eg. systemd hook), but does get a server program going without restarting anything, etc. Run function from within 'Docker' container, etc, if needed.



# Possible alternative services:
# tailscale ?

# ATTENTION: NOTICE: DEPENDENCIES:
#apt-get install wireguard wireguard-go
# ATTENTION: NOTICE: RECOMMENDED:
#apt-get install sudo net-tools man-db ufw nftables yes
#echo -e 'y\ny\ny\n' | unminimize
#_cfgFW-desktop

# May also be useful to host some other convenient servers with hardware (or other resource, cloud, etc) occupied by the VPN server.
#nfs
#OpenWebUI
#
# https://docs.openwebui.com/getting-started/quick-start/
#
# API keys used for such a temporary network should problably be named with prefix 'API_FACTORY_' or similar .
#  (with very short expiration)





# WARNING: Avoid addresses that are internet routable or may conflict with hosting providers, etc.
# WARNING: Avoid HappyCAN (aka. FakeCAN), related special IP ranges, etc.
#  Beware HappyCAN and related allocations are extremely broad, as absolutely necessary to avoid unreliable centralized services by uniquely numbering devices according to bitmask within ranges representing purpose, peripherial, and sensor/actuator/etc .
# Do NOT use 10.x.x.x , all of these addresses are either used by HappyCAN, or reserved for servers sharing possible connectivity through a HappyCAN compliant network.
#
# https://en.wikipedia.org/wiki/Reserved_IP_addresses#IPv4
# https://www.techspot.com/guides/287-default-router-ip-addresses/
#
# 172.16.0.0/12  172.16.0.0–172.31.255.255  Explicit FAIL (filtered out) for HappyCAN fw. RECOMMENDED!
# 198.18.0.0/15  198.18.0.0–198.19.255.255	 Official purpose is benchmarking between networks. May be appropriate in practice for such very high-performance temporary private networks.


# WARNING: Choose port outside RESERVED ranges but within otherwise allocated range 38000:38999 . Allowed through fw by default as a range of ports only used for those specific production network services which have established methods of safe use.
# WARNING: Ports 38000-38010 RESERVED for laboratory network experimentation with pipes , both TCP and UDP.
# WARNING: Ports 38085-38099 RESERVED for laboratory network experimentation with pipes , both TCP and UDP.
# WARNING: Ports 38400-38699 RESERVED for laboratory network experimentation with pipes , both TCP and UDP (especially for RF frequency mixing or BFSK/OFDM, QAM, etc, conversion or modulation from analog Ethernet/SFP baseband).
# WARNING: Ports 38800-38899 RESERVED for decentralized replacements for HTTP/HTTPS , peer discovery, etc, both TCP and UDP.
# WARNING: Ports 38980-38999 RESERVED for gizmos , both TCP and UDP.
#
# Do NOT use 38020, 38021, 38022, etc (ie. SSH, SFTP, FTP, etc, suffixes) .
#
# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
#
# Convention is '380xx' prefix, then the common port number . For an SSH server, '38022' would be reasonable.
#
# VPN server port '38024'  suggested .


# Beware servers which must NOT be reachable outside the VPN must use a port range blocked by firewall by default.
#
# (from _findPort)
##Non public ports are between 49152-65535 (2^15 + 2^14 to 2^16 - 1).
##Convention is to assign ports 55000-65499 and 50025-53999 to specialized servers.
##read lower_port upper_port < /proc/sys/net/ipv4/ip_local_port_range
#[[ "$lower_port" == "" ]] && lower_port=54000
#[[ "$upper_port" == "" ]] && upper_port=54999
#
# NFS/VPN server port '52049'  suggested .
# CIFS/VPN server port '53020'  suggested .
# SMB/VPN server port '50445'  suggested .





# https://upcloud.com/resources/tutorials/get-started-wireguard-vpn?utm_source=chatgpt.com
#/etc/wireguard/wg0.conf
_here_wireguard() {

    cat << CZXWXcRMTo8EmM8i4d

[Interface]
PrivateKey = $WIREGUARD_PRIVATE
#Address = 10.0.0.1/24
Address = 172.16.0.1/24
#PostUp = 
#PostDown = 
ListenPort = $WIREGUARD_PORT

[Peer]
PublicKey = $WIREGUARD_PUBLIC
#AllowedIPs = 10.0.0.2/32
AllowedIPs = 172.16.0.0/12


CZXWXcRMTo8EmM8i4d
}


_server_sequence-wireguard() {
    _mustBeRoot

    _start

    _messageNormal '_server-wireguard: init'
    [[ "$WIREGUARD_PORT" == "" ]] && WIREGUARD_PORT="38024"

    if [[ "$WIREGUARD_PRIVATE" == "" ]] || [[ "$WIREGUARD_PUBLIC" == "" ]]
    then
        if [[ -e /etc/wireguard/privatekey ]] && [[ -e /etc/wireguard/publickey ]]
        then
            export WIREGUARD_PRIVATE=$(cat /etc/wireguard/privatekey)
            export WIREGUARD_PUBLIC=$(cat /etc/wireguard/publickey)
        fi
    fi

    if [[ "$WIREGUARD_PRIVATE" == "" ]] || [[ "$WIREGUARD_PUBLIC" == "" ]]
    then
        # Create.
        wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey

        export WIREGUARD_PRIVATE=$(cat /etc/wireguard/privatekey)
        export WIREGUARD_PUBLIC=$(cat /etc/wireguard/publickey)
    fi

    if [[ -e /etc/wireguard/wg0.conf ]]
    then
        _messageNormal '_server-wireguard: down'
        wg-quick down wg0
    fi

    _messageNormal '_server-wireguard: sysctl'
    ## Enable port forward (if necessary and appropriate).
    if ! cat /etc/sysctl.conf | grep '^net.ipv4.ip_forward=1' > /dev/null 2>&1
    then
        echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
        sysctl -w net.ipv4.ip_forward=1
    fi
    if ! sysctl -a 2>/dev/null | grep '^net.ipv4.ip_forward = 1' > /dev/null 2>&1
    then
        _messagePlain_bad 'bad: FAIL: sysctl: net.ipv4.ip_forward != 1'
        _messageFAIL
    fi
    if sysctl -a 2>/dev/null | grep '^net.ipv4.ip_forward = 1' > /dev/null 2>&1
    then
        _messagePlain_good 'good: sysctl: net.ipv4.ip_forward'
    fi

    _messageNormal '_server-wireguard: config'
    _here_wireguard > /etc/wireguard/wg0.conf
    

    
    _messageNormal '_server-wireguard: up'

    # ATTRIBUTION-AI: ChatGPT 4.5 Deep Research  2025-05-05
    export WG_QUICK_USERSPACE_IMPLEMENTATION="$(command -v wireguard-go || command -v wireguard)"
    export WG_I_PREFER_BUGGY_USERSPACE_TO_POLISHED_KMOD=1

    wg-quick up wg0

    _messageNormal 'done: _server-wireguard'

    _messagePlain_request 'request: VPN Client Public Key: WIREGUARD_PUBLIC='"$WIREGUARD_PUBLIC"


    _stop
}
_server-wireguard() {
    "$scriptAbsoluteLocation" _server_sequence-wireguard "$@"
}







