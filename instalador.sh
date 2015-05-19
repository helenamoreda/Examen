#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: instalador.sh
#Versión:29-04-2015
#Resumen: script que instala los paquetes necesarios para el correcto funcionamiento del resto de scripts, descarga el contenido del repositorio
# en la carpeta /root/.jvscripts, da permisos de ejecución a los scripts y los ejecuta en segundo plano.


#INSTALADOR

#Comprobamos si se está ejecutando como root
if [ $(whoami) != "root" ]; then
echo "Debes ser root para ejecutar este script."
echo "Para entrar como root, escribe \"sudo su\" sin las comillas."
exit
fi

#Instalamos los programas necesarios
apt-get install git
apt-get install sqlite3
apt-get install netcat
apt-get install sendmail
apt-get install libnet-ssleay-perl
apt-get install libio-socket-ssl-perl
apt-get install mysql-client

#cambioshardwarejulioverne@hotmail.com -> Nautilus


#Creamos la carpeta donde irán los scripts

if test -d /root/jvscripts
	then
		rm -R /root/jvscripts
fi

mkdir /root/jvscripts


#Descargamos los scripts de nuestro repositorio
git clone https://github.com/helenamoreda/Examen.git /root/jvscripts


#Nos situamos en la carpeta, le damos permisos de ejecución y los arrancamos en segundo plano

chmod +x /root/jvscripts/aplicaciones.sh
chmod +x /root/jvscripts/servicio-aplicaciones.sh
chmod +x /root/jvscripts/conexiones.sh
chmod +x /root/jvscripts/servicio-conexiones.sh
chmod +x /root/jvscripts/arpad.sh
chmod +x /root/jvscripts/netcat.sh



sh /root/jvscripts/aplicaciones.sh &
sh /root/jvscripts/conexiones.sh &
#sh /root/.jvscripts//arpad.sh &


#Añadimos el script de actualización en el arranque

#echo "sh ./script.sh" >> /etc/rc.local

