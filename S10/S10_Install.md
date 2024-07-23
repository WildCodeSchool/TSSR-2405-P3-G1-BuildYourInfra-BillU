# Etape 1 : Script bash d'automatisation d'installation GLPI

## Créer le fichier glpi_config.txt

Vous pouvez utiliser un éditeur de texte comme nano pour créer et éditer le fichier.

```bash

nano glpi_config.txt

## Contenu du fichier de configuration: glpi_config.txt
Assurez-vous que le fichier de configuration glpi_config.txt contient les variables nécessaires :

DB_NAME1="glpi_db1"
DB_USER1="glpi_user1"
DB_PASSWORD1="glpi_password1"
DOMAIN1="glpi_domain1"

DB_NAME2="glpi_db2"
DB_USER2="glpi_user2"
DB_PASSWORD2="glpi_password2"
DOMAIN2="glpi_domain2"

## Voici mon script bash

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

```

### Etape 2 : Connexion à GLPI

Ladresse IP de notre serveur GLPI est 172.18.1.60, voici la procédure pour nous connecter à GLPI depuis notre navigateur web :
- **Formuler l'URL** : L'URL complète permettant d'accéder à GLPI via cette adresse IP serait [http://172.18.1.60/glpi](http://172.18.1.60/glpi_domain1)
- **Ouvrir notre Navigateur** : Lancez notre navigateur web habituel (tel que Chrome, Firefox, etc.).
- **Saisir l'URL** : Dans la barre d'adresse du navigateur, entrez [http://172.18.1.60/glpi](http://172.18.1.60/glpi_domain1).
- **Page de Connexion** : Nous devrions maintenant visualiser la page de connexion de GLPI.
- **Suivre les instructions d'installation de GLPI** en spécifiant les informations de la base de données MariaDB configurées précédemment.

  
### Etape 3 : Synchronisation AD


Après avoir installé et configuré GLPI, vous pouvez configurer la synchronisation avec Active Directory (AD) pour importer des utilisateurs, groupes et ordinateurs. Voici une procédure détaillée pour configurer la synchronisation AD dans GLPI.

#### Partie 1: Installation du plugin LDAP pour GLPI

1. **Accédez à GLPI** via un navigateur web. Connectez-vous en tant qu'administrateur.
2. **Installer le plugin LDAP**:
    - Allez dans `Configuration > Plugins > Marketplace`.
    - Recherchez le plugin `ldap` et installez-le.
    - Activez le plugin une fois l'installation terminée.

#### Partie 2: Configuration du serveur LDAP

1. **Ajouter un serveur LDAP**:
    
    - Allez dans `Configuration > Authentification > LDAP directories`.
    - Cliquez sur `+` pour ajouter un nouveau répertoire LDAP.
    - Remplissez les informations du serveur LDAP :
        - **Nom**: Nom descriptif de votre serveur LDAP.
        - **Serveur LDAP**: Adresse de votre serveur AD.
        - **Port LDAP**: Par défaut, 389 pour LDAP ou 636 pour LDAPS (sécurisé).
        - **Version de protocole LDAP**: 3.
        - **BaseDN**: La racine de votre arbre LDAP (par exemple, `dc=example,dc=com`).
        - **Connexion DN**: L'utilisateur avec lequel GLPI se connectera à AD (par exemple, `cn=admin,dc=example,dc=com`).
        - **Mot de passe**: Mot de passe de l'utilisateur de connexion.
        - **Filtre utilisateur**: Filtre LDAP pour trouver les utilisateurs (par exemple, `(objectClass=user)`).
        - **Filtre groupe**: Filtre LDAP pour trouver les groupes (par exemple, `(objectClass=group)`).
     
![Config_srv_LDAP](/Ressources/Images/srv_ldap.png)  

2. **Tester la connexion**:
    
    - Après avoir rempli les informations, cliquez sur `Tester la connexion LDAP` pour vérifier que GLPI peut se connecter à votre AD.

#### Partie 3: Configuration de la synchronisation des utilisateurs

1. **Configurer les champs utilisateurs**:
    
    - Toujours dans la section `LDAP directories`, après avoir ajouté et testé votre serveur LDAP, cliquez sur `Configurer les champs`.
    - Mappez les champs LDAP aux champs utilisateurs GLPI. Par exemple :
        - **Login**: `sAMAccountName`
        - **Nom**: `sn`
        - **Prénom**: `givenName`
        - **Email**: `mail`
2. **Configurer les options de synchronisation**:
    
    - Dans la même section, configurez les options de synchronisation selon vos besoins (par exemple, fréquence de synchronisation, création automatique de comptes, etc.).
 
#### Partie 4: Configuration de la synchronisation des groupes 


1. **Accédez à la configuration des groupes dans GLPI** :
    
    - Allez dans `Configuration > Authentification > LDAP directories`.
    - Sélectionnez votre serveur LDAP, puis cliquez sur `Groupes`.
2. **Remplissez les champs avec les valeurs appropriées** :
    
    - **Type de recherche** : `Dans les utilisateurs`
    - **Attribut utilisateur indiquant ses groupes** : `memberOf`
    - **Filtre pour la recherche dans les groupes** : `(objectClass=group)`
    - **Attribut des groupes contenant les utilisateurs** : `member`
    - **Utiliser le DN pour la recherche** : `Non`
3. **Cliquez sur `Enregistrer`** pour sauvegarder la configuration.

#### Partie 5: Synchroniser les Ordinateurs AD avec GLPI  

Il est primordial d'installer le plugin FusionIventory sur le serveur GLPI et sur les ordinateurs clients afin de permettre cette synchronisaiton,  
je me suis basé sur cet execellent tutoriel du site : www.tutos-info.fr pour la réalisation.

[Plugin_agent_FusionInventory](Ressources/Images/tuto_ordi_ad.pdf) 

### Vérifier la configuration

1. **Tester la connexion LDAP** :
    
    - Allez dans `Configuration > Authentification > LDAP directories`.
    - Sélectionnez votre serveur LDAP et cliquez sur `Tester la connexion`.
  
![test_connexion_ldap](/Ressources/Images/test_authenti.png)  
    
2. **Lancer une synchronisation** :
    
    - Allez dans `Administration > Groupes / Utilisateurs` .
    - Cliquez sur `Importer un groupe / utilisateur LDAP`.
    - Sélectionnez votre serveur LDAP et cliquez sur `Rechercher`.
    - Sélectionnez les groupes ou utilisateurs à importer et cliquez sur `Importer`.
    
Résultat pour utilisateurs :

![Config_users_ad](/Ressources/Images/users_glpi_ad.png)   

Résultat pour les groupes : 

![Config_grp_ad](/Ressources/Images/grp_ad_glpi.png) 


