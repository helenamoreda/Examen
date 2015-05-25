#!/bin/bash

#Autora: Helena Moreda Boza
#Fichero: sqlite.sh
#Versión:09-05-2015
#Resumen: 



sql_args="-h localhost -u root -proot -e"

mysql $sql_args "create database hardware;"

mysql $sql_args2 "create table if not exists componentes (id int(10) not null auto_increment primary key, equipo varchar(15), tipo varchar (50), tamaño varchar (4000));"
