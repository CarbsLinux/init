for getty in 1 2 3 4 5 6; do
    while :; do /sbin/getty 38400 tty${getty} 2>&1 ; done &  # busybox getty
    while :; do /sbin/getty /dev/tty${getty} linux 2>&1 ; done &  # ubase getty
done
