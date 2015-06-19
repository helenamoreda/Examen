#Fichero: mysql-alumno2.sh
#Versión:09-05-2015
#Resumen: Script que se ejecuta al reiniciar la máquina y envía la capacidad del disco duro y RAM periódicamente como un servicio.

#Variable que almacena la IP fija que tiene el servidor
IPservidor="192.168.1.177"

# Se montan los parámetros de conexión
sql_args="-h $IPservidor -u root -proot hardware -e"

#Borramos los datos antiguos de la tabla componentes2
mysql $sql_args "truncate table componentes2"

#Guardamos el nombre de la máquina
hostname=`hostname`

#Guardamos el PID del proceso actual para poderlo matar
echo $$ > /root/.jvscripts/hardware/PID.txt

#Guardamos el tipo de componente
tipo1="Memoria RAM"
#Guardamos la capacidad de nuestra memoria ram
RAM=`free | grep Mem |  awk {'print $2'}`

#Guardamos el tipo de componente
tipo2="HDD"
tipo3="HDD2"
#Guardamos la capacidad de nuestros discos duros
HDD=`sudo fdisk -l | grep -w -e /dev/sda | awk {'print $3,$4'} | cut -d "," -f1`

if [ -f /root/.jvscripts/dosdiscos ];
	then
		HDD2=`sudo fdisk -l | grep -w -e /dev/sdb | awk {'print $3,$4'} | cut -d "," -f1`
		mysql $sql_args "insert into componentes2 (equipo,tipo,tamaño) values ('$hostname','$tipo3','$HDD2');"
fi

#Insertamos los datos a la tabla componentes2 de base de datos
mysql $sql_args "insert into componentes2 (equipo,tipo,tamaño) values ('$hostname','$tipo1','$RAM');"
mysql $sql_args "insert into componentes2 (equipo,tipo,tamaño) values ('$hostname','$tipo2','$HDD');"


#Condición para entrar en el blucle
opcion=0

while [ $opcion -eq 0 ];
do
#Hacemos una consulta mysql para saber qué tipo de componente ha cambiado en el equipo y metemos el resultado en un txt
mysql $sql_args "select tipo from componentes as t1 where not exists(select equipo, tipo, tamaño from componentes2 as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1 > /tmp/tipocambiado
#Hacemos una consulta mysql para saber qué tamaño tenía anteriormente y metemos el resultado en un txt
mysql $sql_args "select tamaño from componentes as t1 where not exists(select equipo, tipo, tamaño from componentes2 as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1 > /tmp/tamaño1
#Hacemos una consulta mysql para saber qué tamaño tiene actualmente y metemos el resultado en un txt
mysql $sql_args "select tamaño from componentes2 as t1 where not exists(select equipo, tipo, tamaño from componentes as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1 > /tmp/tamaño2

#Guardamos la información de los txt anteriores en variables
tipocambiado=`cat /tmp/tipocambiado`
size=`cat /tmp/tamaño1`
size2=`cat /tmp/tamaño2`

#En el caso de que haya un tipo cambiado, enviará un e-mail avisándonos
if [ "$tipocambiado" != "" ]
	then
		#Enviamos un correo donde -f es el remitente y -t el destinatario
		#Con -s configuramos el servidor de correo SMTP
		#Con -u el asunto y -m el mensaje del correo
		#Con -xu debemos volver a especificar el correo remitente y con -xp la contraseña del correo remitente
		sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@hotmail.com -s smtp.live.com -u \ "Asunto Cambios en el hardware" -m "Ha habido un cambio en el componente $tipocambiado del equipo $hostname. Su anterior capacidad era $size y ahora es $size2" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
		mysql $sql_args "update componentes set tamaño='$size2' where equipo='$hostname' and tipo='$tipocambiado';"
		sleep 1m
	else
		#Si no ha habido ningún cambio esperará 10 minutos y volverá a comprobar
		sleep 5m
fi

done
