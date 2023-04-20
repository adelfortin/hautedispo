#!/bin/bash

# Variables
REPO_URL="https://github.com/adelfortin/fontspoweline"
DOSSIER_CLONE="/root/.fonts"
DOSSIER_ARCHIVE="/root"
ARCHIVE_NOM="powerline_fonts.tar.gz"

# Les erreurs
erreur_git_clone=90
erreur_creation_archive=91

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

git_clone() {
if git clone "$REPO_URL" "$DOSSIER_CLONE"; then
echo "Le dépôt Git a été cloné avec succès dans $DOSSIER_CLONE."
else
echo "ERREUR : Le clonage du dépôt Git a échoué."
exit $erreur_git_clone
fi
}

creer_archive() {
if tar -czf "$DOSSIER_ARCHIVE/$ARCHIVE_NOM" -C "$DOSSIER_CLONE" .; then
echo "L'archive a été créée avec succès dans $DOSSIER_ARCHIVE/$ARCHIVE_NOM."
else
echo "ERREUR : La création de l'archive a échoué."
exit $erreur_creation_archive
fi
}

usage() {
creer_dossier "$DOSSIER_CLONE"
git_clone
creer_archive
}

# Programme principal
usage
