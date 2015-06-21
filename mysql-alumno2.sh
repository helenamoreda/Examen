#Fichero: mysql-alumno2.sh
#Versión:09-05-2015
#Resumen: Script que se ejecuta al reiniciar la máquina y envía la capacidad del disco duro y RAM periódicamente como un servicio.

#Variable que almacena la IP fija que tiene el servidor
IPservidor="192.168.1.177"

# Se montan los parámetros de conexión
sql_args="-h $IPservidor -u root -proot hardware -e"


#Guardamos el nombre de la máquina
hostname=`hostname`

#Guardamos el PID del proceso actual para poderlo matar
echo $$ > /root/.jvscripts/hardware/PID.txt

#Guardamos el tipo de componente
tipo1="Memoria RAM"
#Guardamos la capacidad de nuestra memoria ram
RAM=`free | grep Mem |  awk {'print $2'}`

#Guardamos los tipos de componentes
tipo2="HDD"
tipo3="HDD2"
#Guardamos la capacidad de nuestro disco duro principal
HDD=`sudo fdisk -l | grep -w -e /dev/sda | awk {'print $3,$4'} | cut -d "," -f1`

#Condición para entrar en el blucle
opcion=0

while [ $opcion -eq 0 ];
do

#Si existe el fichero quiere decir que tenemos dos discos duros instalados
if [ -f /root/.jvscripts/dosdiscos ];
	then
		#Guardamos la capacidad del segundo disco duro en una variable
		HDD2=`sudo fdisk -l | grep -w -e /dev/sdb | awk {'print $3,$4'} | cut -d "," -f1`
		#Actualizamos los datos de la tabla componentes2
		mysql $sql_args "update componentes2 set tamaño='$HDD2' where equipo='$hostname' and tipo='$tipo3';"
fi

#Actualizamos los datos a la tabla componentes2
mysql $sql_args "update componentes2 set tamaño='$RAM' where equipo='$hostname' and tipo='$tipo1';"
mysql $sql_args "update componentes2 set tamaño='$HDD' where equipo='$hostname' and tipo='$tipo2';"



#Hacemos una consulta mysql para saber qué tipo de componente ha cambiado en el equipo y metemos el resultado en un txt
mysql $sql_args "select tipo from componentes as t1 where not exists(select equipo, tipo, tamaño from componentes2 as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1 > /root/.jvscripts/tipocambiado
#Hacemos una consulta mysql para saber qué tamaño tenía anteriormente y metemos el resultado en un txt
mysql $sql_args "select tamaño from componentes as t1 where not exists(select equipo, tipo, tamaño from componentes2 as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1 > /root/.jvscripts/tamaño1
#Hacemos una consulta mysql para saber qué tamaño tiene actualmente y metemos el resultado en un txt
mysql $sql_args "select tamaño from componentes2 as t1 where not exists(select equipo, tipo, tamaño from componentes as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1 > /root/.jvscripts/tamaño2

#Guardamos la información de los txt anteriores en variables
tipocambiado=`cat /root/.jvscripts/tipocambiado`
size=`cat /root/.jvscripts/tamaño1`
size2=`cat /root/.jvscripts/tamaño2`


#En el caso de que haya un tipo cambiado, enviará un e-mail avisándonos
if [ "$tipocambiado" != "" ];
	then
		#Si el componente que ha cambiado es el segundo disco duro
		if [ "$tipocambiado" = "HDD2" ];
			then
				#Enviamos un correo donde -f es el remitente y -t el destinatario
				#Con -s configuramos el servidor de correo SMTP
				#Con -u el asunto y -m el mensaje del correo
				#Con -xu debemos volver a especificar el correo remitente y con -xp la contraseña del correo remitente
				sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@gmail.com -s smtp.live.com -u \ "Cambios en el hardware" -m "Ha habido un cambio en el componente $tipocambiado del equipo $hostname. Su anterior capacidad era $size y ahora es $size2" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
				#Borramos la fila que contiene la capacidad del disco duro secundario
				mysql $sql_args "delete from componentes where tipo='$tipocambiado' and equipo='$hostname';"
				mysql $sql_args "delete from componentes2 where tipo='$tipocambiado' and equipo='$hostname';"
				#Borramos el fichero que indicaba que hay dos discos duros instalados
				rm /root/.jvscripts/dosdiscos
				sleep 1m
			else
				#En el caso de que haya sido otro componente enviamos un email y actualizamos los datos
				sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@gmail.com -s smtp.live.com -u \ "Cambios en el hardware" -m "Ha habido un cambio en el componente $tipocambiado del equipo $hostname. Su anterior capacidad era $size y ahora es $size2" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
				mysql $sql_args "update componentes set tamaño='$size2' where equipo='$hostname' and tipo='$tipocambiado';"
		fi
fi

done
