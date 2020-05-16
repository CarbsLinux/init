#!/bin/sh
# shellcheck disable=1090,1091,2174

# Read the configuration file and the library fo
# common functions.
. /etc/init/rc.conf
. /usr/lib/init/rc.lib

mnt() {
    while read -r _ mnt _; do
        case "$mnt" in "$1") return 0; esac
    done < /proc/mounts

    mnt="$1"; shift
    mount "$@" "$mnt"
}

# Manually set path
PATH=$PATH:/usr/bin:/usr/local/bin

# Display a pretty welcome message
printf '\033[1;36m-> \033[39mWelcome to \033[35mCarbs %s\033[39m!\033[m\n' "$(uname -s)"

out "Mounting pseudo filesystems..."; {
    mnt /proc -o nosuid,noexec,nodev    -t proc     proc
    mnt /sys  -o nosuid,noexec,nodev    -t sysfs    sys
    mnt /run  -o mode=0755,nosuid,nodev -t tmpfs    run
    mnt /dev  -o mode=0755,nosuid       -t devtmpfs dev

    mkdir -pm 0755 \
                   /run/lvm   \
                   /run/user  \
                   /run/lock  \
                   /run/log   \
                   /dev/pts   \
                   /dev/shm

    command -v runsvdir >/dev/null 2>&1 && mkdir -pm 0755 /run/runit

    mnt /dev/pts -o mode=0620,gid=5,nosuid,noexec -nt devpts     devpts
    mnt /dev/shm -o mode=1777,nosuid,nodev        -nt tmpfs      shm
}

[ "$dmesg_level" ] && {
    out "Setting dmesg level..."
    dmesg -n$dmesg_level
}

command -v udevd >/dev/null && {
    out "Starting eudev..."
    udevd --daemon
    udevadm trigger --action=add --type=subsystems
    udevadm trigger --action=add --type=devices
    udevadm settle
}

out "Remounting rootfs as read-only..."; {
    mount -o remount,ro / || shell
}

out "Checking filesystems..."; {
    fsck -ATat noopts=_netdev
    [ $? -gt 1 ] && shell
}

out "Mounting rootfs read-write..."; {
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

out "Seeding random..."; {
    if [ -f /var/random.seed ]; then
        cat /var/random.seed > /dev/urandom
    else
        out "This may hang."
        out "Mash the keyboard to generate entropy..."

        dd count=1 bs=512 if=/dev/random of=/var/random.seed
    fi
}

out "Setting up loopback..."; {
    ip link set up dev lo
}

out "Setting hostname..."; {
    read -r hostname < /etc/hostname
    printf '%s\n' "${hostname:-carbs-linux}" > /proc/sys/kernel/hostname
} 2>/dev/null

[ "$keymap" ] && {
    out "Loading keymap settings..."
    loadkmap < "$keymap"
}

out "Loading sysctl settings..."; {
    find /run/sysctl.d \
         /etc/sysctl.d \
         /usr/local/lib/sysctl.d \
         /usr/lib/sysctl.d \
         /lib/sysctl.d \
         /etc/sysctl.conf \
         -name \*.conf -type f 2>/dev/null \
    | while read -r conf; do
        seen="$seen ${conf##*/}"

        case $seen in
            *" ${conf##*/} "*) ;;
            *) printf '%s\n' "* Applying $conf ..."
               sysctl -p "$conf" ;;
        esac
    done
}


command -v udevd >/dev/null &&
    udevadm control --exit


run_hook boot

out "Running rc.local..."; {
	[ -r "/etc/init/rc.local" ] && \
		. /etc/init/rc.local
}


out "Boot stage complete..."
