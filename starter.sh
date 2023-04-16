
#!/bin/bash

# Variables liées à l'utilisateur et au déploiement
UTILISATEUR=$(whoami)
REPO_GIT="https://github.com/adelfortin/hautedispo"

# Variables liées aux chemins
REPERTOIRE_CIBLE="/home/$UTILISATEUR/.deploy"
CHEMIN_INVENTAIRE="$REPERTOIRE_CIBLE/inventaire.ini"
CHEMIN_DEPLOIEMENT="$REPERTOIRE_CIBLE/deploiement.yml"

# Variables liées à Ansible
UTILISATEUR_ANSIBLE="root"
MOT_DE_PASSE_ANSIBLE="master"

#variable pour le proxy
HTTP_PROXY="http://proxy.infra.dgfip:3128"

# Mise en place du proxy pour dnf
echo "proxy=$HTTP_PROXY" | sudo tee -a /etc/dnf/dnf.conf

# Installation de Git et Ansible
dnf install -y git ansible

# Mise en place du proxy pour git
git config --global http.proxy http://proxy.infra.dgfip:3128

# Création du répertoire de déploiement
mkdir -p "$REPERTOIRE_CIBLE"

# Clone du dépôt Git
if git clone "$REPO_GIT" "$REPERTOIRE_CIBLE"; then
echo "Le dépôt a été cloné avec succès."
else
echo "Une erreur est survenue lors du clonage du dépôt."
exit 1
fi

# Vérification et modification des fichiers de configuration Ansible
while IFS= read -r ligne; do
if [[ "$ligne" =~ ^\s*# ]] || [[ -z "$ligne" ]]; then
continue
fi
sed -i "/$ligne/d" /etc/ansible/hosts
done < /etc/ansible/hosts

if ! grep -q "remote_user=root" /etc/ansible/ansible.cfg; then
echo "[defaults]" >> /etc/ansible/ansible.cfg
echo "remote_user=$UTILISATEUR_ANSIBLE" >> /etc/ansible/ansible.cfg
echo "remote_pass=$MOT_DE_PASSE_ANSIBLE" >> /etc/ansible/ansible.cfg
echo "Le fichier /etc/ansible/ansible.cfg a été modifié avec succès."
else
echo "Le fichier /etc/ansible/ansible.cfg ne doit pas être modifié."
fi

# Exécution de la commande Ansible
COMMANDE_ANSIBLE="ansible-playbook -i $CHEMIN_INVENTAIRE $CHEMIN_DEPLOIEMENT"
echo "Exécution de la commande Ansible : $COMMANDE_ANSIBLE"
$COMMANDE_ANSIBLE
