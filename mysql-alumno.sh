#!/bin/bash
#Autora: Helena Moreda Boz
#Fichero: mysql-alumno.sh
#Versión:09-05-2015
#Resumen: Script que se ejecuta con el instalador y envía el hardware actual de la máquina a la base de datos del servidor

#Variable que almacena la IP fija que tiene el servidor
IPservidor="192.168.1.177"

# Se montan los parámetros de conexión
sql_args="-h $IPservidor -u root -proot hardware -e"

#Guardamos el nombre de la máquina
hostname=`hostname`

#Guardamos el tipo de componente
tipo1="Memoria RAM"
tipo2="HDD"
tipo3="HDD2"

#Guardamos la capacidad de nuestra memoria ram
RAM=`free | grep Mem |  awk {'print $2'}`

#Guardamos la capacidad de nuestros discos duros
HDD=`sudo fdisk -l | grep -w -e /dev/sda | awk {'print $3,$4'} | cut -d "," -f1`
HDD2=`sudo fdisk -l | grep -w -e /dev/sdb | awk {'print $3,$4'} | cut -d "," -f1`

#Creamos la tabla componentes en caso de que no exista. Guardará el hardware inicial de la máquina.  
mysql $sql_args "create table if not exists componentes (id int(10) not null auto_increment primary key, equipo varchar(15), tipo varchar (50), tamaño varchar (200));"

#Creamos la tabla componentes2 en caso de que no exista. Guardará el hardware de la máquina cada vez que ésta se reinicie 
mysql $sql_args "create table if not exists componentes2 (id int(10) not null auto_increment primary key, equipo varchar(15), tipo varchar (50), tamaño varchar (200));"

#Si se detecta un disco duro secundario
if [ "$HDD2" != "" ]; 
	then
		#Nos muestra una ventana emergente preguntándonos si realmente es un disco duro
		opcion=`zenity --list --column "¿Tiene usted dos discos duros fijos?" "Si" "No"`
		#En el caso de que sí sea un disco duro
		if [ "$opcion" == "Si" ];
			then
				#Guardamos los datos en la base de datos
				mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo3','$HDD2');"
				mysql $sql_args "insert into componentes2 (equipo,tipo,tamaño) values ('$hostname','$tipo3','$HDD2');"
				#Creamos un fichero que nos ayude a saber si tenemos instalado un disco duro secundario
				touch /root/.jvscripts/dosdiscos
				chmod 777 /root/.jvscripts/dosdiscos
			else
				#En caso de que no sea un disco duro nos avisará de que será considerado como pendrive y no se guardarán los datos
				zenity --warning --text "Usted tiene conectado un pendrive"
		fi
fi



#Enviamos los datos de la tabla componentes a la base de datos
mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo1','$RAM');"
mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo2','$HDD');"
mysql $sql_args "insert into componentes2 (equipo,tipo,tamaño) values ('$hostname','$tipo1','$RAM');"
mysql $sql_args "insert into componentes2 (equipo,tipo,tamaño) values ('$hostname','$tipo2','$HDD');"
					
