
# jehon-service-network

Context: servers
Objectif: 
  - have a fixed ip adress
  - be a wifi access point

## SystemD-NetworkD

https://www.debian.org/doc/manuals/debian-reference/ch05.en.html

Bridge: 
https://wiki.archlinux.org/title/Network_bridge

Wifi:
https://unix.stackexchange.com/questions/401533/making-hostapd-work-with-systemd-networkd-using-a-bridge
https://hackaday.io/project/162164/instructions?page=2


## Unknown:

echo 1 >/proc/sys/net/ipv6/conf/all/forwarding
echo 1 >/proc/sys/net/ipv6/conf/all/autoconf

# https://serverfault.com/q/690954/275843

sysctl -p
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.all.accept_ra = 2
net.ipv6.conf.all.accept_redirects = 1
net.ipv6.conf.all.accept_source_route = 1
