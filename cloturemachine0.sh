#!/bin/bash

function supprimer_connexion() {
    # Obtenir l'UUID de la connexion associée à l'interface enp0s3
    uuid=$(nmcli -g UUID con show "enp0s3")

    # Vérifier si l'UUID a été trouvé
    if [ -z "$uuid" ]; then
        # Si l'UUID n'a pas été trouvé, afficher un message d'erreur
        echo "La connexion pour l'interface enp0s3 n'a pas été trouvée."
        return 1
    else
        # Si l'UUID a été trouvé, afficher un message de confirmation
        echo "La connexion pour l'interface enp0s3 a été trouvée : $uuid."
    fi

    # Supprimer la connexion associée à l'interface enp0s3
    # Vérifier si la suppression a réussi
    if nmcli con delete "$uuid" -eq 0; then
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
supprimer_connexion

# Redémarrage de la machine
echo "Redémarrage de la machine..."
reboot
