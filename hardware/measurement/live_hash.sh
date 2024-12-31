
# ATTRIBUTION-AI: ChatGPT o1 2024-12-24 .
_live_hash-getRootBlkDevice()  {
    _if_cygwin && _stop

    local current_root_part
    local current_root_disk
    local current_root_type
    local current_fallback_part
    local current_fallback_disk


    
    # 1) Identify the root mount's source (which might be /dev/sdXn, overlay, etc.)
    current_root_part=$(findmnt -no SOURCE / 2>/dev/null || true)

    # 2) Try to look up the underlying physical disk for that partition/device.
    current_root_disk=$(lsblk -no PKNAME "$current_root_part" 2>/dev/null || true)

    # 3) If lsblk gave us an empty string, there are two main possibilities:
    #    a) $current_root_part is an entire disk (e.g. /dev/sda).
    #    b) The root is an overlay/union FS (e.g., in a Debian Live system).
    if [ -z "$current_root_disk" ]; then
        # 3a) Check if $current_root_part is a whole disk (TYPE='disk'):
        current_root_type=$(lsblk -no TYPE "$current_root_part" 2>/dev/null || true)
        if [ "$current_root_type" = "disk" ]; then
            # $current_root_part is already the whole disk
            current_root_disk=$(basename "$current_root_part")
        fi
    fi

    # 4) If still empty, we suspect an overlay environment. Let's do a fallback to
    #    /lib/live/mount/medium, which Debian Live typically uses as the real device mountpoint.
    if [ -z "$current_root_disk" ] && [ -d "/lib/live/mount/medium" ]; then
        # 4a) Find the block device underlying /lib/live/mount/medium
        current_fallback_part=$(findmnt -n -o SOURCE /lib/live/mount/medium 2>/dev/null || true)

        if [ -n "$current_fallback_part" ]; then
            # 4b) Look up parent disk for current_fallback_part
            current_fallback_disk=$(lsblk -no PKNAME "$current_fallback_part" 2>/dev/null || true)

            # 4c) If current_fallback_disk is still empty, maybe current_fallback_part itself is a whole disk
            if [ -z "$current_fallback_disk" ]; then
            fallback_type=$(lsblk -no TYPE "$current_fallback_part" 2>/dev/null || true)
                if [ "$fallback_type" = "disk" ]; then
                current_fallback_disk=$(basename "$current_fallback_part")
                fi
            fi

            # 4d) If current_fallback_disk is not empty now, that's our current_root_disk
            if [ -n "$current_fallback_disk" ]; then
            current_root_disk="$current_fallback_disk"
            fi
        fi
    fi

    # 5) If still empty, we cannot determine the device.
    if [ -z "$current_root_disk" ]; then
        echo "ERROR: Could not determine the underlying root disk device." >&2
        exit 1
    fi

    echo "/dev/$current_root_disk"
}

# DANGER: CAUTION: ATTENTION: Initial measurement should be done BEFORE connecting computer, USB flash drive, etc, to potentially untrusted networks, peripherials, etc.
#
# For 'live' dist/OS , which is NOT supposed to change the disk contents, this may in theory, frustrate simple 'BadUSB'->dist/OS_filesystem_alteration->'BadUSB' spreading, and hopefully at least drastically reduce the efficiency of attempts at 'smart' firmware/microcontroller/etc reprogramming that sufficiently alters the binary code sequences of booted software on-the-fly in unpredictable environments to spread 'BadUSB' without direct dist/OS_filesystem_alteration .
# Availability is a serious underpinning of Integrity security. Persistent booting with 'SecureBoot', 'IntelTXT', etc, has the downside that if integrity is lost, then this is persistent. Read-only USB flash drives are not only expensive and bulky, but not commercially available (as of 2024) with both FIPS (ie. software) and EAL (ie. hardware) certification. True read-only Optical Disc Drives, are becoming quite rare, are limited in capacity, and are also bulky.
# This is a compromise that is hoped to bring the higher standard of non-persistent yet measured OS security to any available USB flash drive and Linux bootable laptop.
_live_hash_sequence() {
    _start

    _if_cygwin && _stop
    
    local current_root_disk
    current_root_disk=$(_live_hash-getRootBlkDevice)
    _messagePlain_probe_var current_root_disk

    # Attempt to ensure legacy openssl is available.
    # Should do nothing if either openssl legacy is already enabled or if sudo is not available.
	_here_opensslConfig_legacy | sudo -n tee /etc/ssl/openssl_legacy.cnf > /dev/null 2>&1

    if ! sudo -n grep 'openssl_legacy' /etc/ssl/openssl.cnf > /dev/null 2>&1
    then
        sudo -n cp -f /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.orig
        echo '


.include = /etc/ssl/openssl_legacy.cnf

' | sudo -n cat /etc/ssl/openssl.cnf.orig - | sudo -n tee /etc/ssl/openssl.cnf > /dev/null 2>&1
    fi


    _messagePlain_request 'request: Photograph, print, and label computer and USB flash drive with the below.'

    # Speed limit is provided to run as a background process, though this is usually not useful.
    local current_speed
    current_speed="$2"
    [[ "$current_speed" == "" ]] && current_speed="10G"
    sudo -n dd if="$current_root_disk" bs=1M status=progress | pv -q -L "$current_speed" | \
tee >( wc -c /dev/stdin | cut -f1 -d\ | tr -dc '0-9' > "$safeTmp"/.tmp-currentFileBytes ) | \
tee >( openssl dgst -whirlpool -binary | xxd -p -c 256 > "$safeTmp"/.tmp-whirlpool ) | \
tee >( openssl dgst -sha3-512 -binary | xxd -p -c 256 > "$safeTmp"/.tmp-sha3 ) > /dev/null

    echo 'dd if='"$current_root_disk"' bs=1048576 count=$(bc <<< '"'"$(cat "$safeTmp"/.tmp-currentFileBytes)' / 1048576'"'"' ) status=progress | openssl dgst -whirlpool -binary | xxd -p -c 256'
    
    cat "$safeTmp"/.tmp-whirlpool
    
    
    echo 'dd if='"$current_root_disk"' bs=1048576 count=$(bc <<< '"'"$(cat "$safeTmp"/.tmp-currentFileBytes)' / 1048576'"'"' ) status=progress | openssl dgst -sha3-512 -binary | xxd -p -c 256'
    
    cat "$safeTmp"/.tmp-sha3

    _messagePlain_request 'request: Photograph, print, and label computer and USB flash drive with the above.'


    _stop
}
_live_hash() {
    "$scriptAbsoluteLocation" _live_hash_sequence "$@"
}
