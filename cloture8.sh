#!/bin/bash

# Variables liées en majuscules
SCRIPT_PATH="/root/.deploy/relai.sh"

# Fonction pour afficher l'utilisation du script
function usage {
echo "Usage: $0 {start|stop}"
echo ""
echo "Ce script permet de démarrer ou d'arrêter un script spécifique au démarrage de la machine."
}

# Fonction pour arrêter le script avec un message d'erreur
function erreur {
echo "Erreur : $1"
exit 1
}

# Vérifier que l'utilisateur est root
if [[ $EUID -ne 0 ]]; then
erreur "Ce script doit être exécuté en tant que root."
fi

# Activer ou désactiver le démarrage automatique du script en fonction de l'argument fourni
case "$1" in
start)
if [[ ! -x "$SCRIPT_PATH" ]]; then
erreur "Le script n'est pas exécutable."
fi
if [[ ! -f /etc/systemd/system/script.service ]]; then
echo "[Unit]" > /etc/systemd/system/script.service
echo "Description=Script de démarrage automatique" >> /etc/systemd/system/script.service
echo "" >> /etc/systemd/system/script.service
echo "[Service]" >> /etc/systemd/system/script.service
echo "ExecStart=$SCRIPT_PATH" >> /etc/systemd/system/script.service
echo "" >> /etc/systemd/system/script.service
echo "[Install]" >> /etc/systemd/system/script.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/script.service
systemctl daemon-reload
systemctl enable script.service
echo "Le script a été activé pour démarrer automatiquement au démarrage de la machine."
else
erreur "Le fichier de service existe déjà."
fi
;;
stop)
if [[ -f /etc/systemd/system/script.service ]]; then
systemctl stop script.service
systemctl disable script.service
rm /etc/systemd/system/script.service
systemctl daemon-reload
echo "Le script a été désactivé pour démarrer automatiquement au démarrage de la machine."
else
erreur "Le fichier de service n'existe pas."
fi
;;
*)
usage
;;
esac

# Redémarrage de la machine
echo "Redémarrage de la machine..."
reboot
