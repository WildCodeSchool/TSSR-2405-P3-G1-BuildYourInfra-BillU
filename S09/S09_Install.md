### Prérequis techniques

| Fonction de la VM          | Serveur                     | Serveur             |  Serveur          | Client         |
| -------------------------- | --------------------------- | ------------------- | ----------------- | -------------- |
| Nom                        | G1-SERV-WinGui              |  G1-SERV-WinCore    |   G1-SERV-DEBIAN  | CLIENT3        |
| OS                         | Windows Server 2022         | Windows Server 2022 |    Debian 12      | Windows 10     |
| OS version                 | Standard Desktop Experience | Standard            |   12 (Bookworm)   | Professionnel  |
| RAM                        | 4/8 Go                      | 2/4 Go              |   2/4 Go          | 2/4 Go         |
| Langue à installer         | English (US)                | English (US)        |    English (US)   | French         |
| Time and currency/keyboard | French                      | French              |    French         | French         |
| Carte réseau               | Réseau privé                | Réseau privé        |    Réseau privé   | Réseau privé   |
| Adresse IP                 | 172.18.1.x/24               | 172.18.1.x/24       |    172.18.1.x/24  |  172.18.2.x/24 |
| DNS                        | 172.18.1.x                  | 172.18.1.x          |    172.18.1.x/24  | 172.18.1.x     |
| Utilisateur local          | Administrator               | Administrator       |     Wilder        | Wilder         |
| Firewall                   | Désactivé                   | Désactivé           |     Désactuvé     | Désactivé      |



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

### FAQ (Foire aux Questions)

Solutions aux problèmes connus et fréquents rencontrés lors de l'installation et de la configuration.

1. **Problème** : 
    
    - Solution : 
2. **Problème** : 
    
    - Solution : 
