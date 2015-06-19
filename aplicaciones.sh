#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: aplicaciones.sh
#Versión:14-05-2015
#Resumen: Script que envía una alerta a con netcat al servidor a través del puerto 3333 en el caso de que
# se ejecute una determinada aplicación.

#Borramos los logs que ya existían
if test -f /root/.jvscripts/logsapps/apps.txt
	then
		rm /root/.jvscripts/logsapps/apps.txt
fi


#-e "geany"

#Condicion para entrar en el bucle
opcion=0

while [ $opcion -eq 0 ];
do
	#Buscamos con ps los procesos cuyo nombres coincidan con las aplicaciones que no estarán permitidas en los exámenes y los metemos en el log de aplicaciones.
	echo `ps -A | grep -w -e "firefox" -e "evince" -e "empathy"  -e "gedit" -e "vi" -e "nano" -e "soffice.bin" | awk {'print $4'} | sort | uniq  > /root/.jvscripts/logsapps/apps.txt`

#Si el log de las aplicaciones no está vacío, leemos línea a línea las apps abiertas y matamos su proceso
if test -s /root/.jvscripts/logsapps/apps.txt
	then
		while read linea
		do
			#Matamos el proceso
			killall $linea 
			#Cogemos la IP del equipo
			IPuser=`/sbin/ifconfig ${iface} | grep 'inet' | cut -d: -f2 | cut -d " " -f1 | grep -v 127`
			killall $linea 
			#Ejecutamos el script de nectat y enviamos la alerta como argumento
			sh /root/.jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha abierto la app: $linea "
			#Guardamos todas las conexiones que se produzcan en un log final para poder consultarlo posteriormente
			echo "El equipo `hostname` con IP $IPuser con fecha `date` ha abierto la app: $linea " >> /root/.jvscripts/logsapps/logfinal.txt
			killall $linea
		done < /root/.jvscripts/logsapps/apps.txt
 	else
 		#En el caso de que el fichero esté vacío hacemos que espere 5 segundos 
		sleep 5s	
fi
done
