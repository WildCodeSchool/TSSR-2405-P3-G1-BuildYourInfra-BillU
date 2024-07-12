### Prérequis techniques

| Fonction de la VM          | Serveur                     | Serveur             |  Serveur          | Client         |
| -------------------------- | --------------------------- | ------------------- | ----------------- | -------------- |
| Nom                        | G1-SERV-WinGui              |  G1-SERV-WinCore    |   G1-SERV-DEBIAN  | G1-CLIENT-WIN10        |
| OS                         | Windows Server 2022         | Windows Server 2022 |    Debian 12      | Windows 10     |
| OS version                 | Standard Desktop Experience | Standard            |   12 (Bookworm)   | Professionnel  |
| RAM                        | 4/8 Go                      | 2/4 Go              |   2/4 Go          | 2/4 Go         |
| Langue à installer         | English (US)                | English (US)        |    English (US)   | French         |
| Time and currency/keyboard | French                      | French              |    French         | French         |
| Carte réseau               | Réseau privé                | Réseau privé        |    Réseau privé   | Réseau privé   |
| Adresse IP                 | 172.18.1.250/24               | 172.18.1.251/24       |    172.18.1.60/24  |  172.18.2.20/24 |
| DNS                        | 172.18.1.250                  | 172.18.1.250          |    172.18.1.250  | 172.18.1.250     |
| Utilisateur local          | Administrator               | Administrator       |     Wilder        | Sysadmin         |
| Firewall                   | Désactivé                   | Désactivé           |  Régles allow :SSH et ICMP4     | Régles allow: SSH et ICMP4      |



### Étapes d'installation et de configuration : Création d'un domaine AD

#### Etape 1 : 
   
   -
   -   
### ajoute des utilisateur depuis un fichié XLSX
#### Pré-requis
- Active Directory installé et un domaine créé
- Avoir installé le module ImportExcel
- Avoir les droits pour exécuter un script et ajouter des utilisateurs au domaine visé
#### Fonctionnement du script
- Renseignez le chemin de votre fichier .xlsx et le nom de votre domaine dans le script
- Vous pouvez changer le mot de passe également, à la première connexion des utilisateurs créés il sera demandé de le changer
- Le script créera les UO et le groupe qui n'existent pas et placera automatiquement les utilisateurs
##### Attention
Les caractères spéciaux dans le fichier xlsx peuvent engendrer des erreurs


