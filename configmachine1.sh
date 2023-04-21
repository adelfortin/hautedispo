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

# Configuration normal
UTILISATEUR="haproxyserver"
CHEMIN_DE_BASE="/home/$UTILISATEUR"
CHEMIN_SOURCE_BASE="/root/.deploy"

# Configuration thèmes
THEME_BASH=".bash/themes/agnoster-bash"
CHEMIN_DU_THEME_BASH="$CHEMIN_DE_BASE/$THEME_BASH"
CHEMIN_SOURCE_AGNOSTER_BASH="$CHEMIN_SOURCE_BASE/.agnoster.bash"
CHEMIN_DESTINATION_AGNOSTER_BASH="$CHEMIN_DU_THEME_BASH/agnoster.bash"
CHEMIN_DESTINATION_AGNOSTER_BASH_ROOT="root/.ssh/config"

# Configuration ssh
CHEMIN_DOSSIER_SSH="$CHEMIN_DE_BASE/.ssh"
CHEMIN_SOURCE_SSH="$CHEMIN_SOURCE_BASE/config"
CHEMIN_DESTINATION_SSH="$CHEMIN_DOSSIER_SSH/config"
CHEMIN_DESTINATION_SSH_ROOT="/root/config"

# Configuration bashrc
CHEMIN_SOURCE_BASHRC="$CHEMIN_SOURCE_BASE/.bashrc"
CHEMIN_DESTINATION_BASHRC="$CHEMIN_DE_BASE/.bashrc"
CHEMIN_DESTINATION_BASHRC_ROOT="root/.bashrc"

# Configuration du réseau
CHEMIN_DU_SCRIPT_ROUTEUR="$CHEMIN_SOURCE_BASE/transformer_en_routeur.sh"
IPV4_1="192.168.82.1/24"
IPV4_2="192.168.83.2/24"
IPV4_3="192.168.84.2/24"
INTERFACE_1="enp0s8"
INTERFACE_2="enp0s9"
INTERFACE_3="enp0s10"
PLAGE_ADRESSES_POUR_IPTABLES="192.168.0.0/16"
DNS_1="10.156.32.33"
DNS_2="10.154.59.104"
PASSERELLE_1="192.168.84.1"
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
if nmcli connection add type ethernet con-name reseau82 ifname $INTERFACE_1 ipv4.addresses $IPV4_1 ipv4.method manual ipv4.gateway $PASSERELLE_1 autoconnect yes; then
	echo "La première connexion a été correctement créée."
else
	echo "Erreur : Impossible de créer la première connexion." >&2
	exit 1
fi

# Création de la seconde connexion
if nmcli connection add type ethernet con-name reseau83 ifname $INTERFACE_2 ipv4.addresses $IPV4_2 ipv4.method manual ipv4.gateway $PASSERELLE_1 autoconnect yes; then
	echo "La seconde connexion a été correctement créée."
else
	echo "Erreur : Impossible de créer la seconde connexion." >&2
	exit 1
fi

# Création de la troisième connexion
if nmcli connection add type ethernet con-name reseau84 ifname $INTERFACE_3 ipv4.addresses $IPV4_3 ipv4.gateway $PASSERELLE_1 ipv4.dns "$DNS_1 $DNS_2" ipv4.method manual; then
	echo "La troisième connexion a été correctement créée."
else
	echo "Erreur : Impossible de créer la troisième connexion." >&2
	exit 1
fi

# Fonction pour configurer IP masquerading avec iptables
function configurer_masquerade {
	# Vérifier que le nombre d'arguments est correct
	if [ $# -ne 2 ]; then
		echo "ERREUR : La fonction configurer_masquerade nécessite 2 arguments : l'interface Internet et la plage d'adresses IP locales." >&2
		return 1
	fi

	# Récupérer les arguments dans des variables
	interface_internet="$1"
	plage_ip="$2"

	# Vérifier que l'interface Internet existe
	if ! ip link show "$interface_internet" > /dev/null 2>&1; then
		echo "ERREUR : L'interface $interface_internet n'existe pas." >&2
		return 1
	fi

	# Configurer IP masquerading avec iptables
	echo "Configuration de IP masquerading avec iptables..."
	if ! iptables -t nat -A POSTROUTING -s "$plage_ip" -o "$interface_internet" -j MASQUERADE > /dev/null 2>&1; then
		echo "ERREUR : Impossible de configurer IP masquerading avec iptables." >&2
		return 1
	fi

	echo "Configuration de IP masquerading réussie."

	return 0
}

configurer_masquerade "$INTERFACE_3" "$PLAGE_ADRESSES_POUR_IPTABLES"

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

# Fonction pour créer un dossier à partir d'un chemin spécifié
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

# Fonction pour copier des fichiers ou des dossiers
# Prend deux paramètres : la source et la destination de la copie
function copier {
	source="$1"
	destination="$2"

	# Créer le dossier de destination s'il n'existe pas encore
	creer_dossier "$(dirname "$destination")"

	# Copier les fichiers/dossiers
	cp -r "$source" "$destination"

	# Vérifier si la copie a réussi
	if [ $? -eq 0 ]; then
		echo "Le fichier/dossier '$source' a été copié avec succès vers '$destination'."
	else
		echo "Erreur lors de la copie de '$source' vers '$destination'."
	fi
}

# Fonction pour exécuter un script en mode sudo
# Prend un paramètre : le chemin du script à exécuter
function executer_script_sudo {
	script="$1"

	# Vérifier si le fichier de script existe
	if [ -f "$script" ]; then
		# Exécuter le script avec sudo
		sudo bash "$script"
		# Vérifier si l'exécution a réussi
		if [ $? -eq 0 ]; then
			echo "Le script '$script' a été exécuté avec succès en mode sudo."
		else
			echo "Erreur lors de l'exécution du script '$script' en mode sudo."
			return 1
		fi
	else
		echo "Le fichier '$script' n'existe pas ou n'est pas un fichier de script."
		return 1
	fi

	return 0
}


mv "$CHEMIN_DE_BASE/.bashrc" "$CHEMIN_DE_BASE/.bashrc.bak"

creer_dossier "$CHEMIN_DOSSIER_SSH"
creer_dossier "$CHEMIN_DU_THEME_BASH"
creer_dossier "$CHEMIN_DOSSIER_SSH_ROOT"
creer_dossier "$CHEMIN_DOSSIER_DU_THEME_BASH_ROOT"

copier "$CHEMIN_SOURCE_SSH" "$CHEMIN-DESTINATION_SSH"
copier "$CHEMIN_SOURCE_BASHRC" "$CHEMIN-DESTINATION_BASHRC"
copier "$CHEMIN_SOURCE_AGNOSTER_BASH" "$CHEMIN_DESTINATION_AGNOSTER_BASH"
copier "$CHEMIN_SOURCE_SSH" "$CHEMIN-DESTINATION_SSH_ROOT"
copier "$CHEMIN_SOURCE_BASHRC" "$CHEMIN-DESTINATION_BASHRC_ROOT"
copier "$CHEMIN_SOURCE_AGNOSTER_BASH" "$CHEMIN_DESTINATION_AGNOSTER_BASH_ROOT"

executer_script_sudo "$CHEMIN_DU_SCRIPT_ROUTEUR"

echo "Le script a terminé son exécution." 
