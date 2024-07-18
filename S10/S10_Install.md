# Script bash d'automatisation GLPI

## Créer le fichier glpi_config.txt

Vous pouvez utiliser un éditeur de texte comme nano pour créer et éditer le fichier.

```bash
nano glpi_config.txt

Contenu du fichier de configuration: glpi_config.txt
Assurez-vous que le fichier de configuration glpi_config.txt contient les variables nécessaires :

DB_NAME1="glpi_db1"
DB_USER1="glpi_user1"
DB_PASSWORD1="glpi_password1"
DOMAIN1="glpi_domain1"

DB_NAME2="glpi_db2"
DB_USER2="glpi_user2"
DB_PASSWORD2="glpi_password2"
DOMAIN2="glpi_domain2"

Voici mon script bash

#!/bin/bash

# Charger les variables depuis le fichier de configuration
source ./glpi_config.txt

# Installation des prérequis
apt-get update
apt-get install -y apache2 mariadb-server php php-mysql php-gd php-ldap php-curl php-cli php-xml php-mbstring unzip

# Demande du mot de passe root MySQL une seule fois
echo "Veuillez entrer le mot de passe root MySQL :"
read -s ROOT_PASSWORD

# Fonction pour installer GLPI pour un domaine donné
install_glpi() {
    local DB_NAME=$1
    local DB_USER=$2
    local DB_PASSWORD=$3
    local DOMAIN=$4

    # Création de la base de données et de l'utilisateur MySQL
    mysql -u root -p"$ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
    mysql -u root -p"$ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
    mysql -u root -p"$ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
    mysql -u root -p"$ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"

    # Téléchargement et extraction de GLPI
    wget -O /tmp/glpi.tgz https://github.com/glpi-project/glpi/releases/download/9.5.0/glpi-9.5.0.tgz
    tar -xzf /tmp/glpi.tgz -C /var/www/html/
    mv /var/www/html/glpi /var/www/html/$DOMAIN/
    rm /tmp/glpi.tgz

    # Configuration des permissions d'accès
    chown -R www-data:www-data /var/www/html/$DOMAIN
    chmod -R 755 /var/www/html/$DOMAIN
}

# Itérer sur chaque groupe de variables dans glpi_config.txt
for i in 1 2; do
    DB_NAME_VAR="DB_NAME$i"
    DB_USER_VAR="DB_USER$i"
    DB_PASSWORD_VAR="DB_PASSWORD$i"
    DOMAIN_VAR="DOMAIN$i"

    DB_NAME=${!DB_NAME_VAR}
    DB_USER=${!DB_USER_VAR}
    DB_PASSWORD=${!DB_PASSWORD_VAR}
    DOMAIN=${!DOMAIN_VAR}

    # Vérifier que les variables sont définies
    if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ] || [ -z "$DOMAIN" ]; then
        echo "Les variables pour la configuration $i ne sont pas correctement définies. Veuillez vérifier le fichier glpi_config.txt."
        continue
    fi

    # Appel de la fonction d'installation
    install_glpi $DB_NAME $DB_USER $DB_PASSWORD $DOMAIN
done

# Redémarrage des services
systemctl restart apache2

echo "GLPI a été installé avec succès pour tous les domaines."

## Explications des sections du script

### Chargement des Variables de Configuration

La commande `source ./glpi_config.txt` permet d'intégrer les variables définies dans le fichier `glpi_config.txt` afin qu'elles soient accessibles dans le script.

### Installation des Prérequis

- `apt-get update` : Actualise la liste des paquets disponibles.
- `apt-get install -y ...` : Installe les paquets essentiels pour assurer le bon fonctionnement de GLPI (Apache, MariaDB, PHP et ses extensions).

### Définition de la Fonction `install_glpi`

Cette fonction requiert quatre paramètres :
- Nom de la base de données
- Nom de l'utilisateur associé à cette base
- Mot de passe de cet utilisateur
- Nom de domaine pour GLPI

Son rôle consiste à :
- Créer la base de données et l'utilisateur MySQL correspondant.
- Télécharger et extraire GLPI.
- Configurer les autorisations d'accès.

### Boucle d'Installation pour Plusieurs Instances de GLPI

À travers une boucle `for i in 1 2`, l'itération se fait deux fois (ou plus si vous avez défini davantage de configurations) en vue d'installer plusieurs instances distinctes de GLPI.
Cette démarche exploite l'expansion des variables indirectes `${!VAR}` pour récupérer les valeurs des variables déclarées dans `glpi_config.txt`.

### Redémarrage du Service Apache

Par l'exécution `systemctl restart apache2`, Apache est redémarré pour appliquer les nouvelles configurations.

### Connexion à GLPI

Si l'adresse IP de notre serveur GLPI est 172.18.1.60, voici la procédure pour nous connecter à GLPI depuis notre navigateur web :
- **Formuler l'URL** : L'URL complète permettant d'accéder à GLPI via cette adresse IP serait [http://172.18.1.60/glpi](http://172.18.1.60/glpi).
- **Ouvrir notre Navigateur** : Lancez notre navigateur web habituel (tel que Chrome, Firefox, etc.).
- **Saisir l'URL** : Dans la barre d'adresse du navigateur, entrez [http://172.18.1.60/glpi](http://172.18.1.60/glpi).
- **Appuyer sur Entrée** : Pressez la touche Entrée pour accéder à cette adresse.
- **Page de Connexion** : Nous devrions maintenant visualiser la page de connexion de GLPI.
