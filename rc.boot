#!/bin/sh
# shellcheck disable=1090,1091,2174

# Read the configuration file and the library of
# common functions.
. /usr/lib/init/rc.lib
[ -f /etc/init/rc.conf ] && . /etc/init/rc.conf

# Display a pretty welcome message
printf '\033[1;36m-> \033[39mWelcome to \033[35mCarbs %s\033[39m!\033[m\n' "$(uname -s)"

out "Mounting pseudo filesystems..."; {
    mnt nosuid,noexec,nodev    proc     proc /proc
    mnt nosuid,noexec,nodev    sysfs    sys  /sys
    mnt mode=0755,nosuid,nodev tmpfs    run  /run
    mnt mode=0755,nosuid       devtmpfs dev  /dev

    mkdir -pm 0755 \
                   /run/lvm   \
                   /run/user  \
                   /run/lock  \
                   /run/log   \
                   /dev/pts   \
                   /dev/shm

    command -v runsvdir >/dev/null 2>&1 && mkdir -pm 0755 /run/runit

    mnt mode=0620,gid=5,nosuid,noexec devpts devpts /dev/pts
    mnt mode=1777,nosuid,nodev        tmpfs  shm    /dev/shm
}

out "Parsing kernel commandline..."; {
    parse_cmdline
}

[ "$dmesg_level" ] && {
    out "Setting dmesg level..."
    dmesg -n$dmesg_level
}

out "Starting device manager..."; {
    device_helper settle
}

out "Remounting rootfs as read-only..."; {
    mount -o remount,ro / || shell
}

[ "$FASTBOOT" = 1 ] || {
    out "Checking filesystems..."
    fsck "-ATat${FORCEFSCK}" noopts=_netdev 2>&1 | log
    [ $? -gt 1 ] && shell
}

[ "$RO" = "1" ] || {
    out "Mounting rootfs read-write..."
    mount -o remount,rw / || shell
}

out "Mounting all local filesystems..."; {
    mount -at nosysfs,nonfs,nonfs4,nosmbfs,nocifs -O no_netdev ||
        shell
}

run_hook early-boot

out "Enabling swap..."; {
    swapon -a || shell
}

# Load random seed
random load

out "Setting up loopback..."; {
    ip link set up dev lo
}

out "Setting hostname..."; {
    read -r hostname < /etc/hostname
    printf '%s\n' "${hostname:-carbslinux}" > /proc/sys/kernel/hostname
} 2>/dev/null

[ "$keymap" ] && {
    out "Loading keymap settings..."
    loadkmap < "$keymap"
}

out "Loading sysctl settings..."; {
    for conf in \
        /run/sysctl.d/*.conf \
        /usr/lib/sysctl.d/*.conf \
        /etc/sysctl.d/*.conf \
        /etc/sysctl.conf; do

        [ -f "$conf" ] || continue
        out "Appling $conf ..."
        sysctl -p "$conf"
    done
}


out "Stopping device manager..."; {
    device_helper exit
}

run_hook boot

# rc.local is deprecated and will be removed in
# a month. You should switch to boot hooks
out "Running rc.local..."; {
[ -r "/etc/init/rc.local" ] && \
    . /etc/init/rc.local
}


out "Boot stage complete..."
