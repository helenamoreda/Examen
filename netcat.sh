#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: netcat.sh
#Versión:04-05-2015
#Resumen: script que envía una alerta a través de netcat hacia la ip fija del servidor por el puerto 3333

IPservidor="192.168.1.176"

echo $* | nc $IPservidor 3333


#en el del profesor tiene q estar nc -l -k 3333




