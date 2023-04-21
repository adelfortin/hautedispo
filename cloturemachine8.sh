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

function supprimer_connexion() {
# Obtenir l'UUID de la connexion associée à l'interface voulu
uuid=$(nmcli -g UUID con show "$1")

# Vérifier si l'UUID a été trouvé
if [ -z "$uuid" ]
then
# Si l'UUID n'a pas été trouvé, afficher un message d'erreur
echo "La connexion pour l'interface $1 n'a pas été trouvée."
return 1
else
# Si l'UUID a été trouvé, afficher un message de confirmation
echo "La connexion pour l'interface $1 a été trouvée : $uuid."
fi

# Supprimer la connexion associée à l'interface voulu
nmcli con delete "$uuid"

# Vérifier si la suppression a réussi
if [ $? -eq 0 ]
then
# Si la suppression a réussi, afficher un message de confirmation
echo "La connexion pour l'interface enp0s3 a été supprimée."
else
# Sinon, afficher un message d'erreur
echo "La suppression de la connexion pour l'interface enp0s3 a échoué."
return 1
fi
}
# Vérifie les privilèges d'administrateur
if [[ $(id -u) -ne 0 ]]; then
echo "Erreur : cette action nécessite des privilèges d'administrateur."
exit 1
fi

# Supprimer les connexions non nécessaire
echo "Supprimer les connexions non nécessaire"
supprimer_connexion enp0s3
supprimer_connexion enp0s8

# Fonction pour redémarrer le service de gestionnaire de réseau
redemarrer_service_reseau() {
# Arrêter le service de gestionnaire de réseau
systemctl stop NetworkManager

# Vérifier si l'arrêt du service a réussi
if [ $? -eq 0 ]; then
echo "Le service de gestionnaire de réseau a été arrêté avec succès."
else
echo "Erreur lors de l'arrêt du service de gestionnaire de réseau."
return 1
fi

# Redémarrer le service de gestionnaire de réseau
systemctl restart NetworkManager

# Vérifier si le redémarrage du service a réussi
if [ $? -eq 0 ]; then
echo "Le service de gestionnaire de réseau a été redémarré avec succès."
else
echo "Erreur lors du redémarrage du service de gestionnaire de réseau."
return 1
fi

return 0
}

#reboot
