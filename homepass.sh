#!/bin/sh
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/jffs/sbin:/jffs/bin:/jffs/usr/sbin:/jffs/usr/bin:/mmc/sbin:/mmc/bin:/mmc/usr/sbin:/mmc/usr/bin:/opt/sbin:/opt/bin:/opt/usr/sbin:/opt/usr/bin

relay_time="90"
wifi="eth1"
wl_mac=`nvram get wl0_hwaddr`
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

spoofMacAddress() {
    ifconfig ${wifi} down
    ifconfig ${wifi} hw ether $1
    ifconfig ${wifi} up
    wl radio on

    sleep ${relay_time}

    wl radio off
}

cleanup() {
    ifconfig ${wifi} down
    ifconfig ${wifi} hw ether ${wl_mac}
    ifconfig ${wifi} up
    
    wl radio off

    return 0
}

for i in $mac_list
do
    echo "Spoofing ${wifi} to $i for ${relay_time} seconds..."
###    spoofMacAddress "$i"
done

echo "Restoring ${wifi} to ${wl_mac}"
cleanup
