#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: comprobacion.sh
#Versión:16-05-2015
#Resumen: Script que envía un e-mail en caso de que se pare algunos de los servicios que se ejecutan durante el examen.

if test -f /tmp/conexiones.sh.pid
	then
		echo ""
	else
		sendmail
fi

if test -f /tmp/aplicaciones.sh.pid
	then
		echo ""
	else
		sendmail
fi

