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

[pi4]

# Disable the PWR LED

dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off

# Disable the Activity LED

dtparam=act_led_trigger=none
dtparam=act_led_activelow=off

# Disable ethernet port LEDs

dtparam=eth_led0=4
dtparam=eth_led1=4
