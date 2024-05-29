# Raspberry PI

## Root over samba

/boot/cmdline.txt:

console=serial0,115200 console=tty1 root=/dev/nfs nfsroot=<host>:/<path>,tcp rw rootfstype=nfs vers=3 ip=dhcp elevator=deadline rootwait

## Power

In /boot/config.txt
(see https://www.raspberrypi.com/documentation/computers/config_txt.html)

[all]
dtoverlay=disable-wifi
dtoverlay=disable-bt
