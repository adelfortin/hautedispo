#!/bin/bash

# FONCTION : sauvegarder le fichier /etc/sudoers et accorder les privilèges sudo à un utilisateur spécifique

# VARIABLES LIÉES :
# - UTILISATEUR : le nom de l'utilisateur que l'on crée et auquel on accorde les privilèges sudo et un password ainsi qu'une clé SSH
# - SUDOERS_FILE : le chemin vers le fichier sudoers
# - BACKUP_FILE : le chemin vers le fichier de sauvegarde
# - IPV4_1 : l'adresse ipv4 pour la première interface utilisée dans le cadre de notre architecture réseau
# - IPV4_2 : l'adresse ipv4 pour la seconde interface utilisée dans le cadre de notre architecture réseau
# - IPV4_3 : l'adresse ipv4 pour la troisième interface utilisée dans le cadre de notre architecture réseau
# - INTERFACE_1 : le nom la première interface utilisée dans le cadre de notre architecture réseau
# - INTERFACE_2 : le nom la deuxième interface utilisée dans le cadre de notre architecture réseau
# - INTERFACE_3 : le nom la troisième interface utilisée dans le cadre de notre architecture réseau
# - INTERFACE_4 : le nom la quatrième interface utilisée dans le cadre de notre architecture réseau

UTILISATEUR="routeur"
IPV4_3="192.168.84.1/24"
INTERFACE_1="enp0s8"
INTERFACE_2="enp0s9"
SUDOERS_FILE=/etc/sudoers
BACKUP_FILE=/etc/sudoers.bak

# Config du Hostname
if hostnamectl set-hostname $UTILISATEUR ; then
	echo "Le nom d'hôte de cette machine a été changé pour $UTILISATEUR."
else
	echo "Erreur : Impossible de changer le nom d'hôte de cette machine pour $UTILISATEUR." >&2
exit 1
fi

# Création de la première connexion
if nmcli connection add type ethernet con-name INTERNET ifname $INTERFACE_1 ipv4.method auto ; then
	echo "La première connexion a été correctement créée."
else
	echo "Erreur : Impossible de créer la première connexion." >&2
exit 1
fi

# Création de la seconde connexion
if nmcli connection add type ethernet con-name reseau84 ifname $INTERFACE_2 ipv4.addresses $IPV4_1 ipv4.method manual ; then
	echo "La seconde connexion a été correctement créée."
else
	echo "Erreur : Impossible de créer la seconde connexion." >&2
exit 1
fi

# Création du groupe
if groupadd $UTILISATEUR ; then
	echo "Le groupe $UTILISATEUR a été correctement créé."
else
	echo "Erreur : Impossible de créer le groupe $UTILISATEUR." >&2
exit 1
fi

# Création de l'utilisateur
if useradd -g $UTILISATEUR -G wheel -m $UTILISATEUR ; then
	echo "L'utilisateur $UTILISATEUR a été correctement créé."
else
	echo "Erreur : Impossible de créer l'utilisateur $UTILISATEUR." >&2
exit 1
fi

# Création du password pour l'utilisateur
if echo "$UTILISATEUR" | passwd --stdin $UTILISATEUR ; then
	echo "Le mot de passe pour l'utilisateur $UTILISATEUR a été correctement créé."
else
	echo "Erreur : Impossible de créer le mot de passe pour l'utilisateur $UTILISATEUR." >&2
exit 1
fi

echo "Le script a terminé son exécution." 
