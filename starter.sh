#!/bin/bash
# ---------------------#
# Desc.   :
# Date    :
# Version :
# ---------------------#

# FONCTION : sauvegarder le fichier /etc/sudoers et accorder les privilèges sudo à un utilisateur spécifique

# VARIABLES LIÉES :
# - UTILISATEUR : le nom de l'utilisateur que l'on crée et auquel on accorde les privilèges sudo et un password ainsi qu'une clé SSH
# - SUDOERS_FILE : le chemin vers le fichier sudoers
# - BACKUP_FILE : le chemin vers le fichier de sauvegarde

UTILISATEUR=adel
PROXY="http://proxy.infra.dgfip:3128"

#Config du Hostname
hostnamectl set-hostname $UTILISATEUR
echo "Le Hostname de cette machine a été changé pour $UTILISATEUR."

REPO_GIT="https://github.com/adelfortin/hautedispo"

# Variables liées aux chemins
REPERTOIRE_CIBLE="/root/.deploy"
CHEMIN_INVENTAIRE="$REPERTOIRE_CIBLE/inventaire.ini"
CHEMIN_DEPLOIEMENT="$REPERTOIRE_CIBLE/deploiement.yml"
CHEMIN_SCRIPT_SCAN_IP="$REPERTOIRE_CIBLE/scan_ip.sh"
CHEMIN_SCRIPT_MODIF_INI="$REPERTOIRE_CIBLE/modification_inventaire_ini.sh"

# Variables liées à Ansible
UTILISATEUR_ANSIBLE="root"
MOT_DE_PASSE_ANSIBLE="master"

# Fonction pour ajouter une adresse de proxy pour DNF
# Prend un paramètre : l'adresse du proxy à ajouter
ajouter_proxy_dnf() {
proxy="$1"

# Vérifier si le fichier dnf.conf existe
if [ -f "/etc/dnf/dnf.conf" ]; then
# Ajouter l'adresse du proxy à la fin du fichier
echo "proxy=$proxy" >> /etc/dnf/dnf.conf

# Vérifier si l'ajout a réussi
if [ $? -eq 0 ]; then
echo "L'adresse du proxy '$proxy' a été ajoutée avec succès au fichier /etc/dnf/dnf.conf."
else
echo "Erreur lors de l'ajout de l'adresse du proxy '$proxy' au fichier /etc/dnf/dnf.conf."
return 1
fi
else
echo "Le fichier /etc/dnf/dnf.conf n'existe pas ou n'est pas accessible."
return 1
fi

return 0
}

ajouter_proxy_dnf "$PROXY"

# Installation de Git et Ansible
dnf install -y git ansible

# Création du répertoire de déploiement
mkdir -p "$REPERTOIRE_CIBLE"

# Clone du dépôt Git
if git clone "$REPO_GIT" "$REPERTOIRE_CIBLE"; then
    echo "Le dépôt a été cloné avec succès."
else
    echo "Une erreur est survenue lors du clonage du dépôt."
    exit 1
fi


# Clone du dépôt Git nécessaire pour les fonts
if bash "$REPERTOIRE_CIBLE/tarscript.sh"; then
    echo "Le dépôt a été cloné et archivé avec succès."
else
    echo "Une erreur est survenue lors du clonage ou de l'archivage du dépôt."
    exit 1
fi

# Vérification et modification des fichiers de configuration Ansible
while IFS= read -r ligne; do
    if [[ "$ligne" =~ ^\s*# ]] || [[ -z "$ligne" ]]; then
        continue
    fi
    sed -i "/$ligne/d" /etc/ansible/hosts
done </etc/ansible/hosts

if ! grep -q "remote_user=root" /etc/ansible/ansible.cfg; then
    echo "[defaults]" >>/etc/ansible/ansible.cfg
    echo "remote_user=$UTILISATEUR_ANSIBLE" >>/etc/ansible/ansible.cfg
    echo "remote_pass=$MOT_DE_PASSE_ANSIBLE" >>/etc/ansible/ansible.cfg
    echo "Le fichier /etc/ansible/ansible.cfg a été modifié avec succès."
else
    echo "Le fichier /etc/ansible/ansible.cfg ne doit pas être modifié."
fi
# Exécution du Script de scan des ips
COMMANDE_CHMOD_SUR_SCAN_IP="chmod o+x $CHEMIN_SCRIPT_SCAN_IP"
echo "Exécution de la commande pour rendre executable le script SCAN_IP: $COMMANDE_CHMOD_SUR_SCAN_IP"
$COMMANDE_CHMOD_SUR_SCAN_IP

COMMANDE_SCAN_IP_EXECUTION="bash $CHEMIN_SCRIPT_SCAN_IP"
echo "Exécution de la commande de script : $COMMANDE_SCAN_IP_EXECUTION"
$COMMANDE_SCAN_IP_EXECUTION

# Exécution du Script de modification du fichier inventaire.ini
COMMANDE_CHMOD_SUR_MODIF_INI="chmod o+x $CHEMIN_SCRIPT_MODIF_INI"
echo "Exécution de la commande pour rendre executable le script MODIF INI $COMMANDE_CHMOD_SUR_MODIF_INI"
$COMMANDE_CHMOD_SUR_MODIF_INI

COMMANDE_MODIF_INI_EXECUTION="bash $CHEMIN_SCRIPT_MODIF_INI"
echo "Exécution de la commande de script : $COMMANDE_MODIF_INI_EXECUTION"
$COMMANDE_MODIF_INI_EXECUTION

# Exécution de la commande Ansible
COMMANDE_ANSIBLE="ansible-playbook -i $CHEMIN_INVENTAIRE $CHEMIN_DEPLOIEMENT"
echo "Exécution de la commande Ansible : $COMMANDE_ANSIBLE"
$COMMANDE_ANSIBLE

echo "Le script a terminé son exécution."
