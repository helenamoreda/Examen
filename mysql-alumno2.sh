#Fichero: sqlite.sh
#Versión:09-05-2015
#Resumen:


IPservidor="192.168.0.236"

### Se monta los parámetros de conexión
sql_args="-h $IPservidor -u root -proot hardware -e"


mysql $sql_args "drop table componentes2;"

mysql $sql_args "create table if not exists componentes2 (id int(10) not null auto_increment primary key, equipo varchar(15), tipo varchar (50), descripcion varchar (4000));"


hostname=`hostname`

tipo1="Memoria RAM"
RAM=`free | grep Mem |  awk {'print $2'}`


tipo2="HDD"
HDD=`fdisk -l | grep -w -e /dev/sda | awk {'print $3'}`

mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo1','$RAM');"
mysql $sql_args "insert into componentes (equipo,tipo,tamaño) values ('$hostname','$tipo2','$HDD');"

tipo-cambiado=`mysql $sql_args "select tipo from componentes as t1 where not exists(select equipo, tipo, tamaño from componentes2 as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1`
tamaño1=`mysql $sql_args "select tamaño from componentes as t1 where not exists(select equipo, tipo, tamaño from componentes2 as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1`
tamaño2=`mysql $sql_args "select tamaño from componentes2 as t1 where not exists(select equipo, tipo, tamaño from componentes as t2 where t1.equipo=t2.equipo and t1.tipo=t2.tipo and t1.tamaño=t2.tamaño);" | tail -1`



if [ "$tipo-cambiado" != "" ]
	then
		sendemail -f cambioshardwarejulioverne@hotmail.com -t helena1094@hotmail.com -s smtp.live.com -u \ "Asunto Cambios en el hardware" -m "Ha habido un cambio en el componente $tipo-cambiado del equipo $hostname. Su anterior capacidad era $tamaño1 y ahora es $tamaño2" -v -xu cambioshardwarejulioverne@hotmail.com -xp Cambioshardware -o tls=yes
fi
					
