#!/bin/sh
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/jffs/sbin:/jffs/bin:/jffs/usr/sbin:/jffs/usr/bin:/mmc/sbin:/mmc/bin:/mmc/usr/sbin:/mmc/usr/bin:/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin

max=5
relay_time="90"
sleep_time="10"

mac_list="00:0D:67:15:2D:82
00:0D:67:15:D7:21
00:0D:67:15:D5:44
00:0D:67:15:D2:59
00:0D:67:15:D6:FD
4E:53:50:4F:4F:40
4E:53:50:4F:4F:41
4E:53:50:4F:4F:42
4E:53:50:4F:4F:43
4E:53:50:4F:4F:44
4E:53:50:4F:4F:45
4E:53:50:4F:4F:46
4E:53:50:4F:4F:47
4E:53:50:4F:4F:48
4E:53:50:4F:4F:49
4E:53:50:4F:4F:4A
4E:53:50:4F:4F:4B
4E:53:50:4F:4F:4C
4E:53:50:4F:4F:4D
4E:53:50:4F:4F:4E
4E:53:50:4F:4F:4F"

wifi=$(nvram get wl0_ifname)
wl_mac=$(nvram get wl0_hwaddr)

ctrl_c() {
    echo "*** Interrupted ***"
    cleanup
    exit $?
}

spoof() {
    echo "Spoofing ${wifi} to $1 for ${relay_time} seconds..."
    wl radio off
    ifconfig ${wifi} down
    ifconfig ${wifi} hw ether $1
    ifconfig ${wifi} up
    sleep ${sleep_time}
    wl radio on

    sleep ${relay_time}

    wl radio off
}

cleanup() {
    echo "Restoring ${wifi} to ${wl_mac}"
    wl radio off
    ifconfig ${wifi} down
    ifconfig ${wifi} hw ether ${wl_mac}
    ifconfig ${wifi} up

    return 0
}

trap ctrl_c SIGINT SIGTERM

sel=$(echo "$mac_list" | awk -v n=\"$max\" 'BEGIN{ srand(); } { a[i++]=$0 } END { while(j<$n) { r=int(rand()*i); if( r in a ) { print a[r]; delete a[r]; j++; } } }')
for i in $sel
do
    spoof "$i"
done

cleanup