```
# Importer les modules nécessaires
Import-Module ActiveDirectory
Import-Module ImportExcel

# Chemin vers le fichier Excel
$excelPath = "C:\le\chemin\DeTon\fichier.xlsx" # ENTRE LE CHEMIN DE TON FICHIER XLSX

# Fonction pour vérifier et créer une OU si elle n'existe pas
function Ensure-OUExists {
    param (
        [string]$ouPath
    )
    
    if (-not (Get-ADOrganizationalUnit -Filter { DistinguishedName -eq $ouPath } -ErrorAction SilentlyContinue)) {
        Write-Host "Creating OU: $ouPath"
        New-ADOrganizationalUnit -Name $ouPath.Split(',')[0].Split('=')[1] -Path ($ouPath.Substring($ouPath.IndexOf(',') + 1))
    } else {
        Write-Host "OU exists: $ouPath"
    }
}

# Fonction pour vérifier et créer un groupe s'il n'existe pas
function Ensure-GroupExists {
    param (
        [string]$groupName,
        [string]$groupPath
    )
    
    if (-not (Get-ADGroup -Filter { Name -eq $groupName } -SearchBase $groupPath -ErrorAction SilentlyContinue)) {
        Write-Host "Creating Group: $groupName in $groupPath"
        New-ADGroup -Name $groupName -Path $groupPath -GroupScope Global -GroupCategory Security
    } else {
        Write-Host "Group exists: $groupName"
    }
}

# Lire les données du fichier Excel
try {
    $users = Import-Excel -Path $excelPath
    Write-Host "Successfully imported Excel file."
} catch {
    Write-Host "Failed to import Excel file: $_"
    exit
}

# Domaine et contexte de base pour les OU et groupes
$baseDomain = "DC=DOMAIN,DC=COM" # REMPLACE PAR TON NOM DE DOMAINE

# Boucle à travers chaque utilisateur dans le fichier Excel
foreach ($user in $users) {
    $givenName = $user.Prenom
    $surname = $user.Nom
    $samAccountName = "$($givenName.Substring(0,1).ToLower())$($surname.ToLower())"
    $userPrincipalName = "$($samAccountName)@DOMAINE.LAN" # REMPLACE PAR LE NOM DE TON DOMAINE
    $password = "Azerty1*!"  # Mot de passe par défaut, à changer selon la politique de sécurité

    # Construire le chemin de l'OU basé sur le département
    $ouPath = "OU=$($user.Departement),$baseDomain"

    # Vérifier et créer l'OU si nécessaire
    Ensure-OUExists -ouPath $ouPath

    # Vérifier et créer le groupe si nécessaire
    $groupName = $user.Service
    Ensure-GroupExists -groupName $groupName -groupPath $ouPath

    Write-Host "Processing user: $($givenName) $($surname)"
    Write-Host "SamAccountName: $samAccountName"
    Write-Host "UserPrincipalName: $userPrincipalName"
    Write-Host "OU Path: $ouPath"
    Write-Host "Group: $groupName"

    try {
        # Créer le compte utilisateur dans Active Directory
        New-ADUser `
            -Name "$givenName $surname" `
            -GivenName $givenName `
            -Surname $surname `
            -SamAccountName $samAccountName `
            -UserPrincipalName $userPrincipalName `
            -Path $ouPath `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -Enabled $true `
            -PasswordNeverExpires $false `
            -ChangePasswordAtLogon $true `
            -Department $user.Departement `
            -Title $user.fonction `
            -EmailAddress $userPrincipalName `
            -OfficePhone $user.'Telephone fixe' `
            -MobilePhone $user.'Telephone portable'

        Write-Host "User $givenName $surname created successfully."

        # Ajouter l'utilisateur au groupe
        Add-ADGroupMember -Identity $groupName -Members $samAccountName
        Write-Host "Added $($samAccountName) to group $($groupName)."
    } catch {
        Write-Host "Failed to create user $givenName $surname" 
    }
}
```
# Documentation Active Directory (AD)

L'Active Directory est un service d'annuaire développé par Microsoft pour les environnements de réseaux Windows. Il permet de stocker des informations sur les objets du réseau et de les rendre facilement accessibles pour les utilisateurs et les administrateurs.

## Fonctionnalités principales de l'AD

- **Gestion des utilisateurs et des groupes** : AD facilite la création, la gestion et la sécurité des comptes utilisateurs et des groupes de sécurité.
- **Gestion des ressources** : L'AD permet de gérer des ressources comme les ordinateurs, les imprimantes et les applications.
- **Authentification et autorisation** : Des services d'authentification et d'autorisation sont offerts par AD aux utilisateurs et aux ordinateurs du réseau.
- **Politiques de groupe (Group Policies)** : Grâce à des objets de stratégie de groupe (GPO), AD permet de définir et mettre en œuvre des configurations et des politiques de sécurité sur les ordinateurs et les utilisateurs.

## La configuration de l'Active Directory

Il est possible d'organiser la structure d'un Active Directory de différentes manières en fonction des besoins de l'entreprise. L'un des choix essentiels consiste à décider si l'AD sera organisé par département ou par service.

### Pour quelle raison organiser l'AD par département ?

Il existe plusieurs bénéfices à structurer l'Active Directory par département par rapport à une structure par service :

#### Alignement organisationnel

La structure hiérarchique de l'organisation est souvent en accord avec les départements, ce qui simplifie la gestion des utilisateurs et des ressources en fonction des responsabilités et des rôles réels au sein de l'entreprise.

#### Gestion simplifiée des droits d'accès

Lorsque les utilisateurs sont regroupés par département, il est possible de définir les politiques d'accès et les permissions de manière plus claire et homogène. Cela simplifie la gestion des autorisations d'accès.

#### Déploiement des stratégies de groupe

Il est plus avantageux d'appliquer les stratégies de groupe (GPO) sur des départements spécifiques, car les besoins et les configurations peuvent différer d'un département à l'autre.

#### Reporting et audits

La structure par département facilite le reporting et les audits de sécurité. Il devient plus simple de surveiller qui a accès à quelles ressources et de repérer les éventuelles anomalies ou violations.

