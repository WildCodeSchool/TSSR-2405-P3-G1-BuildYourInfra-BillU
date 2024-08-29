# **Installation du serveur de gestion de mots de passe PassBolt**
## **Pré-requis**
En cas d'installation sur un serveur vierge, il est possible de ne pas utiliser Docker et de passer directement à l'installation de PassBolt. 
Autrement, il est nécessaire d'installer Docker pour supporter l'installation de PassBolt : si d'autres services utilisent les mêmes dépendances (Apache2 par exemple), l'installation de PassBolt risque de compromettre toute l'installation précédente.

## **Installation de Docker**
Docker est une plate-forme permettant de créer, déployer et gérer des applications dans des conteneurs. Ces conteneurs disposent du nécessaire à l'exécution d'une application (code, bibliothèques, dépendances, configuration système).
Il va être nécessaire d'installer Docker pour exécuter PassBolt, PassBolt fonctionnera ainsi dans un environnement isolé, ce qui n'impactera pas les autres services installés sur le serveur (comme GLPI).

L'ensemble des commandes suivantes doivent être effectués avec les droits root (sudo / su -)
```
# Mettre à jour les paquets
apt update
apt upgrade

# Installer les dépendances
apt install apt-transport-https ca-certificates curl gnupg lsb-release

# Ajouter la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajouter le dépôt Docker
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre à jour la liste des paquets
apt update

# Installer Docker Engine
apt install docker-ce docker-ce-cli containerd.io

# Vérifier l'installation de Docker
docker run hello-world

# Si docker récupère l'image "Hello-world", l'installation a bien fonctionné

# Installer Docker Compose pour les applications multi-conteneurs
apt install docker-compose
```

## **Configuration de PassBolt avec Docker**

```
# Créer un répertoire pour Passbolt
mkdir ~/passbolt && cd ~/passbolt

# Créer un fichier docker-compose.yml 
# Ce fichier contiendra la configuration pour l'installation de Passbolt
nano docker-compose.yml
```

Le fichier de configuration devra avoir le contenu suivant en adaptant les variables. Attention, les noms d'utilisateurs doivent correspondre. Ne pas mettre Administrator ou le nom d'Administrateur système pour une question de sécurité :

```
version: '3.7'
services:
  db:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=<votre_mot_de_passe_root_mysql>
      - MYSQL_DATABASE=passbolt
      - MYSQL_USER=passbolt
      - MYSQL_PASSWORD=<votre_mot_de_passe_passbolt>
    volumes:
      - ./mysql-data:/var/lib/mysql

  passbolt:
    image: passbolt/passbolt:latest-ce
    tty: true
    depends_on:
      - db
    environment:
      - APP_FULL_BASE_URL=https://<votre_nom_de_domaine>
      - DATASOURCES_DEFAULT_HOST=db
      - DATASOURCES_DEFAULT_USERNAME=passbolt
      - DATASOURCES_DEFAULT_PASSWORD=<votre_mot_de_passe_passbolt>
      - DATASOURCES_DEFAULT_DATABASE=passbolt
    volumes:
      - ./gpg:/etc/passbolt/gpg
      - ./jwt:/etc/passbolt/jwt
    ports:
      - 80:80
      - 443:443
```

On peut ensuite lancer Passbolt via Docker
```docker-compose up -d```

Une fois le service lancé, on configure le serveur web pour rediriger le trafic vers le conteneur Passbolt.

On peut ensuite accéder à Passbolt via le navigateur renseigné dans le fichier de configuration.