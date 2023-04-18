#!/bin/bash

# Définition de la ligne à chercher
LINE="net.ipv4.ip_forward"

# Vérification de l'existence de la ligne
if grep -q "^$LINE=" /etc/sysctl.conf; then
# Si la ligne existe, on la décommente et on vérifie qu'elle se termine bien par "=1"
sed -i "/^$LINE=/ s/# *//" /etc/sysctl.conf
if ! grep -q "^$LINE=1$" /etc/sysctl.conf; then
echo "Erreur : la ligne $LINE dans /etc/sysctl.conf n'est pas correcte" >&2
exit 1
fi
echo "La ligne $LINE dans /etc/sysctl.conf a été modifiée avec succès"
else
# Si la ligne n'existe pas, on l'ajoute
echo "$LINE=1" >> /etc/sysctl.conf
echo "La ligne $LINE a été ajoutée avec succès dans /etc/sysctl.conf"
fi

# Activation des modifications
sysctl -p

# Vérification de l'état actif
if [ "$(sysctl -n $LINE)" -eq 1 ]; then
echo "La configuration $LINE est active"
else
echo "Erreur : la configuration $LINE n'est pas active" >&2
exit 1
fi
