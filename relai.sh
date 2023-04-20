#!/bin/bash

# Variables liées en majuscules
REPO_GIT="https://github.com/SHaddow7/hautedispo"
REPERTOIRE_CIBLE="/root/.deploy/relai"
DOSSIER_REPO="CMS-HAUTE-DISPO-GROUPE7"
DOSSIER_RUDY="Rudy - Configuration Web"
DOSSIER_DEPLOIEMENT="deploiements"
DERNIERE_VERSION="deploiement.v4.3"
CHEMIN_COMPLET="$REPO_GIT"
CHEMIN_INVENTAIRE="$CHEMIN_COMPLET/inventaire.ini"
CHEMIN_DEPLOIEMENT="$CHEMIN_COMPLET/setup-machines.yml"

# Fonction pour afficher l'utilisation du script
function usage {
echo "Usage: $0"
echo ""
echo "Ce script effectue un clone de dépôt Git et exécute une commande Ansible."
}

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

creer_dossier "$REPERTOIRE_CIBLE"

# Fonction pour arrêter le script avec un message d'erreur
function erreur {
echo "Erreur : $1"
exit 1
}

# Vérifier que le script ne se lance pas au démarrage
function desactiver_autostart {
systemctl disable script-reboot.service
if [[ "$?" -eq 0 ]]; then
echo "Le script ne se lancera plus automatiquement au démarrage."
else
erreur "Impossible de désactiver le démarrage automatique du script."
fi
}

# Clone du dépôt Git
function git_clone {
if git clone "$REPO_GIT" "$REPERTOIRE_CIBLE"; then
echo "Le dépôt a été cloné avec succès."
else
erreur "Une erreur est survenue lors du clonage du dépôt."
fi
}

# Exécution de la commande Ansible
function ansible_commande {
if [[ ! -x "$CHEMIN_DEPLOIEMENT" ]]; then
erreur "Le fichier de déploiement Ansible n'est pas exécutable."
fi
if ! ansible-playbook -i "$CHEMIN_INVENTAIRE" "$CHEMIN_DEPLOIEMENT"; then
erreur "Une erreur est survenue lors de l'exécution de la commande Ansible."
fi
echo "La commande Ansible a terminé son exécution."
}

# Appeler la fonction d'utilisation si aucun argument n'est fourni
if [[ $# -eq 0 ]]; then
usage
exit 0
fi

# Exécuter les fonctions appropriées en fonction des arguments fournis
while [[ $# -gt 0 ]]; do
case $1 in
-d|--desactiver-autostart)
desactiver_autostart
;;
-c|--clone-git)
git_clone
;;
-a|--ansible)
ansible_commande
;;
*)
erreur "Argument non valide : $1"
;;
esac
shift
done

echo "Le script a terminé son exécution."
