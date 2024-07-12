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


### FAQ (Foire aux Questions)

Solutions aux problèmes connus et fréquents rencontrés lors de l'installation et de la configuration.

1. **Problème** : 
    
    - Solution : 
2. **Problème** : 
    
    - Solution : 
