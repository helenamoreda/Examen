#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: aplicaciones.sh
#Versión:14-05-2015
#Resumen: Script que envía una alerta a con netcat al servidor a través del puerto 3333 en el caso de que
# se ejecute una determinada aplicación.

if test -f /root/jvscripts/apps.txt
	then
		rm /root/jvscripts/apps.txt
fi

#-e "geany"

opcion=0

while opcion=0
do

echo `ps -A | grep -w -e "chrome" -e "firefox" -e "evince" -e "empathy"  -e "gedit" -e "vi" -e "nano" -e "soffice.bin" | awk {'print $4'} > /root/jvscripts/apps.txt`

if test -s /root/jvscripts/apps.txt
	then
		IPuser=`/sbin/ifconfig ${iface} | grep 'inet' | cut -d: -f2 | cut -d " " -f1 | grep -v 127`
		app=`tail -n 1 apps.txt`
		sudo sh /root/jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha abierto la app: $app "
		killall $app 
 	else
		sleep 5s	
fi
done