#### Évolution et flexibilité

Le changement des départements est moins fréquent que celui des services ou des projets. Ainsi, une organisation par départements permet d'assurer une stabilité accrue et de réorganiser moins fréquemment.

#### Meilleure communication et collaboration

Les départements rassemblent fréquemment des équipes qui collaborent étroitement. Améliorer la communication et la collaboration en organisant l'AD par département peut favoriser le partage de ressources et d'informations au sein du même département.

### Comparaison avec la structure par service

#### Complexité accrue

Il peut devenir difficile de gérer une structure par service, en particulier dans les grandes organisations où les services sont nombreux et peuvent se superposer en termes de responsabilités et de ressources.

#### Changements fréquents

Les services ont la possibilité de changer plus souvent en fonction des projets ou des priorités stratégiques, ce qui exige des ajustements réguliers dans l'AD.

#### Droits d'accès redondants

Il est possible qu'il y ait une répétition des droits d'accès, ce qui rend la gestion des permissions plus complexe et accroît les risques de failles de sécurité.

## Conclusion

En conclusion, la structuration de l’Active Directory par département favorise une gestion plus structurée, sécurisée et efficace des ressources et des utilisateurs. Cela permet une meilleure adéquation avec la structure de l’organisation, facilite la gestion des accès et des politiques, et permet une adaptation plus aisée aux évolutions organisationnelles à long terme.

# Sauvegarde de l'Active Directory avec Windows Server Backup

## Windows Server Backup est un outil intégré à Windows Server qui permet de sauvegarder l'Active Directory. Voici les étapes pour réaliser cette opération :
Prérequis : Veuillez vous assurer que Windows Server Backup est correctement installé sur votre serveur.
Initialisation de Windows Server Backup :
1. Ouvrez le Gestionnaire de serveur.
2. Accédez à "Outils" > "Windows Server Backup".
Planification d'une Sauvegarde :
1. Cliquez sur "Planificateur de sauvegarde..." pour établir des sauvegardes régulières.
2. Choisissez "Serveur complet" afin d'inclure l'Active Directory.
3. Configurez le calendrier et les destinations de sauvegarde (par exemple, disques durs locaux, partages réseau).
Réalisation d'une Sauvegarde Manuelle :
Pour une sauvegarde manuelle, veuillez utiliser la commande suivante dans PowerShell en tant qu'administrateur :
powershell
Copier le code
wbadmin start systemstatebackup -backuptarget:D:
Veuillez remplacer D: par le chemin du lecteur où vous souhaitez stocker la sauvegarde de l'Active Directory.
Transfert de la Sauvegarde vers un Autre Serveur :
Une fois la sauvegarde effectuée, il est possible d'utiliser Robocopy ou PowerShell pour transférer les données vers un autre serveur. Voici comment procéder avec Robocopy :
Utilisation de Robocopy :
Robocopy est un outil en ligne de commande efficace et flexible pour la copie des fichiers. Voici un exemple de commande Robocopy pour déplacer la sauvegarde vers un autre serveur distant :
batch
Copier le code
robocopy D:\Backup \\AutreServeur\PartageBackup /MIR /Z /LOG:D:\Backup\RobocopyLog.txt

D:\Backup : Chemin local de la sauvegarde.
\\AutreServeur\PartageBackup : Chemin réseau du serveur distant où vous souhaitez copier la sauvegarde.
/MIR : Miroir, copie récursive (supprime les fichiers supprimés dans la source).
/Z : Copie en mode restartable (utile pour les connexions réseau lentes).
/LOG:D:\Backup\RobocopyLog.txt : Optionnel, pour enregistrer les détails de la copie dans un fichier journal.
Exemple Complet en PowerShell
Si vous préférez utiliser PowerShell pour automatiser la sauvegarde et la copie vers un autre serveur, voici un exemple complet :
powershell
Copier le code

# Variables de configuration
$backupLocation = "D:\Backup\ActiveDirectoryBackup"
$remoteServer = "\\AutreServeur\PartageBackup"
$logFile = "$backupLocation\RobocopyLog.txt"

# Effectuer la sauvegarde de l'Active Directory
wbadmin start systemstatebackup -backuptarget:$backupLocation

