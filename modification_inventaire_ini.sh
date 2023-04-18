#!/bin/bash

# VARIABLES BOUND : on définit les noms de fichiers dans des variables
ADRESSE_IPV4_LOG="adresse_ipv4.log"
INVENTAIRE_INI="inventaire.ini"

# VARIABLE BOUND : on initialise la variable I à 0 pour compter le nombre d'adresses IP traitées
declare -i I=0

# Modification du fichier INVENTAIRE.INI avant de commencer la boucle
echo -e "\n[machine_sans_configuration]" >> "$INVENTAIRE_INI"

# Add machine1 and machine7 to the [routeurs] group
echo -e "\n[routeurs]" >> "$INVENTAIRE_INI"
echo "machine1" >> "$INVENTAIRE_INI"
echo "machine7" >> "$INVENTAIRE_INI"

# Boucle while pour lire chaque ligne du fichier ADRESSE_IPV4_LOG
while read ligne
do
# Utilisation de la variable et de la commande sed pour écrire dans le fichier INVENTAIRE.INI
echo "machine$I ansible_host=$ligne" >> "$INVENTAIRE_INI"

# Incrémentation de la variable I
I+=1

done < "$ADRESSE_IPV4_LOG"

# Vérification du succès ou non de la boucle
if [ "$I" -gt 0 ]; then
# Si la boucle s'est bien exécutée, on affiche un message de succès en français
echo "Le fichier $INVENTAIRE_INI a maintenant $(($I+1)) nouvelles adresses IP."
else
# Sinon, on affiche un message d'erreur et on termine le script
echo "Erreur : aucune adresse IP n'a pu être traitée."
exit 1
fi
