#!/bin/bash

# Definir los discos
DISK1="/dev/sdc" # 2GB
DISK2="/dev/sdd" # 1GB

echo -e "n\np\n1\n\n\nt\n8e\nw" | sudo fdisk $DISK1
echo -e "n\np\n1\n\n\nt\n82\nw" | sudo fdisk $DISK2

# Configurar LVM en el disco 1
sudo wipefs -a /dev/sdc1
sudo pvcreate /dev/sdc1
sudo vgcreate vg_datos /dev/sdc1
sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas

# Formatear las particiones LVM
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs -t ext4 /dev/mapper/vg_datos-lv_workareas

# Crear puntos de montaje y montar las particiones
sudo mkdir -p /var/lib/docker
sudo mount /dev/vg_datos/lv_docker /var/lib/docker
sudo mkdir -p /work
sudo mount /dev/vg_datos/lv_workareas /work

# Configurar LVM en el disco 2
sudo vgcreate vg_temp /dev/sdd1
sudo lvcreate -L 512M vg_temp -n lv_swap

# Configurar Swap en la tercera partición
sudo mkswap /dev/sdd1
sudo swapon /dev/sdd1

sudo systemctl restart docker
sudo systemctl status docker

# Mostrar particiones
echo "Estado actual de las particiones y swap:"
lsblk
sudo swapon --show




