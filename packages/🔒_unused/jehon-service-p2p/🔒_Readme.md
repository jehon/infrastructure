
# jehon-service-p2p

Run as "debian-transmission"
 (see ps -af | grep trans)

## Mount

/dev/sda1       /mnt/usb1       ext4    defaults,nofail 0       2

mv /var/lib/transmission-daemon/ /mnt/usb1/
ln -sfn /mnt/usb1/transmission-daemon /var/lib/transmission-daemon

## Tutorial

https://pimylifeup.com/raspberry-pi-transmission/

## Watch ?

https://forum.transmissionbt.com/viewtopic.php?t=7630

## Web
Port: 9091

