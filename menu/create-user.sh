#!/bin/bash
#Script auto create trial user SSH

read -p "Username : " uname
read -p "Password : " pass
read -p "Expired (hari): " masaaktif

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "Informasi SSH"
echo -e "=========-account-=========="
echo -e "Host: $IP" 
echo -e "Port dropbear: 443"
echo -e "Port openVPN: 22"
echo -e "Username: $uname"
echo -e "Password: $pass"
echo -e "-----------------------------"
echo -e "Aktif Sampai: $exp"
echo -e "==========================="
echo -e "Script by MuLuu09"
echo -e "Team: MappakkoE Vpn/SSH"
