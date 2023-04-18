#!/bin/bash

# Vérifie les privilèges d'administrateur
if [[ $(id -u) -ne 0 ]]; then
echo "Erreur : cette action nécessite des privilèges d'administrateur."
exit 1
fi

# Redémarrage de la machine
echo "Redémarrage de la machine..."
reboot
