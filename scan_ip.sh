#!/bin/bash
# ---------------------#
# Desc.   : Ce script permet de garder en cache une liste d'adresse ip des machines non configuré
# Date    :
# Version :
# ---------------------#

prefix_adresse="192.168.58"
adresses_bannies=("192.168.58.1" "192.168.58.2")
nombre_adresse_voulue=9
interface="enp0s3"
ip_actuel=$(ip addr show dev $interface | grep "inet " | awk '{print $2}' | cut -d/ -f1) # Adresse ip de la machine actuel
fichier_decouverte="/root/.deploy/adresses_decouverte.log"
fichier_ip="/root/.deploy/adresse_ipv4.log"
tmp="/root/.deploy/tmp"

# Cette fonction permet de liste tous les adresses IP qui sont vivant
# sur le réseau
function find_adresses {
    # Récupere uniquement les adresses qui sont alive
    fping -aqg ${prefix_adresse}.0/24 >$fichier_decouverte
    # Trie en fonction des adresses bannies
    while IFS= read -r adresse; do
        if [ "$adresse" != "$ip_actuel" ] && [[ ! ${adresses_bannies[*]} =~ ${adresse} ]]; then
            echo "$adresse" >${fichier_ip}
        fi
    done <"$fichier_decouverte"
    # Récupere au moin le nombre d'adresse suffisant
    head -n ${nombre_adresse_voulue} ${fichier_ip} >${tmp} && mv ${tmp} ${fichier_ip}
    # Suppression du fichier des adresses découverte
    rm -f ${fichier_decouverte}
}

function add_adresses {
    # Ajout de l'adresse de loopback dans le fichier des adresses
    #echo "127.0.0.1" >>"${fichier_ip}"
}

find_adresses
add_adresses

# Fin du programme
exit 0
