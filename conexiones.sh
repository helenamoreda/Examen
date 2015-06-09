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
	#Creamos un segundo log que compruebe las conexiones para poder compararlo con el log1
	echo `netstat -plan | grep "ESTABLECIDO" |grep -e ":80" -e ":443" -e ":21" | awk {'print $5'} | uniq > /root/.jvscripts/logsconexiones/log2.txt`
	#Contamos sus líneas para poder compararlas con el log1
	contador2=`wc -l /root/.jvscripts/logsconexiones/log2.txt | cut -d " " -f1`

	
	#En el caso de que los contadores sean distintos quiere decir que hay una conexión nueva y debe mandar una alerta al servidor
	if [ "$contador" != "$contador2" ]
		then
			#Si el primer contador es menor que el segundo:
			if [ $contador -lt $contador2 ]
				then
					#Almacenamos la nueva conexión en el log1 
					echo `netstat -plan | grep "ESTABLECIDO" |grep -e ":80" -e ":443" -e ":21" | awk {'print $5'} | uniq > /root/.jvscripts/logsconexiones/log.txt`
					
					#Cogemos la ip del usuario
					IPuser=`/sbin/ifconfig ${iface} | grep 'inet' | cut -d: -f2 | cut -d " " -f1 | grep -v 127`
				
					#Almacenamos en la variable “conexion” la última conexión producida en el log para enviarla en la alerta. Tail -n 1 muestra la última línea de un archivo.
					conexion=`tail -n 1 /root/.jvscripts/logsconexiones/log.txt`
					
					#Llamamos al script “netcat.sh” para que se conecte al servidor y envíe nuestra alerta como argumento
					bash /root/.jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha iniciado una conexión a esta IP $conexion  "
					
					#Guardamos todas las conexiones que se produzcan en un log final para poder consultarlo posteriormente
					echo "El equipo `hostname` con IP $IPuser con fecha `date` ha iniciado una conexión a esta IP $conexion " >>  /root/.jvscripts/logsconexiones/logfinal.txt
				else
					#En el caso de que hayan más líneas en $contador quiere decir que se ha cerrado una conexión y por ello mandamos una alerta.
					bash /root/.jvscripts/netcat.sh "El equipo `hostname` con IP $IPuser con fecha `date` ha cerrado una conexión"
			fi
			contador=$contador2
	fi
	#En el caso de que no se haya producido ningún cambio en las conexiones espera 5 segundos y vuelve a entrar en el bucle
	sleep 5s
done
