# Partie 1 : Mise en place du RAID 1 lors de l'installation de Debian

L'installation de RAID 1 lors de l'installation de Debian est une étape essentielle pour assurer la redondance des données et la tolérance aux pannes. RAID 1 fonctionne en créant une copie exacte (ou miroir) de toutes les données sur un autre disque. Voici un guide étape par étape pour configurer RAID 1 lors de l'installation de Debian.

## Étape 1 : Démarrer l'installation
Démarrez votre ordinateur avec le support d'installation de Debian. Suivez les instructions à l'écran jusqu'à atteindre l'étape du partitionnement des disques.

## Étape 2 : Partitionner les disques

### Sélection du disque
Lorsque vous arrivez à l'étape "Partitionner les disques", sélectionnez "Manuel".  
![Créer un RAID 1 Debian.1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.1.png)

Comme vous le voyez sur cette image, nous avons bien les deux disques.  
![Créer un RAID 1 Debian.2.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.2.png)

### Partitionner les disques

Comme vous le voyez, la fenêtre sera comme cette image :  
![Créer un RAID 1 Debian.3.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.3.png)

Appuyez ensuite sur "partitionnement assisté".

## Étape 3 : Configurer le RAID logiciel
![Créer un RAID 1 Debian.41.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.41.png)

![Créer un RAID 1 Debian.42.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.42.png)

Il faut choisir "Créer un périphérique multidisque" :  
![Créer un RAID 1 Debian.43.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.43.png)

## Étape 4 : Formater les partitions
Pour chaque partition créée, sélectionnez le type de système de fichiers approprié. Par exemple, utilisez ext4 pour les partitions principales et swap pour l'échange :  
![Créer un RAID 1 Debian.55.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.55.png)

![Créer un RAID 1 Debian.56.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.56.png)  
![Créer un RAID 1 Debian.57.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.57.png)  
![Créer un RAID 1 Debian.58.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.58.png)  
![Créer un RAID 1 Debian.59.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.59.png)  
![Créer un RAID 1 Debian.60.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.60.png)

Nous allons mettre cette partition en swap :  
![Créer un RAID 1 Debian.61.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.61.png)  
![Créer un RAID 1 Debian.62.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.62.png)  
![Créer un RAID 1 Debian.63.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.63.png)  
![Créer un RAID 1 Debian.64.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.64.png)

## Étape 5 : Finaliser le partitionnement
![Créer un RAID 1 Debian.65.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.65.png)  
![Créer un RAID 1 Debian.66.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.66.png)  
![Créer un RAID 1 Debian.67.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.67.png)

# Mettre en place du RAID 1 sur Windows Server Core

## Étapes

### 1. Lancer Diskpart

diskpart

2. Lister les disques
list disk

3. Sélectionner le disque 0 et le convertir en dynamique
select disk 0
convert dynamic

4. Idem pour le nouveau disque ajouté
select disk 1
convert dynamic

5. Lister les volumes
list volume
![Créer un RAID1 sur Windows Core.1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID1%20sur%20Windows%20Core.1.png).
6. Sélectionner le volume C et ajouter le deuxième disque
select volume V
add disk=1

7. Vérification
list disk
list volume
![Créer un RAID1 sur Windows Core.2.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID1%20sur%20Windows%20Core.2.png).

---

# Partie 2 : Installation et Configuration de Zabbix 6.4

```
Cette procédure explique comment installer Zabbix, où le serveur central, incluant une base de données et une interface web, collecte et analyse les données transmises par les agents installés sur chaque machine cliente, assurant ainsi une supervision complète de l'infrastructure IT.
```

#### 1. Installation du Serveur Zabbix sur Debian 12 "G1-SRV-ZABBIX"

**Étape 1.1 : Préparation du serveur**

- IP du serveur : `172.18.1.22`
    
- Assurez-vous que votre serveur est à jour :

```bash
su apt update && su apt upgrade -y
```

**Étape 1.2 : Installation du serveur Zabbix et de la base de données**

- Ajoutez le dépôt Zabbix :

```bash
wget https://repo.zabbix.com/zabbix/6.4/debian/pool/main/z/zabbix-release/zabbix-release_6.4-1%2Bdebian12_all.deb
su dpkg -i zabbix-release_6.4-1+debian12_all.deb
su apt update
```

+ Installez Zabbix Server, l'interface Web et l'agent :

```bash
su apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mariadb-server
```

**Étape 1.3 : Configuration de la base de données**

- Configurez MySQL/MariaDB pour Zabbix :

```bash
su mysql_secure_installation
su mysql -u root -p
```

+ Dans le terminal MySQL, exécutez :

```bash
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

+ Importez le schéma de la base de données :

```bash
sudo zcat /usr/share/doc/zabbix-sql-scripts/mysql/server.sql.gz | mysql -uzabbix -p zabbix
```

**Étape 1.4 : Configuration du serveur Zabbix**

- Modifiez le fichier de configuration `/etc/zabbix/zabbix_server.conf` :

```bash
su nano /etc/zabbix/zabbix_server.conf
```

+ Paramètres :

```makefile
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=secure_password
```

**Étape 1.5 : Démarrer les services**

- Redémarrez les services Zabbix et Apache :

```bash
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2
```

**Étape 1.6 : Configuration de l'interface Web**

- Accédez à l'interface Web Zabbix via `http://172.18.1.22/zabbix` et suivez l'assistant pour configurer l'accès à la base de données.

  ![web_Install](/Ressources/Images/zabbix_interface_install.png)

