#!/bin/bash

# cwc - Check wifi connectivity
# ------------------------------
# Description: The script runs network checks
#              then selects a wifi network and tests it
#
# autor: Fernando Alves - fernandosa@ipt.br


# Variables and functions
t_rede(){ # testar conexão com a Rede
	STATUS=$(nmcli general status| cut -d" " -f1| grep -i "connected")
	
	if [ $(echo $STATUS) == "connected" ]
   then
	   echo "Conectado à Rede"
	   return 1
	else
		echo "Rede desconectada"
		return 0
	fi	
} 

t_wireless(){ # Verifca se a conexão Wireless está ativada
	STATUS=$(nmcli radio wifi)
	if [ $(echo $STATUS) == "enabled" ]
	then
		echo "Wireless on"
		return 0
	else
		echo "Wireless off"
		return 1
	fi
} 

s_rede(){ # Seleciona e conecta a uma rede wifi
	
	if [ $(t_wireless  > /dev/null 2>&1 ; echo $? ) -eq 1 ]
	then
		nmcli radio wifi on
		sleep 5s
	fi
	
		echo "Redes wifi disponíveis:"
		nmcli d wifi list
		read -p "Selecione uma rede Wifi(\"Nome da rede\"): " RWIFI
		nmcli d wifi connect "$RWIFI"
		return 0
	
	
}

t_wifi(){ # Testa o wifi
	SITE="www.lenovo.com.br"
    if [[ $(ping -c1 $SITE > /dev/null 2>&1 ; echo $?) -eq 0 ]]
	then
		echo "Wifi funcionando normalmente"
		return 0
	else
		echo "Error"
		echo "Wifi não está ligado ou não há conexão com a rede"
		return 3
	fi
}

# Start
if [ $(t_rede > /dev/null 2>&1 ;echo $?) -eq 0 ] # Testa se a rede não está conectada e executa as funções
then
	t_rede > log.out # gerar log
	t_wireless > log.out # gerar log
	echo "Buscando redes Wifi disponíveis. . ."
	s_rede
	t_wifi
	exit 0	
else
	zenity --warning --text="Desconecte o cabo Ethernet caso esteja conectado e re-execute o script"
	nmcli radio wifi off
	exit 4
fi
