#!/bin/bash

# Obtenir l'adresse IP de la machine en cours d'exécution
ip=$(hostname -I | awk '{print $1}')

# Stocker l'adresse IP dans une variable liée
IP_MACHINE=$ip

# Fonction pour obtenir le nombre d'adresses IPv4 dans le même réseau que la machine
function nombre_ipv4() {
# Extraire le préfixe du réseau à partir de l'adresse IP
prefix=$(echo $ip | cut -d. -f1-3)

# Obtenir la liste de toutes les adresses IPv4 dans le même réseau que la machine
adresses=$(nmap -sL $prefix.0/24 | grep "Nmap scan report for" | awk '{print $NF}')

# Compter le nombre d'adresses IPv4 dans la liste
nombre=$(echo "$adresses" | wc -l)

# Soustraire 1 pour obtenir le nombre d'adresses IPv4 autres que celle de la machine
nombre=$(expr $nombre - 1)

#
nombre_personalise=3

# Stocker le nombre dans une variable liée
NOMBRE_IP=$nombre
}

# Appeler la fonction pour obtenir le nombre d'adresses IPv4
nombre_ipv4

# Fonction pour scanner toutes les adresses IPv4 dans le même réseau que la machine
function scan_adresses() {
# Définir le nom du fichier de sortie
nom_fichier="adresse_ipv4.log"

# Vérifier si le fichier existe déjà
if [ -e $nom_fichier ]
then
# Si le fichier existe, ajouter les résultats à la fin
mode="a"
else
# Sinon, créer un nouveau fichier
mode="w"
fi

# Ouvrir le fichier en mode écriture ou ajout
exec 3<> $nom_fichier

# Initialiser la variable pour compter les adresses répondant au ping
i=0

# Boucle pour scanner toutes les adresses IPv4
for adresse in $adresses
do
# Vérifier si l'adresse est celle de la machine
if [ "$adresse" != "$ip" ]
then
# Si l'adresse n'est pas celle de la machine, effectuer un ping
if ping -c 1 -w 1 $adresse > /dev/null
then
# Si la réponse est positive, incrémenter le compteur et écrire dans le fichier
i=$(expr $i + 1)
echo "$i:$adresse" >&3
echo "Adress $adresse a répondu au ping." >> log.txt
else
# Sinon, ne rien faire
echo "Adress $adresse n'a pas répondu au ping." >> log.txt
fi
fi

# Vérifier si le nombre maximum d'adresses a été atteint
if [ $i -ge $NOMBRE_IP ] 
then
# Si le nombre maximum a été atteint, sortir de la boucle
echo "Le script e script a essayé tout les adresses possibles"
break
elif [ $i -ge $nombre_personalise ]
then
echo "Le script a trouvé le nombre d'adresse attendu sur ce réseau."
break
fi
done
}
usage() {
  nombre_ipv4
  scan_adresses
}
usage  
# Fermer
