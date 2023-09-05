
_here_wsl_config() {
    cat << 'CZXWXcRMTo8EmM8i4d'
[wsl2]
memory=999GB
CZXWXcRMTo8EmM8i4d

    if [[ -e /cygdrive/c/core/infrastructure/ubdist-kernel/ubdist-kernel ]] && [[ "$1" != "ub_ignore_kernel_wsl" ]]
    then
        echo 'kernel=C:\\core\\infrastructure\\ubdist-kernel\\ubdist-kernel'
    fi

    echo
}


_here_wsl_conf() {
    cat << 'CZXWXcRMTo8EmM8i4d'

[boot]
systemd = true
command = /bin/bash -c 'systemctl stop sddm ; rm -f /root/_rootGrab.sh ; usermod -a -G kvm user ; chown -v root:kvm /dev/kvm ; chmod 660 /dev/kvm ; ( rm /home/user/___quick/mount.sh ; rmdir /home/user/___quick ; ( [[ ! -e /home/user/___quick ]] && ln -s /mnt/c/q /home/user/___quick ) ; rm -f /home/user/___quick/q )'

[user]
default = user

[wsl2]
nestedVirtualization=true

[automount]
options = "metadata"

CZXWXcRMTo8EmM8i4d
}


