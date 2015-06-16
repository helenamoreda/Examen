#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: comprobacion.sh
#Versión:16-05-2015
#Resumen: Script que comprueba y envía un e-mail en caso de que se pare o deje de funcionar el servicio de mysql-alumno2.sh

#Guardamos el nombre del equipo
hostname=`hostname`

#Guardamos en una variable el PID del script mysql-alumno2.sh
PID1=`cat /root/.jvscripts/hardware/PID.txt`
echo $PID1

#Buscamos con ps filtrando con grep un PID coincidente con el $PID1
PID2=`ps -aux | grep -e mysql-alumno2.sh |  grep -v grep | awk {'print $2'} | tail -n 1`
echo $PID2

#En el caso de que no coincidan quiere decir que el script se ha parado y debe enviar un correo avisándonos

if [ -s /root/.jvscripts/hardware/PID.txt ];
	then
		if [ "$PID1" != "$PID2" ];
			then
			#Enviamos un correo donde -f es el remitente y -t el destinatario
			#Con -s configuramos el servidor de correo SMTP
			#Con -u el asunto y -m el mensaje del correo
			#Con -xu debemos volver a especificar el correo remitente y con -xp la contraseña del correo remitente
			sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@hotmail.com -s smtp.live.com -u \ "Script parado" -m "El script mysql-alumno2.sh ha dejado de funcionar en el equipo $hostname" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
		fi
	else
		sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@hotmail.com -s smtp.live.com -u \ "Script parado" -m "El script mysql-alumno2.sh ha dejado de funcionar en el equipo $hostname" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
fi
	
