#!/bin/bash

# install openvpn
apt-get install openvpn -y
wget -O /etc/openvpn/openvpn.tar "https://raw.github.com/mappakkoe09/debian/master/conf/ovpn.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/56.conf "https://raw.github.com/mappakkoe09/debian/master/conf/56.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
wget -O /etc/iptables.conf "https://raw.github.com/mappakkoe09/debian/master/conf/iptables.conf"
sed -i '$ i\iptables-restore < /etc/iptables.conf' /etc/rc.local

myip2="s/ipserver/$myip/g";
sed -i $myip2 /etc/iptables.conf;

iptables-restore < /etc/iptables.conf
service openvpn restart