# Vérifier si la sauvegarde a été réalisée avec succès
if ($?) {
    Write-Output "Sauvegarde de l'Active Directory complétée avec succès."

    # Utiliser Robocopy pour copier la sauvegarde vers le serveur distant
    robocopy $backupLocation $remoteServer /MIR /Z /LOG:$logFile

    if ($LASTEXITCODE -eq 0) {
        Write-Output "Transfert de la sauvegarde vers le serveur distant complété avec succès."
    } else {
        Write-Error "Le transfert de la sauvegarde vers le serveur distant a échoué."
    }
} else {
    Write-Error "La sauvegarde de l'Active Directory a échoué."
}
## Planification et Automatisation

Afin d'automatiser ledit processus, il est envisageable de créer une tâche planifiée dans le Planificateur de tâches de Windows afin d'exécuter le script PowerShell à des intervalles réguliers. Il est vivement recommandé de procéder à des tests périodiques sur vos sauvegardes ainsi que sur les processus de récupération pour vous assurer qu'ils fonctionnent correctement en cas de nécessité.
En adoptant ces démarches, vous pourrez sécuriser efficacement vos données Active Directory en réalisant des sauvegardes fréquentes et en les dupliquant vers un site distant pour une redondance et une sécurité accrues.

## Comment créer une backup de notre serveur.

La mise en place d'une sauvegarde régulière de notre serveur s'avère indispensable afin d'assurer la protection de nos données et garantir la continuité de nos activités en cas d'incident majeur. Le choix de la méthode la plus appropriée dépendra de notre configuration spécifique et de nos exigences particulières. 

Voici quelques techniques classiques pour effectuer une sauvegarde du serveur :
Méthodes de Sauvegarde
Sauvegardes Locales
Stockage sur disque dur externe : Il convient de connecter un disque dur externe à notre serveur et d'y copier manuellement nos fichiers, ou bien d'utiliser un logiciel dédié à la sauvegarde pour automatiser cette opération.

Partage réseau : La possibilité existe également de sauvegarder nos fichiers sur un autre serveur ou sur un NAS (Network Attached Storage) présent dans notre réseau.
Sauvegardes Hors Site
Stockage cloud : Nous pouvons recourir à un service de stockage cloud tel que Microsoft Azure ou Amazon S3 pour archiver nos sauvegardes.
Bandes magnétiques : L'utilisation de bandes magnétiques permet également le stockage hors ligne des sauvegardes.
Logiciels de Sauvegarde : Une variété de logiciels gratuits et payants sont disponibles pour assister dans le processus de sauvegarde. Ces outils peuvent automatiser les opérations, offrir des options flexibles en termes de planification, ainsi que permettre la création de sauvegardes différentielles et incrémentielles.
Règles de sauvegarde
Règle 3.2.1 : Effectuez 3 copies de nos données, 2 sur des supports différents et 1 hors site.
Testez nos sauvegardes régulièrement : Assurer que nous pouvons restaurer nos sauvegardes en cas de sinistre.
Mettre à jour nos sauvegardes régulièrement : effectuez des sauvegardes complètes régulièrement et des sauvegardes incrémentielles ou différentielles plus fréquemment.
Création d'un Script pour la Sauvegarde Automatisée d'un Serveur Virtuel
Mise en place d'un Script pour la Sauvegarde Automatisée d'un Serveur Virtuel
L'automatisation de la sauvegarde de notre serveur virtuel à l'aide d'un script permet non seulement de gagner du temps, mais aussi de garantir la cohérence des sauvegardes. Voici les étapes générales à suivre :
Choix du Langage de Script
PowerShell : Pour les systèmes Windows.
Bash : Pour les systèmes Linux.
Python : Adapté à une variété de tâches d'automatisation.
Étapes du Script
Connexion au serveur virtuel : Établissement d'une connexion avec le serveur virtuel via SSH pour Linux ou PowerShell pour Windows.
Identification des fichiers à sauvegarder : Identification des fichiers et des répertoires spécifiques à sauvegarder.
Création de la destination de sauvegarde : Création d'un emplacement destiné au stockage des fichiers de sauvegarde (disque dur local, NAS, stockage cloud).
Exécution de la sauvegarde : Utilisation d'une commande appropriée pour copier les fichiers vers l'emplacement dédié à la sauvegarde.
Vérification de la sauvegarde : Vérification que la sauvegarde a été réalisée avec succès.
Gestion des anciennes sauvegardes : Archivage ou suppression des anciennes sauvegardes afin de libérer de l'espace de stockage.

