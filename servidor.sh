#!/bin/bash


if test -f /root/.jvscripts/servidor/conexion.txt
	then
		rm /root/.jvscripts/servidor/conexion.txt
fi

IPservidor="192.168.0.235"

nmap $IPservidor -p 3333 | grep 3333 > /root/.jvscripts/servidor/conexion.txt

estado=`cat /root/.jvscripts/servidor/conexion.txt`
estado2="3333/tcp open  dec-notes"
estado3="3333/tcp closed  dec-notes"

if [ "$estado" == "$estado2" ];
	then
		killall conexiones.sh
		killall aplicaciones.sh
		killall comprobacion.sh
		killall servicio-conexiones.sh
		killall servicio-aplicaciones.sh
		killall sleep
		/root/.jvscripts/conexiones.sh &
		/root/.jvscripts/aplicaciones.sh &
		/root/.jvscripts/comprobacion.sh &
		/root/.jvscripts/servicio-conexiones.sh &
		/root/.jvscripts/servicio-aplicaciones.sh &
fi

if [ "$estado" == "$estado3" ];
	then
		killall aplicaciones.sh
		killall conexiones.sh
		killall sleep
fi
