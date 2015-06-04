#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: aplicaciones.sh
#Versión:09-04-2015
#Resumen: script que 


#Obtengo la ip del router donde:
# -n Muestra la tabla de enrutamiento en formato numérico [dirección IP]
# tr -s quita los espacios
# cut corta la segunda columna
iprouter=`route -n|grep UG |tr -s " "|cut -d " " -f2`

#Obtengo la mac del router donde:

macrouter=`arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`

if test -f /etc/mac_router.txt
	then 
		echo $macrouter > /etc/mac_router.txt	
else
	touch /etc/mac_router.txt
	echo $macrouter > /etc/mac_router.txt
	
fi
	
opcion=0
while [ $opcion == 0 ] 
do
comprobar=`arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`
mac=`cat /etc/mac_router.txt`
	if [ "$mac" != "$comprobar" ]
		then
			`zenity --warning --text="La mac del router ha cambiado"`
	fi
	sleep 2m
done
	





