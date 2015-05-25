#!/bin/bash
#Autora: Helena Moreda Boza
#Fichero: sqlite.sh
#Versión:09-05-2015
#Resumen:


### Se monta los parámetros de conexión
sql_args="-h 192.168.1.176 -u root -proot hardware -e"


hostname=`hostname`


tipo1="Memoria RAM"
RAM=`free | grep Mem |  awk {'print $2'}`


tipo2="HDD"
HDD=`fdisk -l | grep -w -e /dev/sda | awk {'print $3'}`

mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo1','$RAM');"
mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo2','$HDD');"
					
