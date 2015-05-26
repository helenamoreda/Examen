#!/bin/bash


if test -f /root/.jvscripts/servidor/conexion.txt
	then
		rm /root/.jvscripts/servidor/conexion.txt
fi

IPservidor="192.168.0.235"

nmap $IPservidor -p 3333 | grep 3333 > /root/.jvscripts/servidor/conexion.txt

estado=`cat /root/.jvscripts/netcat/conexion.txt`
estado2=`3333/tcp open  dec-notes`

if [ $estado == $estado2 ];
	then
		/root/.jvscripts/conexiones.sh &
		/root/.jvscripts/aplicaciones.sh &
		/root/.jvscripts/comprobacion.sh &
		/root/.jvscripts/servicio-conexiones.sh &
		/root/.jvscripts/servicio-aplicaciones.sh &
fi
