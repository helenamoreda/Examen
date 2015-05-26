#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: aplicaciones.sh
#Versión:14-05-2015
#Resumen: Script que envía una alerta a con netcat al servidor a través del puerto 3333 en el caso de que
# se ejecute una determinada aplicación.

if test -f /root/.jvscripts/logsapps/apps.txt
	then
		rm /root/.jvscripts/logsapps/apps.txt
fi

if test -f /root/.jvscripts/logsapps/PID.txt
	then
		rm /root/.jvscripts/logsapps/PID.txt
fi

echo $$ > /root/.jvscripts/logsapps/PID.txt
#-e "geany"

opcion=0

while opcion=0
do

	echo `ps -A | grep -w -e "chrome" -e "firefox" -e "evince" -e "empathy"  -e "gedit" -e "vi" -e "nano" -e "soffice.bin" | awk {'print $4'} > /root/.jvscripts/logsapps/apps.txt`

if test -s /root/.jvscripts/logsapps/apps.txt
	then
		IPuser=`/sbin/ifconfig ${iface} | grep 'inet' | cut -d: -f2 | cut -d " " -f1 | grep -v 127`
		chmod 777 /root/.jvscripts/logsapps/apps.txt
		app=`tail -n 1 /root/.jvscripts/logsapps/apps.txt`
		sh /root/.jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha abierto la app: $app "
		killall $app 
 	else
		sleep 5s	
fi
done
