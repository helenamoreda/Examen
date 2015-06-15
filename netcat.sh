#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: netcat.sh
#Versión:04-05-2015
#Resumen: script que envía una alerta a través de netcat hacia la ip fija del servidor por el puerto 3333

#Variable que almacena la IP de nuestro servidor. Es importante que esta IP sea fija.
IPservidor="192.168.1.176"

#$* imprime todos los argumentos que recibe de los scripts de conexiones y aplicaciones, nc se encarga de establecer conexión con el servidor a través de la IP proporcionada anteriormente y “3333” es el puerto utilizado
echo $* | nc $IPservidor 3333


#en el del profesor tiene q estar nc -l -k 3333




