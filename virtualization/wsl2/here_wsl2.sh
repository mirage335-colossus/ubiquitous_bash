
_here_wsl_config() {
# ATTENTION: If nested virtualization configuration is necessary (ie. the apparently now default 'nestedVirtualization=true' directive is somehow not already in effect), this may be a better place for that directive (normally writing a '.wslconfig' file).
#[wsl2]
#nestedVirtualization=true
    cat << 'CZXWXcRMTo8EmM8i4d'
[wsl2]
memory=999GB
kernelCommandLine = "sysctl.net.core.bpf_jit_harden=1"

CZXWXcRMTo8EmM8i4d

    if [[ -e /cygdrive/c/core/infrastructure/ubdist-kernel/ubdist-kernel ]] && [[ "$1" != "ub_ignore_kernel_wsl" ]]
    then
        echo 'kernel=C:\\core\\infrastructure\\ubdist-kernel\\ubdist-kernel'
    fi

    echo
}


_here_wsl_conf() {
# ATTENTION: Directive for nested virtualization may have moved to being more appropriate for a host '.wslconfig' file than a guest '/etc/wsl.conf' file .
#[wsl2]
#nestedVirtualization=true
    cat << 'CZXWXcRMTo8EmM8i4d'

[boot]
systemd = true
command = /bin/bash -c 'systemctl stop sddm ; rm -f /root/_rootGrab.sh ; usermod -a -G kvm user ; chown -v root:kvm /dev/kvm ; chmod 660 /dev/kvm ; ( rm /home/user/___quick/mount.sh ; rmdir /home/user/___quick ; ( [[ ! -e /home/user/___quick ]] && ln -s /mnt/c/q /home/user/___quick ) ; rm -f /home/user/___quick/q )'

[user]
default = user

[automount]
options = "metadata"

CZXWXcRMTo8EmM8i4d
}


