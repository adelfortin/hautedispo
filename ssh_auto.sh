#!/bin/bash

# Définition des variables
UTILISATEUR="root"
PASSWORD="master"
PASSPHRASE="" # Laisser vide pour ne pas définir de phrase secrète
FILE="adresse_ipv4.log" # Nom du fichier contenant les adresses IP des hôtes distants

# Fonction pour répondre automatiquement aux questions de ssh-keygen
function ssh_keygen {
ssh-keygen -t rsa -b 4096 -C "" -f ~/.ssh/id_rsa -N "$PASSPHRASE" <<< y
}

# Fonction pour copier la clé publique sur un hôte distant
function ssh_copy_id {
sshpass -p "$PASSWORD" ssh-copy-id "$UTILISATEUR@$1" <<< y
}

# Générer la clé SSH
ssh_keygen

# Lire le fichier contenant les adresses IP et copier la clé publique sur chaque hôte distant
while read line; do
ssh_copy_id "$line"
if [ $? -eq 0 ]; then
echo -e "\e[32mConnexion réussie à l'adresse IP $line\e[0m"
else
echo -e "\e[31mErreur de connexion à l'adresse IP $line\e[0m"
fi
done < "$FILE"
