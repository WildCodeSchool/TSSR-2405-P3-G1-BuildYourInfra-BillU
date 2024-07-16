## Mise en place de l'infrastructure : création d'un domaine AD et installation, configuration du LAB virtuel via les VMs

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



## Étapes d'installation et de configuration pour les objectifs du sprint 1 : 

### Etape 1 : Installation et configuration des serveurs WINDOWS
   
### **Serveur WINSERV**
Il s'agit ici du serveur principal de notre réseau. Pour une question de confort, il est en installation graphique. Il concentre différents rôles : DHCP, DNS et Active Directory. Nous avons conservé la plage IP du réseau existant.

#### **Rôle DHCP**
Le rôle DHCP (Dynamic Host Configuration Protocol) a pour objectif de permettre une attribution dynamique des adresses IP aux machines de notre réseau. 
* Il attribue automatiquement une adresse IP aux appareils connectés au réseau, un gain de temps par rapport à une installation manuelle.
* L'automatisation permet de réduire les risques d'erreurs humaines liés à cette même installation manuelle ainsi que les conflits d'adresses IP.
* Il peut être configuré pour distribuer des adresses en fonction du sous-réseau de l'appareil et permet une adaptation simple aux évolutions du réseau.

Actuellement, une seule étendue (plage d'adresses distribuable) a été configurée sur le serveur (le sous réseau relatif à la salle des serveurs). A terme, on totalisera 10 sous-réseaux : un par département, afin d'optimiser la sécurité du réseau global.
* Si un sous-réseau est compromis, on évite la propagation des effets sur l'ensemble du réseau.
* En plus de réduire l'impact, on réduit aussi la zone à vérifier lors d'un incident.
* Des règles de pare-feu spécifiques et des politiques de sécurité adaptées peuvent être imposées à différents sous-réseaux afin de limiter le trafic.
* Cela permettra également d'optimiser les ressources et les performances.

#### **Rôle DNS**
Le rôle DNS a été installé automatiquement lors de l'installation de l'Active Directory. Sa finalité est de traduire les noms de domaine en adresses IP pour permettre aux utilisateurs d'accéder aux ressources du réseau via des noms plus que des adresses. 
* Il permet une simplification de la navigation réseau.
* Il permet de réduire les temps de connexion (résolutions de noms en cache).
* Il permet une gestion centralisée des noms de domaine ce qui facilite la maintenance.
* Il peut être configuré pour contrôler l'accès aux ressources.

Le domaine employé par l'entreprise est le domaine "BillU.Paris".

#### **Rôle Active Directory**


### **Serveur WINSERV-BACKUP**
Il s'agit d'un serveur Back-Up si le serveur principal venait à tomber. Nous avons opté pour une version Core, plus légère et moins gourmande en ressources.
Le rôle Active Directory et DNS lui on été alloué, afin de maintenir le réseau en cas de panne. Pour cela, nous l'avons promu en contrôleur de domaine.
#### ajoute des utilisateur depuis un fichié XLSX
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

### Etape 2 : Installation et configuration du serveur DEBIAN et du Client WINDOWS 10 PRO puis intégration dans l'AD

### Partie 1 : DEBIAN

#### A. Mettre à jour le système

**But :** Assurer que le système dispose des dernières mises à jour de sécurité et des paquets.

```bash
sudo apt update sudo apt upgrade -y
```
#### B. Installer les paquets nécessaires

**But :** Installer les outils et services nécessaires pour intégrer Debian à un domaine Active Directory et pour gérer les comptes AD.

```bash
sudo apt install realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit
```
**Explications des paquets :**

- `realmd` : Découverte et jonction à des domaines AD.
- `sssd` : Gestion des services d'authentification pour les utilisateurs AD.
- `sssd-tools` : Outils supplémentaires pour `sssd`.
- `libnss-sss` et `libpam-sss` : Intégration des services `sssd` avec NSS (Name Service Switch) et PAM (Pluggable Authentication Modules).
- `adcli` : Utilitaire pour rejoindre et gérer les comptes d'un domaine AD.
- `samba-common-bin` : Outils de ligne de commande pour Samba.
- `oddjob` et `oddjob-mkhomedir` : Création automatique de répertoires home pour les utilisateurs.
- `packagekit` : Interface pour la gestion des paquets.

#### C. Découvrir le domaine AD

**But :** Vérifier que le domaine Active Directory est accessible et obtenir des informations sur ce domaine.

```bash
sudo realm discover BillU.Paris
```
#### D. Joindre la machine au domaine AD

**But :** Intégrer la machine Debian au domaine Active Directory.

```bash
sudo realm join --user=Administrator BillU.Paris
```

**Explication :** `Administrator` est un compte utilisateur AD avec les droits nécessaires pour ajouter des machines au domaine. Vous serez invité à entrer le mot de passe de cet utilisateur.

#### E. Configurer `sssd` pour utiliser les comptes AD

1. **Créer le fichier de configuration sssd.conf :**
    
    
```bash    
sudo nano /etc/sssd/sssd.conf
```

2. **Ajouter la configuration suivante :**
    
    
```ini
[sssd]
services = nss, pam
config_file_version = 2
domains = BillU.Paris

[domain/BillU.Paris]
ad_domain = BillU.Paris
krb5_realm = BILLU.PARIS
realmd_tags = manages-system joined-with-samba
cache_credentials = True
id_provider = ad
access_provider = ad
fallback_homedir = /home/%u@%d
ldap_id_mapping = True
use_fully_qualified_names = True
simple_allow_users = *@BillU.Paris

```    

3. **Définir les permissions appropriées pour le fichier :**
    
    
```bash
sudo chmod 600 /etc/sssd/sssd.conf
```
    

**Explications :**


- **services = nss, pam :** Spécifie les services que SSSD doit fournir. `nss` permet à SSSD de gérer la résolution d'identifiants via NSS (Name Service Switch), tandis que `pam` permet l'intégration de SSSD avec PAM (Pluggable Authentication Modules) pour l'authentification.
    
- **config_file_version = 2 :** Indique la version du format de fichier de configuration utilisé par SSSD.
    
- **domains = BillU.Paris :** Liste les domaines gérés par SSSD. Dans ce cas, `BillU.Paris` est le domaine Active Directory que SSSD va gérer.

- **ad_domain = BillU.Paris :** Spécifie le nom du domaine Active Directory que SSSD va gérer.
    
- **krb5_realm = BILLU.PARIS :** Définit le realm Kerberos associé au domaine AD pour l'authentification sécurisée.
    
- **realmd_tags = manages-system joined-with-samba :** Étiquettes spéciales utilisées par Realmd pour gérer le système et intégrer avec Samba.
    
- **cache_credentials = True :** Active la mise en cache des informations d'identification des utilisateurs pour améliorer les performances et la disponibilité en cas de déconnexion du domaine.
    
- **id_provider = ad :** Indique que SSSD doit utiliser le fournisseur d'identité AD pour récupérer les informations d'identification et les informations sur les utilisateurs à partir d'Active Directory.
    
- **access_provider = ad :** Utilise AD comme fournisseur pour gérer les accès, permettant de contrôler les autorisations basées sur les groupes AD.
    
- **fallback_homedir = /home/%u@%d :** Spécifie le répertoire home par défaut pour les utilisateurs lorsque le répertoire home défini dans AD n'est pas disponible.
    
- **ldap_id_mapping = True :** Active la cartographie des identifiants LDAP, permettant à SSSD de mapper les identifiants AD aux identifiants Unix.
    
- **use_fully_qualified_names = True :** Utilise les noms complets qualifiés pour les utilisateurs et les groupes AD, assurant une référence unifiée des objets AD.
    
- *_simple_allow_users = _@BillU.Paris :__ Autorise tous les utilisateurs du domaine `BillU.Paris` à se connecter. Cette option est pratique pour permettre à tous les utilisateurs du domaine d'accéder au système sans spécifier chaque utilisateur individuellement.

#### F. Démarrer et activer les services `sssd` et `oddjobd`

**But :** S'assurer que `sssd` et `oddjobd` démarrent et sont activés au démarrage.


```bash

sudo systemctl start sssd
sudo systemctl enable sssd
sudo systemctl start oddjobd
sudo systemctl enable oddjobd
```
#### G. Autoriser les utilisateurs du domaine à se connecter via SSH

1. **Éditer le fichier de configuration SSH :**
    
    
```bash
    sudo nano /etc/ssh/sshd_config
```    

2. **Ajouter ou modifier les lignes suivantes :**
    
    
```ini
    UseDNS no AllowUsers *@BillU.Paris
 ````
    
3. **Redémarrer le service SSH :**
    
    
```bash
    sudo systemctl restart ssh
```
    

**Explications :**

- `UseDNS no` : Désactive la recherche DNS inversée pour accélérer les connexions SSH.
- `AllowUsers *@BillU.Paris` : Autorise uniquement les utilisateurs du domaine `BillU.Paris` à se connecter via SSH.

#### E. Configuration de PAM pour l'authentification SSH

1. **Configurer PAM pour la création automatique des répertoires homes :**
    
    
```bash   
    sudo nano /etc/pam.d/common-session
```
    
2. **Ajouter la configuration suivante à la fin du fichier :**
    
    
```bash    
session required pam_mkhomedir.so skel=/etc/skel/ umask=0077
```
   
    
3. **Enregistrer et quitter le fichier.**
    

### Redémarrage du service SSH

Après avoir configuré PAM, redémarrez le service SSH pour appliquer les modifications :


```bash
sudo systemctl restart ssh
```

#### H. Configurer le pare-feu pour autoriser SSH

**But :** S'assurer que le pare-feu autorise les connexions SSH.

1. **Installer et configurer UFW :**
    
    
```bash
    sudo apt install ufw sudo ufw allow ssh sudo ufw enable
```
### I. Vérification des configurations

1. **Vérifier les services :**
    

```bash
    sudo systemctl status sssd
    sudo systemctl status oddjobd 
    sudo systemctl status ssh
`````

1. **Tester la connexion SSH depuis une autre machine :**
    
    
```bash
    ssh nom_utilisateur@adresse_ip_du_serveur
```   

### Partie 2. Configuration de la VM Client Windows 10

#### A. Joindre le client Windows 10 au domaine AD

1. **Ouvrir le Panneau de configuration.**
2. **Aller dans Système et sécurité > Système.**
3. **Cliquer sur Modifier les paramètres sous Nom de l’ordinateur, domaine et paramètres de groupe de travail.**
4. **Cliquer sur Modifier et sélectionner Domaine, puis entrer le nom de domaine (BillU.Paris).**
5. **Entrer les informations d’identification d'un compte avec les droits nécessaires pour ajouter des machines au domaine.**
6. **Redémarrer la machine pour appliquer les modifications.**

#### B. Configurer un client SSH sur Windows 10

1. **Vous pouvez utiliser le client SSH intégré de Windows 10.**
    
2. **Ouvrir PowerShell ou cmd et taper la commande suivante pour tester la connexion SSH :**
    
    
```powershell
    ssh nom_utilisateur@adresse_ip_du_serveur
````

3. **Remplacer `nom_utilisateur` par un utilisateur du domaine AD et `adresse_ip_du_serveur` par l’adresse IP de votre serveur Debian.**
    

### C. Création d'un compte utilisateur AD pour l'accès SSH

1. **S'assurer que l'utilisateur AD a les permissions nécessaires pour se connecter via SSH au serveur Debian.**
    
2. **Depuis la VM Windows 10, ouvrir PowerShell ou cmd et se connecter au serveur Debian en utilisant SSH :**
    

```powershell
    ssh nom_utilisateur@adresse_ip_du_serveur
```    


### Etape 3 : Automatisation via script : à partir d'un fichier CSV, création des comptes d'utilisateur, des groupes pour rejoindre les machines au domaine AD.

```powershell

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

### FAQ (Foire aux Questions)

Solutions aux problèmes connus et fréquents rencontrés lors de l'installation et de la configuration.

RAS pour le sprint 1
