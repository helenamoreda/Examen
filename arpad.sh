#!/bin/bash

<<<<<<< HEAD
#Autora: Helena Moreda Boza
#Fichero: aplicaciones.sh
#Versión:09-04-2015
#Resumen: script que 

=======
#Helena Moreda Boza

#arpad
>>>>>>> 863871f72b9918a32672141ec2f68536584667e7

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
while [ $opcion = 0 ] 
do
comprobar=`arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`
mac=`cat /etc/mac_router.txt`
	if [ $mac != $comprobar ]
		then
<<<<<<< HEAD
			`zenity --warning --text="La mac del router ha cambiado"`
=======
			`zenity --warning --text="La mac ha cambiado"`
>>>>>>> 863871f72b9918a32672141ec2f68536584667e7
	fi
	sleep 2m
done
	