Exemple de Script de Sauvegarde (Bash)
bash
Copier le code
#!/bin/bash

# Configuration
SOURCE_DIR="/votre/chemin/vers/source"   # Remplacez par le chemin correct
BACKUP_DIR="/votre/chemin/vers/backup"   # Remplacez par le chemin correct et assurez-vous qu'il existe
REMOTE_BACKUP_DIR="user@remote:/votre/chemin/vers/remote/backup"  # Remplacez par le nom d'hôte ou l'adresse IP correct et le chemin correct
MYSQL_USER="username"                    # Remplacez par votre nom d'utilisateur MySQL
MYSQL_PASSWORD="password"                # Remplacez par votre mot de passe MySQL
DATABASE_NAME="database_name"            # Remplacez par le nom de votre base de données

# Date format for filenames
DATE=$(date +"%Y%m%d%H%M")

# Création du répertoire de sauvegarde s'il n'existe pas
mkdir -p $BACKUP_DIR

# Sauvegarde des fichiers
tar -czvf $BACKUP_DIR/files_backup_$DATE.tar.gz $SOURCE_DIR
if [ $? -ne 0 ]; then
    echo "Erreur lors de la sauvegarde des fichiers"
    exit 1
fi

# Sauvegarde de la base de données
mysqldump -u $MYSQL_USER -p$MYSQL_PASSWORD $DATABASE_NAME > $BACKUP_DIR/db_backup_$DATE.sql
if [ $? -ne 0 ]; then
    echo "Erreur lors de la sauvegarde de la base de données"
    exit 1
fi

# Synchronisation des sauvegardes vers un serveur distant
rsync -avz $BACKUP_DIR/files_backup_$DATE.tar.gz $REMOTE_BACKUP_DIR
if [ $? -ne 0 ]; then
    echo "Erreur lors de la synchronisation des fichiers de sauvegarde"
    exit 1
fi

rsync -avz $BACKUP_DIR/db_backup_$DATE.sql $REMOTE_BACKUP_DIR
if [ $? -ne 0 ]; then
    echo "Erreur lors de la synchronisation de la base de données de sauvegarde"
    exit 1
fi

# Nettoyage des anciennes sauvegardes (garder seulement les 7 derniers jours)
find $BACKUP_DIR -type f -mtime +7 -exec rm {} \;
if [ $? -ne 0 ]; then
    echo "Erreur lors du nettoyage des anciennes sauvegardes"
    exit 1
fi

# Fin du script
echo "Sauvegarde terminée pour $DATE"
exit 0


## Sécurisation des Sauvegardes
Chiffrement : Il est recommandé d'utiliser gpg pour chiffrer les sauvegardes.
bash
Veuillez trouver ci-dessous le code à copier :
gpg -c $BACKUP_DIR/files_backup_$DATE.tar.gz
gpg -c $BACKUP_DIR/db_backup_$DATE.sql
Contrôle d'accès : Il convient de limiter l'accès aux sauvegardes uniquement aux utilisateurs autorisés.
Tests de Récupération
Récupération Régulière : Il est impératif de réaliser des tests de récupération afin de garantir l'intégrité des sauvegardes et la capacité de restauration rapide.

## Conclusion
La mise en place d'une stratégie robuste et automatisée en matière de sauvegarde, incluant des mécanismes de redondance et de récupération, revêt une importance capitale pour assurer la protection de nos données et maintenir la continuité des opérations en cas d'incident. L'utilisation d'outils appropriés, la configuration adéquate de la redondance des sauvegardes et la vérification régulière de nos procédures de récupération sont essentielles pour garantir l'efficacité de notre stratégie globale en matière de sauvegarde.

### FAQ (Foire aux Questions)

Solutions aux problèmes connus et fréquents rencontrés lors de l'installation et de la configuration.

1. **Problème** : 
    
    - Solution : 
2. **Problème** : 
    
    - Solution : 
