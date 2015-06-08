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


#-e "geany"


opcion=0

while [ $opcion -eq 0 ];
do

	echo `ps -A | grep -w -e "chrome" -e "chrome-sandbox" -e "firefox" -e "evince" -e "empathy"  -e "gedit" -e "vi" -e "nano" -e "soffice.bin" | awk {'print $4'} | sort | uniq  > /root/.jvscripts/logsapps/apps.txt`

if test -s /root/.jvscripts/logsapps/apps.txt
	then
		while read linea
		do
			killall $linea 
			IPuser=`/sbin/ifconfig ${iface} | grep 'inet' | cut -d: -f2 | cut -d " " -f1 | grep -v 127`
			killall $linea 
			#app=`tail -n 1 /root/.jvscripts/apps.txt`
			sh /root/.jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha abierto la app: $linea "
			echo "El equipo `hostname` con IP $IPuser con fecha `date` ha abierto la app: $linea " >> /root/.jvscripts/logsapps/logfinal.txt
			killall $linea
		done < /root/.jvscripts/logsapps/apps.txt
 	else
		sleep 5s	
fi
done
