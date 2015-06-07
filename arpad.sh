#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: aplicaciones.sh
#Versión:09-04-2015
#Resumen: script que 


#Obtengo la ip del router donde:
# -n Muestra la tabla de enrutamiento en formato numérico [dirección IP]
# tr -s quita los espacios
# cut corta la segunda columna
iprouter=`sudo route -n|grep UG |tr -s " "|cut -d " " -f2`

#Obtengo la mac del router donde:

macrouter=`sudo arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`

if test -f /etc/mac_router.txt
	then 
		echo ""	
else
	sudo touch /etc/mac_router.txt
	sudo echo $macrouter > /etc/mac_router.txt
	
fi
	
opcion=0
while [ $opcion -eq 0 ];
do
comprobar=`sudo arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`
mac=`sudo cat /etc/mac_router.txt`
	if [ "$mac" != "$comprobar" ]
		then
			xhost local:
			DISPLAY=:0 zenity --warning --text="La mac del router ha cambiado, es posible que esté siendo víctima de un ataque Man in the middle. Su anterior mac era $mac"
	fi
done
	





