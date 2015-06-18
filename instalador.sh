#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: instalador.sh
#Versión:29-04-2015
#Resumen: script que instala los paquetes necesarios para el correcto funcionamiento del resto de scripts, descarga el contenido del #repositorio en la carpeta /root/jvscripts, da permisos de ejecución a los scripts y muestra un menú para elegir qué deseamos instalar.


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

#Borramos la carpeta de los scripts en el caso de que ya existan
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
chmod +x /root/.jvscripts/actualizar.sh
chmod 777 /root/.jvscripts/microntab

#Mensaje que nos sale por pantalla con las opciones a elegir
opcion=`zenity --list --column "Elija una opción" "1. Instalar scripts de monitorización de exámenes" "2. Instalar scripts de mantenimiento" "3. Instalar ambos"`


#Función en caso de que elijamos instalar únicamente la opción 1
function examenes {
	
#Si existe el fichero que nos permite saber si se ha instalado anteriormente
if [ -f /root/uno ];
	then
		#En el caso de que exista el fichero "uno" nos envía un mensaje por pantalla
		zenity --warning --text="La opción 1 ya ha sido instalada"
	else
	
#Añadimos el comando "xhost +"" al fichero ~/.bashrc para que puedan visualizarse correctamente las alertas gráficas
echo "xhost +" >> ~/.bashrc

#Añadimos una línea al nuestro crontab personalizado
echo "*/1 * * * * /root/.jvscripts/servidor.sh" >> /root/.jvscripts/microntab

#Modificamos el crontab del usuario root con el nuestro personalizado
crontab /root/.jvscripts/microntab -uroot

#Creamos el archivo que nos permite saber si se ha instalado anteriormente
touch /root/uno

fi
}


#Función en caso de que elijamos instalar únicamente la opción 2
function mantenimiento {

#Si existe el fichero que nos permite saber si se ha instalado anteriormente
if [ -f /root/dos ];
	then
		#En el caso de que exista el fichero "uno" nos envía un mensaje por pantalla
		zenity --warning --text="La opción 2 ya ha sido instalada"
	else
		#Obtengo la ip del router donde:
		# -n Muestra la tabla de enrutamiento en formato numérico [dirección IP]
		# tr -s quita los espacios
		# cut corta la segunda columna
		iprouter=`route -n|grep UG |tr -s " "|cut -d " " -f2`
		#Guardamos la mac del router
		macrouter=`arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`

		#Metemos la mac del router en un txt
		echo $macrouter > /etc/mac_router.txt

		#Ejecutamos el script que almacene el hardware actual en el servidor
		/root/.jvscripts/mysql-alumno.sh &

		#Añadimos estas líneas a nuestro crontab personalizado
		echo "*/1 * * * * /root/.jvscripts/arpad.sh" >> /root/.jvscripts/microntab
		echo "@reboot /root/.jvscripts/mysql-alumno2.sh" >> /root/.jvscripts/microntab
		echo "*/1 * * * * /root/.jvscripts/comprobacion.sh" >> /root/.jvscripts/microntab
		
		#Modificamos el crontab del usuario root con el nuestro personalizado
		crontab /root/.jvscripts/microntab -uroot

		#Creamos el archivo que nos permite saber si se ha instalado anteriormente
		touch /root/dos
fi
}

#Función en caso de que elijamos instalar ambas opciones. 
function ambos {

#Añadimos el comando "xhost +" al fichero ~/.bashrc para que puedan visualizarse correctamente las alertas gráficas
echo "xhost +" >> ~/.bashrc

#Añadimos una línea al nuestro crontab personalizado
echo "*/1 * * * * /root/.jvscripts/servidor.sh" >> /root/.jvscripts/microntab
		
#Creamos el archivo que nos permite saber si se ha instalado anteriormente
touch /root/uno

#Obtengo la ip del router donde:
# -n Muestra la tabla de enrutamiento en formato numérico [dirección IP]
# tr -s quita los espacios
# cut corta la segunda columna
iprouter=`route -n|grep UG |tr -s " "|cut -d " " -f2`

#Guardamos la mac del router
macrouter=`arp -n|grep -w $iprouter|tr -s " "|cut -d " " -f3`

#Metemos la mac del router en un txt
echo $macrouter > /etc/mac_router.txt

#Ejecutamos el script que almacene el hardware actual en el servidor
/root/.jvscripts/mysql-alumno.sh &

#Añadimos estas líneas a nuestro crontab personalizado
echo "*/1 * * * * /root/.jvscripts/arpad.sh" >> /root/.jvscripts/microntab
echo "@reboot /root/.jvscripts/mysql-alumno2.sh" >> /root/.jvscripts/microntab
echo "*/1 * * * * /root/.jvscripts/comprobacion.sh" >> /root/.jvscripts/microntab

#Creamos el archivo que nos permite saber si se ha instalado anteriormente
touch /root/dos
		
#Modificamos el crontab del usuario root con el nuestro personalizado
crontab /root/.jvscripts/microntab -uroot
} 	


#En el caso de que elija la opción 1 llamamos a la función examenes
if [ "$opcion" == "1. Instalar scripts de monitorización de exámenes" ];
	then
		examenes
fi

#En el caso de que elija la opción 2 llamamos a la función mantenimiento
if [ "$opcion" == "2. Instalar scripts de mantenimiento" ]; 
	then
		mantenimiento
fi

#En el caso de que elija la opción 3 llamamos a la función ambos
if [ "$opcion" == "3. Instalar ambos" ]; 
	then
		ambos
fi
