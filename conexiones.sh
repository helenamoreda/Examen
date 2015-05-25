#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: conexiones.sh
#Versión:04-05-2015
#Resumen: Script que envía una alerta a con netcat al servidor a través del puerto 3333 en el caso de que
# se produzca una nueva conexión por el puerto 80, 443 o 21.


#Comprobamos si existen los logs y en el caso de que existan los borramos
if test -f /root/.jvscripts/logsconexiones/log.txt
	then
		rm /root/.jvscripts/logsconexiones/log.txt
fi

if test -f /root/.jvscripts/logsconexiones/log2.txt
	then
		rm /root/.jvscripts/logsconexiones/log2.txt
fi

if test -f /root/.jvscripts/logsconexiones/PID.txt
	then
		rm /root/.jvscripts/logsconexiones/PID.txt
fi

#Guardo el PID del demonio en un txt
echo $$ > /root/.jvscripts/logsconexiones/PID.txt


#El comando NETSTAT muestra un listado de las conexiones activas del servidor, con GREP filtramos sólo 
# las conexiones establecidas al puerto 80, 443 ó 21. Con AWK filtramos para que muestre solamente el contenido
# de la columna 5 (en este caso la IP) de la salida por pantalla y con UNIQ eliminamos filas repetidas. Todo esto
# lo metemos en el archivo log.txt y contamos sus líneas con wc -l.

echo `netstat -plan | grep "ESTABLECIDO" |grep -e ":80" -e ":443" -e ":21" | awk {'print $5'} | uniq >> /root/.jvscripts/logsconexiones/log.txt`
contador=`wc -l /root/.jvscripts/logsconexiones/log.txt  | cut -d " " -f1`

#Condición para entrar en el bucle:
opcion=0

#Entrada del bucle
while [ $opcion = 0 ] 
do
	echo `netstat -plan | grep "ESTABLECIDO" |grep -e ":80" -e ":443" -e ":21" | awk {'print $5'} | uniq > /root/.jvscripts/logsconexiones/log2.txt`
	contador2=`wc -l /root/.jvscripts/logsconexiones/log2.txt | cut -d " " -f1`

	if [ "$contador" != "$contador2" ]
		then
			if [ $contador -lt $contador2 ]
				then
					echo `netstat -plan | grep "ESTABLECIDO" |grep -e ":80" -e ":443" -e ":21" | awk {'print $5'} | uniq > /root/.jvscripts/logsconexiones/log.txt`
					IPuser=`/sbin/ifconfig ${iface} | grep 'inet' | cut -d: -f2 | cut -d " " -f1 | grep -v 127`
					conexion=`tail -n 1 /root/.jvscripts/logsconexiones/log.txt`
					bash /root/.jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha iniciado una conexión a esta IP $conexion  "
					
				else
					bash /root/.jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha cerrado una conexión"
			fi
			contador=$contador2
	fi
	sleep 5s
done
