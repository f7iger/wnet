#!/bin/bash

##
# wnet.sh
# Choose and connect to a wireless network from the command line
# No need for root privileges
# Author @f7iger
##



echo -e "Searching networks avaliable\r\n-----------------------------------"
sleep 3s
nmcli d wifi list | awk -F' ' '{print $2}'| sed -r 's/BSSID/Networks available:\r\n/'

echo "-----------------------------------"

read -p "Enter the name of the chosen network: " CHOICE
read -p "Enter the network password: " SENHA

nmcli d wifi connect "$CHOICE" password "$SENHA"
