#!/bin/bash
#Autora: Helena Moreda Boza
#Fichero: mysql-alumno.sh
#Versión:09-05-2015
#Resumen: Script que se ejecuta con el instalador y envía el hardware actual de la máquina a la base de datos del servidor

#Variable que almacena la IP fija que tiene el servidor
IPservidor="192.168.1.176"

# Se montan los parámetros de conexión
sql_args="-h $IPservidor -u root -proot hardware -e"

#Guardamos el nombre de la máquina
hostname=`hostname`

#Guardamos el tipo de componente
tipo1="Memoria RAM"
#Guardamos la capacidad de nuestra memoria ram
RAM=`free | grep Mem |  awk {'print $2'}`

#Guardamos el tipo de componente
tipo2="HDD"
#Guardamos la capacidad de nuestros discos duros
HDD=`sudo fdisk -l | grep -w -e /dev/sda | awk {'print $3'}`
HDD2=`sudo fdisk -l | grep -w -e /dev/sdb | awk {'print $3'}`

#Creamos la tabla componentes en caso de que no exista. Guardará el hardware inicial de la máquina.  
mysql $sql_args "create table if not exists componentes (id int(10) not null auto_increment primary key, equipo varchar(15), tipo varchar (50), tamaño varchar (200));"

#Creamos la tabla componentes2 en caso de que no exista. Guardará el hardware de la máquina cada vez que ésta se reinicie 
mysql $sql_args "create table if not exists componentes2 (id int(10) not null auto_increment primary key, equipo varchar(15), tipo varchar (50), tamaño varchar (200));"

#Enviamos los datos de la tabla componentes a la base de datos
mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo1','$RAM');"
mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo2','$HDD');" 
					
