#!/bin/bash

# Variables
ARCHIVE_CHEMIN="/root/powerline_fonts.tar.gz"
DOSSIER_DESTINATION="/root/.fonts"

# Les erreurs
erreur_extraction_archive=100

# Fonctions

creer_dossier() {
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

extraire_archive() {
if tar -xzf "$ARCHIVE_CHEMIN" -C "$DOSSIER_DESTINATION"; then
echo "L'archive a été extraite avec succès dans $DOSSIER_DESTINATION."
else
echo "ERREUR : L'extraction de l'archive a échoué."
exit $erreur_extraction_archive
fi
}

usage() {
creer_dossier "$DOSSIER_DESTINATION"
extraire_archive
}

# Programme principal
usage
bash "$DOSSIER_CLONE/install.sh"
