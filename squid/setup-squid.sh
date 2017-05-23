#!/bin/bash
# editor: elang overdosis
# Copyright 2012 (c) elang
# 
# Revisi 1:
# Penambahan config agar proxy menjadi super elite
#   header_access Via deny all
#	header_access Forwarded-For deny all
# 	header_access X-Forwarded-For deny all
# 


function baca_port {
    echo -n "Masukkan port untuk squid: "
    read port

	if [[ "$port" =~ ^[0-9]+$ ]] ; then
		echo "http_port $port transparent" >> /tmp/squid.conf.tmp1
		baca_port_lagi
	else
		echo -e "\e[1;31mInput salah!\e[0m"
		baca_port
	fi
}



function baca_port_lagi {
	echo -n "Masukkan port lain untuk squid atau Ketik \"n\" untuk melanjutkan: "
	read port

	if [[ "$port" =~ ^[0-9]+$ ]] ; then
		echo "http_port $port transparent" >> /tmp/squid.conf.tmp1
		baca_port_lagi
	else
		if [ "$port" = "n" ]; then
			echo -e "\e[1;33mInstalasi squid!\e[0m"
		else
			echo -e "\e[1;31mInput salah!\e[0m"
			baca_port_lagi
		fi
	fi
}

function preinstall_squid {
	DEBIAN_FRONTEND=noninteractive apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -q -y remove --purge squid squid3
	DEBIAN_FRONTEND=noninteractive apt-get -q -y install squid3
	mv /etc/squid3/squid.conf /etc/squid3/squid.conf.bak
	cat > /tmp/squid.conf.tmp2 <<END
cache allow all
via off
httpd_suppress_version_string    on
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst ipserver/255.255.255.255
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localnet
http_access allow localhost
http_access deny all
http_port 8080
hierarchy_stoplist cgi-bin ?
coredump_dir /var/spool/squid
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320
visible_hostname deenie.com
END
	
	cat /tmp/squid.conf.tmp2 /tmp/squid.conf.tmp1	> /etc/squid3/squid.conf	
	service squid3 restart 
}


echo "******************************************************************"
echo "*                                                                *"
echo "*                   INSTALLASI SQUID PROXY                            *"
echo "*        HARAP ISI DENGAN BENAR by Elang overdosis                *"
echo "*                                                                *"
echo "******************************************************************"

echo ""
echo ""

baca_port
preinstall_squid
