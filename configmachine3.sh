#!/bin/bash

# FONCTION : sauvegarder le fichier /etc/sudoers et accorder les privilèges sudo à un utilisateur spécifique

# VARIABLES LIÉES :
# - UTILISATEUR : le nom de l'utilisateur que l'on crée et auquel on accorde les privilèges sudo et un password ainsi qu'une clé SSH
# - SUDOERS_FILE : le chemin vers le fichier sudoers
# - BACKUP_FILE : le chemin vers le fichier de sauvegarde
# - IPV4_1 : l'adresse ipv4 pour la première interface utilisée dans le cadre de notre architecture réseau
# - IPV4_2 : l'adresse ipv4 pour la seconde interface utilisée dans le cadre de notre architecture réseau
# - INTERFACE_1 : le nom la première interface utilisée dans le cadre de notre architecture réseau
# - INTERFACE_2 : le nom la deuxième interface utilisée dans le cadre de notre architecture réseau
# - DNS_1 : la première adresse dns utilisé pour ce réseau
# - DNS_2 : la seconde adresse dns utilisé pour ce réseau
# - PASSERELLE_1 : l'adresse de passerelle pour cette connexion
# - PASSERELLE_2 : l'adresse de passerelle pour cette connexion


UTILISATEUR="webserver2"
CHEMIN_DE_BASE="/home/$UTILISATEUR"
CHEMIN_DOSSIER_SSH="$CHEMIN_DE_BASE/.ssh"
CHEMIN_DU_THEME_BASH="$CHEMIN_DE_BASE/.bash/agnoster-bash"
IPV4_1="192.168.82.2/24"
INTERFACE_1="enp0s8"
DNS_1="10.156.32.33"
DNS_2="10.154.59.104"
PASSERELLE_1="192.168.82.1"
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
if nmcli connection add type ethernet con-name reseau82 ifname $INTERFACE_1 ipv4.addresses $IPV4_1 ipv4.gateway $PASSERELLE_1 ipv4.dns "$DNS_1 $DNS_2" ipv4.method manual ; then
	echo "La première connexion a été correctement créée."
else
	echo "Erreur : Impossible de créer la première connexion." >&2
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

# Prend un paramètre : le chemin du dossier à créer
creer_dossier() {
if [ -d "$1" ]; then
echo "Le dossier '$1' existe déjà."
else
mkdir -p "$1"
if [ $? -eq 0 ]; then
echo "Le dossier '$1' a été créé avec succès."
else
echo "Erreur lors de la création du dossier '$1'."
fi
fi
}

creer_dossier "$CHEMIN_DOSSIER_SSH"
creer_dossier "$CHEMIN_DU_THEME_BASH"

echo "Le script a terminé son exécution." 