---
### 2. Installation des Agents Zabbix

#### 2.1. Installation de l'agent Zabbix sur Debian 12 (SRV-GLPI)

- IP de la machine cliente : `172.18.1.60`
    
- Installez l'agent Zabbix :

```bash
su apt update 
su apt install -y zabbix-agent
```
    
- Configurez l'agent en éditant `/etc/zabbix/zabbix_agentd.conf` :
    
```bash
su nano /etc/zabbix/zabbix_agentd.conf
```
    
- Paramètres :
    
```makefile
Server=172.18.1.22 (IP du serveur zabbix)
ServerActive=172.18.1.22
Hostname=Debian_Client_172.18.1.60
```
    
- Démarrez et activez l'agent :
    
```bash
su systemctl restart zabbix-agent
su systemctl enable zabbix-agent
```
    
#### 2.2. Installation de l'agent Zabbix sur Windows

- **Serveur Windows 2022 (AD-DS-DNS-DHCP) :** `172.18.1.250`
    
    - Téléchargez le fichier MSI de l'agent Zabbix depuis le site officiel et suivez le wizard pour l'installation.
    - Pendant le wizard, configurez :
        - **Server** : `172.18.1.22` (IP du serveur Zabbix)
        - **Hostname** : `WINSERV1`

![MSIWSRV](/Ressources/Images/zabbix_agent_Windows.png)

- **Windows Core Backup :** `172.18.1.251`
    
- **Windows Core 2 :** `172.18.1.21`
    
    - Pour ces deux machines, j'ai utiliser  un partage réseau pour le fichier MSI et un script `Install_zabbix_agent.bat`.
        
    - Contenu du script `Install_agent.bat` :
		
```
@echo off
msiexec /i "I:\Deploiement zabbix\zabbix_agent-6.4.17-windows-amd64-openssl.msi" /quiet /qn /norestart HOSTNAME=%COMPUTERNAME% SERVER=172.18.1.22 LISTENPORT=10050
```

![WCoreInstallZabbix](/Ressources/Images/deploiement_wincore2.png)

--- 

### 3. Configuration et Supervision via l'Interface Web

#### Étape 3.1 : Ajouter les hôtes

- Connectez-vous à l'interface Web Zabbix à l'adresse `http://172.18.1.22/zabbix`.
    
- Allez dans **Collecte de données > Hosts** et cliquez sur **Create host** pour chaque machine :
    
    - **Exemple pour un client Linux** :
        
        - **Hostname** : `Debian_Client_172.18.1.60`
        - **Groups** : `Linux Servers`
        - **Interfaces** : `172.18.1.60` (cliquez sur ajouter si l'interface n'existe pas)
        - **Templates** : `Template OS Linux` (Bien choisir la template en fonction de l'OS)

![config](/Ressources/Images/zabbix_création_hote.png)  

#### Étape 3.2 : Configurer les éléments et déclencheurs

- Pour chaque hôte, allez dans l'onglet **Items** pour vérifier ou ajouter les métriques à surveiller (CPU, RAM, etc.).
- Configurez des **Triggers** pour définir des alertes spécifiques (ex : alerte lorsque l'utilisation CPU dépasse 90%).

#### Étape 3.3 : Créer des tableaux de bord et des graphiques

- Allez dans **Monitoring > Dashboard** et personnalisez les tableaux de bord pour suivre l'état des différentes machines.
- Ajoutez des widgets pour visualiser les performances et identifier rapidement les problèmes sur les hôtes surveillés.

![tdb](/Ressources/Images/tdb_zabbix.png)


---

# Partie 3 : Mise en place d'une fonction d'enregistrement des logs

Une fonction de journalisation a été implantée dans l'ensemble des scripts powershell. Son objectif est de pouvoir suivre l'exécution des scripts, les erreurs rencontrées et d'autres potentielles informations importantes.

Chaque script générera un fichier de log qui lui est propre afin d'améliorer le suivi des actions. 

Afin que les logs s'enregistrent correctement, il faudra faire l'appel à la fonction à chaque potentiel objectif atteint (ou non) par le script. Il faudra également adapter le message en fonction du résultat. 
Par exemple
```
Write-Log -Message "Déplacement de l'ordinateur $NomOrdinateur dans l'UO $UOCible" -EntryType "Information"
```

Ainsi la fonction inscrira dans le journal correspondant le script exécuté et son résultat, tout en fournissant l'EntryType, c'est à dire un message d'Information en cas d'exécution correcte, d'Erreur en cas d'exécution avortée ou d'Avertissement en cas d'exécution incomplète.
Voici la base de la fonction

```
# Fonction pour ajouter un élément aux logs
Function Write-Log {
    param (
        [string]$Message,
        [string]$JournalName = "NomJournal",
        [string]$Source = "ScriptExecuté",
        [ValidateSet("Information", "Warning", "Error")]
        [string]$EntryType = "Information"
    )
    # Vérification / Création du journal d'événements
    if (-not [System.Diagnostics.EventLog]::SourceExists($Source)) {
        [System.Diagnostics.EventLog]::CreateEventSource($Source, $JournalName)
    }    
    Write-EventLog -LogName $JournalName -Source $Source -EntryType $EntryType -EventId "numéro d'event" -Message $Message
}
```
