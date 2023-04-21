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

UTILISATEUR="dbserver1"
CHEMIN_DE_BASE="/home/$UTILISATEUR"
THEME_BASH=".bash/themes/agnoster-bash"
CHEMIN_DOSSIER_SSH="$CHEMIN_DE_BASE/.ssh"
CHEMIN_DU_THEME_BASH="$CHEMIN_DE_BASE/$THEME_BASH"
CHEMIN_SOURCE_BASE="/root/.deploy"
CHEMIN_SOURCE_SSH="$CHEMIN_SOURCE_BASE/config"
CHEMIN_SOURCE_BASHRC="$CHEMIN_SOURCE_BASE/.bashrc"
CHEMIN_SOURCE_AGNOSTER_BASH="$CHEMIN_SOURCE_BASE/.agnoster.bash"
CHEMIN_DESTINATION_SSH="$CHEMIN_DOSSIER_SSH/config"
CHEMIN_DESTINATION_BASHRC="$CHEMIN_DE_BASE/.bashrc"
CHEMIN_DESTINATION_AGNOSTER_BASH="$CHEMIN_DU_THEME_BASH/agnoster.bash"
CHEMIN_DESTINATION_SSH_ROOT="/root/config"
CHEMIN_DESTINATION_BASHRC_ROOT="root/.bashrc"
CHEMIN_DESTINATION_AGNOSTER_BASH_ROOT="root/.ssh/config"
IPV4_1="192.168.82.4/24"
INTERFACE_1="enp0s8"
DNS_1="10.156.32.33"
DNS_2="10.154.59.104"
PASSERELLE_1="192.168.82.1"

# Config du Hostname
if hostnamectl set-hostname $UTILISATEUR; then
    echo "Le nom d'hôte de cette machine a été changé pour $UTILISATEUR."
else
    echo "Erreur : Impossible de changer le nom d'hôte de cette machine pour $UTILISATEUR." >&2
    exit 1
fi

# Création de la première connexion
if nmcli connection add type ethernet con-name reseau82 ifname $INTERFACE_1 ipv4.addresses $IPV4_1 ipv4.gateway $PASSERELLE_1 ipv4.dns "$DNS_1 $DNS_2" ipv4.method manual; then
    echo "La première connexion a été correctement créée."
else
    echo "Erreur : Impossible de créer la première connexion." >&2
    exit 1
fi

# Création du groupe
if groupadd $UTILISATEUR; then
    echo "Le groupe $UTILISATEUR a été correctement créé."
else
    echo "Erreur : Impossible de créer le groupe $UTILISATEUR." >&2
    exit 1
fi

# Création de l'utilisateur
if useradd -g $UTILISATEUR -G wheel -m $UTILISATEUR; then
    echo "L'utilisateur $UTILISATEUR a été correctement créé."
else
    echo "Erreur : Impossible de créer l'utilisateur $UTILISATEUR." >&2
    exit 1
fi

# Création du password pour l'utilisateur
if echo "$UTILISATEUR" | passwd --stdin $UTILISATEUR; then
    echo "Le mot de passe pour l'utilisateur $UTILISATEUR a été correctement créé."
else
    echo "Erreur : Impossible de créer le mot de passe pour l'utilisateur $UTILISATEUR." >&2
    exit 1
fi

# Fonction pour créer un dossier à partir d'un chemin spécifié
# Prend un paramètre : le chemin du dossier à créer
function creer_dossier() {
    if [ -d "$1" ]; then
        echo "Le dossier '$1' existe déjà."
    else
        if mkdir -p "$1"; then
            echo "Le dossier '$1' a été créé avec succès."
        else
            echo "Erreur lors de la création du dossier '$1'."
        fi
    fi
}

# Fonction pour copier des fichiers ou des dossiers
# Prend deux paramètres : la source et la destination de la copie
function copier() {
    source="$1"
    destination="$2"

    # Créer le dossier de destination s'il n'existe pas encore
    creer_dossier "$(dirname "$destination")"

    # Copier les fichiers/dossiers
    # Vérifier si la copie a réussi
    if cp -r "$source" "$destination"; then
        echo "Le fichier/dossier '$source' a été copié avec succès vers '$destination'."
    else
        echo "Erreur lors de la copie de '$source' vers '$destination'."
    fi
}

mv "$CHEMIN_DE_BASE/.bashrc" "$CHEMIN_DE_BASE/.bashrc.bak"

creer_dossier "$CHEMIN_DOSSIER_SSH"
creer_dossier "$CHEMIN_DU_THEME_BASH"
creer_dossier "$CHEMIN_DOSSIER_SSH_ROOT"
creer_dossier "$CHEMIN_DOSSIER_DU_THEME_BASH_ROOT"

copier "$CHEMIN_SOURCE_SSH" "$CHEMIN_DESTINATION_SSH"
copier "$CHEMIN_SOURCE_BASHRC" "$CHEMIN_DESTINATION_BASHRC"
copier "$CHEMIN_SOURCE_AGNOSTER_BASH" "$CHEMIN_DESTINATION_AGNOSTER_BASH"
copier "$CHEMIN_SOURCE_SSH" "$CHEMIN_DESTINATION_SSH_ROOT"
copier "$CHEMIN_SOURCE_BASHRC" "$CHEMIN_DESTINATION_BASHRC_ROOT"
copier "$CHEMIN_SOURCE_AGNOSTER_BASH" "$CHEMIN_DESTINATION_AGNOSTER_BASH_ROOT"

echo "Le script a terminé son exécution."
