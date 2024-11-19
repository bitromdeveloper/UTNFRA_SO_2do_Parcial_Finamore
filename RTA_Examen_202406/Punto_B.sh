#!/bin/bash

echo
echo "Para ejecutar: ./finamoreAltaUser-Groups.sh lucas /home/lucas/repogit/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt"
echo

USUARIO_BASE="lucas"
LISTA="/home/lucas/repogit/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt"

echo "Ya ha tomado los valores de lista y usuario"

CLAVE=$(sudo cat /etc/shadow | grep "^$USUARIO_BASE:" | cut -d':' -f2)
echo " "

echo "Entrando al for..."


# Solo toma como final los saltos de linea
ANT_IFS=$IFS
IFS=$'\n'

for LINEA in $(cat $LISTA |  grep -v ^#)
do
        # Procesar cada campo en la linea
        USUARIO=$(echo  $LINEA |awk -F ',' '{print $1}')
        GRUPO=$(echo  $LINEA |awk -F ',' '{print $2}')
        HOME_DIR=$(echo "$LINEA" | awk -F ',' '{print $3}')

        # Crear grupos
        echo "Creando grupo: $GRUPO"
        sudo groupadd "$GRUPO"

        # Crear usuario con grupo primario y directorio home
        echo "Creando usuario: $USUARIO con grupo $GRUPO y directorio $HOME_DIR"
        sudo useradd -m -s /bin/bash -g "$GRUPO" -d "$HOME_DIR" "$USUARIO"

        # Asignar contraseña
        echo "$USUARIO:$CLAVE" | sudo chpasswd -e

done
IFS=$ANT_IFS
