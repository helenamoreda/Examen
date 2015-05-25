#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: comprobacion.sh
#Versión:16-05-2015
#Resumen: Script que envía un e-mail en caso de que se pare algunos de los servicios que se ejecutan durante el examen.

hostname=`hostname`

PID1=`cat /root/.jvscripts/logsapps/PID.txt`
echo $PID1

PID2=`ps -a | grep -e aplicaciones.sh | awk {'print $1'}`
echo $PID2
PID3=`cat /root/.jvscripts/logsconexiones/PID.txt`

PID4=`ps -a | grep -e conexiones.sh | awk {'print $1'}`

if [ "$PID1" != "$PID2" ]
	then
		echo no deberia entrar
		sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@hotmail.com -s smtp.live.com -u \ "Script parado" -m "El script aplicaciones.sh ha dejado de funcionar en el equipo $hostname" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
fi

if [ "$PID3" != "$PID4" ]
	then
		echo aqui tampoco
		sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@hotmail.com -s smtp.live.com -u \ "Script parado" -m "El script conexiones.sh ha dejado de funcionar en el equipo $hostname" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
fi

