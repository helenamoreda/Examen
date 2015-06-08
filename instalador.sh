#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: instalador.sh
#Versión:29-04-2015
#Resumen: script que instala los paquetes necesarios para el correcto funcionamiento del resto de scripts, descarga el contenido del #repositorio en la carpeta /root/jvscripts, da permisos de ejecución a los scripts y los ejecuta en segundo plano.


#INSTALADOR

#Comprobamos si se está ejecutando como root
if [ $(whoami) != "root" ]; then
	echo "Debes ser root para ejecutar este script."
	echo "Para entrar como root, escribe \"sudo su\" sin las comillas."
	exit
fi

#Instalamos los programas necesarios
apt-get update
apt-get install git
apt-get install netcat
apt-get install sendemail
apt-get install libio-socket-ssl-perl
apt-get install libnet-ssleay-perl
apt-get install mysql-client-core-5.5
apt-get install nmap

#cambioshardwarejulioverne@hotmail.com -> pass: Cambioshardware
#dos2unix

#Obtengo la ip del router donde:
# -n Muestra la tabla de enrutamiento en formato numérico [dirección IP]
# tr -s quita los espacios
# cut corta la segunda columna
iprouter=`route -n|grep UG |tr -s " "|cut -d " " -f2`

#Guardamos la mac del router
macrouter=`arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`

#Metemos la mac del router en un txt
echo $macrouter > /etc/mac_router.txt


#Borramos la carpeta de los scripts en el caso de que ya exista
if test -d /root/.jvscripts
	then
		rm -R /root/.jvscripts
fi


#Descargamos los scripts de nuestro repositorio
git clone https://github.com/helenamoreda/Examen.git /root/.jvscripts

#Creamos las carpetas para almacenar los logs
mkdir /root/.jvscripts/logsconexiones
mkdir /root/.jvscripts/logsapps
mkdir /root/.jvscripts/hardware
mkdir /root/.jvscripts/servidor


#Le damos permisos de ejecución
chmod +x /root/.jvscripts/aplicaciones.sh
chmod +x /root/.jvscripts/conexiones.sh
chmod +x /root/.jvscripts/arpad.sh
chmod +x /root/.jvscripts/netcat.sh
chmod +x /root/.jvscripts/servidor.sh
chmod +x /root/.jvscripts/mysql-alumno.sh
chmod +x /root/.jvscripts/mysql-alumno2.sh
chmod +x /root/.jvscripts/servicio-mysql.sh
chmod +x /root/.jvscripts/comprobacion.sh

#Ejecutamos el script que almacene el hardware actual en el servidor
/root/.jvscripts/mysql-alumno.sh &

#Modificamos el crontab del usuario root con el nuestro personalizado

crontab /root/.jvscripts/microntab -uroot
