#!/bin/bash
# ---------------------#
# Desc.   :
# Date    :
# Version :
# ---------------------#

# Variables
ARCHIVE_CHEMIN="/root/powerline_fonts.tar.gz"
DOSSIER_DESTINATION="/root/.fonts"

# Les erreurs
erreur_extraction_archive=100

# Fonctions
function creer_dossier {
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

function extraire_archive {
    if tar -xzf "$ARCHIVE_CHEMIN" -C "$DOSSIER_DESTINATION"; then
        echo "L'archive a été extraite avec succès dans $DOSSIER_DESTINATION."
    else
        echo "ERREUR : L'extraction de l'archive a échoué."
        exit $erreur_extraction_archive
    fi
}

# Fonction pour exécuter un script en mode sudo
# Prend un paramètre : le chemin du script à exécuter
executer_script_sudo() {
script="$1"

# Vérifier si le fichier de script existe
if [ -f "$script" ]; then
# Exécuter le script avec sudo
sudo bash "$script"

# Vérifier si l'exécution a réussi
if [ $? -eq 0 ]; then
echo "Le script '$script' a été exécuté avec succès en mode sudo."
else
echo "Erreur lors de l'exécution du script '$script' en mode sudo."
return 1
fi
else
echo "Le fichier '$script' n'existe pas ou n'est pas un fichier de script."
return 1
fi

return 0
}

function usage {
    creer_dossier "$DOSSIER_DESTINATION"
    extraire_archive
    executer_script_sudo "$DOSSIER_DESTINATION/install.sh"
}

# Programme principal
usage

# Fin du programme
exit 0
