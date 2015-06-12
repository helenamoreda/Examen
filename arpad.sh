#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: arpad.sh
#Versión:09-04-2015
#Resumen: script que comprueba cada 5 minutos si la mac de nuestro router ha cambiado y nos avisa mediante una ventana emergente en el caso de un posible caso de ataque Man in the Middle.


#Obtengo la ip del router donde:
# -n Muestra la tabla de enrutamiento en formato numérico [dirección IP]
# tr -s quita los espacios
# cut corta la segunda columna
iprouter=`sudo route -n|grep UG |tr -s " "|cut -d " " -f2`

#Obtengo la mac del router
macrouter=`sudo arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`


if [ ! -f /etc/mac_router.txt ];
	then
		sudo touch /etc/mac_router.txt
		sudo echo $macrouter > /etc/mac_router.txt
fi
	

comprobar=`sudo arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`
mac=`sudo cat /etc/mac_router.txt`
	if [ "$mac" != "$comprobar" ]
		then
			xhost local:
			DISPLAY=:0 zenity --warning --text="La mac del router ha cambiado, es posible que esté siendo víctima de un ataque Man in the middle. Su anterior mac era $mac"
			break

	





