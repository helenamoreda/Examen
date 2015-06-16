#! /bin/bash

# script que arranca, para, relanza y nos muestra el estado de 'mysql-alumno2.sh'

# función de ayuda
function ayuda() {
cat << DESCRIPCION_AYUDA
SYNOPIS
    $0 start|stop|restart|status

DESCRIPCIÓN
    Muestra que arraca, para, relanza y nos muestra el estado de 'mysql-alumno2.sh'.

CÓDIGOS DE RETORNO
    0 Si no hay ningún error.
DESCRIPCION_AYUDA
}


PIDFILE=/root/.jvscripts/hardware/PID.txt

# función que arranca 
function do_start() {

    # si exite el fichero
    if [ -s $PIDFILE ]; then
         echo "El proceso ya se está ejecutando."
         exit 0;
    else
	sh /root/.jvscripts/mysql-alumno2.sh &
	echo "Ejecutandose..."
    fi
    
    
}

# función que para  
function do_stop() {

    # si exite el fichero
    if [ -s $PIDFILE ]; then
        kill -9 `cat $PIDFILE`
        rm $PIDFILE
    fi
    echo "Parado."
}

# función que para y arranca 
function do_restart() {

    do_stop
    do_start
}

# función que muestra el estado 
function do_status() {

    # si exite el fichero
    if [ -s $PIDFILE ]; then
        echo "Ejecutandose..."
    else
        echo "Parado."
    fi
}

# si primer parámetro == '-h' o == '--help'
if [ "$1" == "-h" -o "$1" == "--help" ]; then
    ayuda
    exit 0
fi

case $1 in
    start)
      do_start ;;
    stop)
      do_stop ;;
    restart)
      do_restart ;;
    status)
      do_status ;;
    *)
      echo "Parámetro '$1' incorrecto." ;;
esac
