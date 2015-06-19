#!/bin/bash
#Autora: Helena Moreda Boza
#Fichero: servidor.sh
#Versión:19-05-2015
#Resumen: Script que comprueba si tenemos conexión con el servidor a través del puerto 3333. En caso de que tengamos conexión arrancará los scripts de “aplicaciones.sh” y “conexiones.sh”. 

#Variable que almacena la IP fija que tiene el servidor
IPservidor="192.168.1.177"


#Comprobamos el si tenemos conexión y guardamos el resultado en una variable
estado=`nmap $IPservidor -p 3333 | grep 3333`

#Guardamos en el estado que nos aparecería en el caso de que tengamos conexión
estado2="3333/tcp open  dec-notes"


#Si el estado actual coincide con el estado de conexión abierta:
if [ "$estado" == "$estado2" ];
	then
		#Como este script se ejecuta cada 5 minutos, primero matamos los procesos anteriores
		killall conexiones.sh
		killall aplicaciones.sh
		killall comprobacion.sh
		killall sleep
		#Ejecutamos en segundo plano los scripts
		/root/.jvscripts/conexiones.sh &
		/root/.jvscripts/aplicaciones.sh &
		/root/.jvscripts/comprobacion.sh &
	else
		#Si no tenemos conexión con el servidor, simplemente matamos los procesos
		killall aplicaciones.sh
		killall conexiones.sh
		killall sleep
fi
