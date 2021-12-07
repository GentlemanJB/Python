#!/bin/bash

	#Portas Mais Comuns
	PortsComun="20 21 22 23 25 53 80 110 111 135 139 143 443 445 993 995 1723 3306 3389 5900 8080"
	
	#Recebe o 2º argumento 
	PORTS=$2

	scan(){
		timeout 2 bash -c "echo > /dev/tcp/$1/$2" && echo "Port $2 is open" || echo "Port $2 is closed"
	}

	scan_list(){
		for port in $2;
		do
		scan $1 $port
		done	
	}

	scan_range(){
		for ((port=$2; port <= $3; port++));
		do
		scan $1 $port
		done
	}

	if [ $# == 0 ]; then #Não tem parametros

		echo "No arguments were checked for using this funcion."
		echo "Specify the host and ports to check as in the example below."
		echo "bash Portscan.sh <host> <Port> or <Port1 Port2 Port3 ...> or <port-port x> or <TOPPORT> or <ALL>"

	elif [ $# == 1 ]; then #Só  tem um dos parametros

		echo "Miss one argument."
		echo "Specify the host or ports to check as in the example below."
		echo "bash Portscan.sh <host> <Port> or <Port1 Port2 Port3 ...> or <port-port x> or <TOPPORT> or <ALL>"

	elif [ $# == 2 ]; then #Tem todos os parametros, vamos ver qual é o tipo de scan

		if [[ $2 == *"-"* ]]; then #Range de Portas 

		Port_Start=$(echo "$2" | awk -F - '{print $1}')
		Port_End=$(echo "$2" | awk -F - '{print $2}')

		scan_range $1 $Port_Start $Port_End
		
		elif [ $2 == "TOPPORT" ]; then  #Pesquisa pelas portas mais usadas

		scan_list $1 "$PortsComun"

		elif [ $2 == "ALL" ]; then #Pesquisa por todas as portas

		Port_Start="1"
		Port_End="65535"		

		scan_range $1 $Port_Start $Port_End

		else
		
		scan_list $1 "$2"
		fi
	fi

	


	      

