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

redemarrer_service_reseau
