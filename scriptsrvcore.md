# ** Script Powershell : automatisation du déploiement du rôle ADDS sur serveur Core **

## ** Pré-requis **
* Un serveur Windows Core relié au réseau de l'entreprise
* Un fichier de configuration contenant : le nom du serveur, l'adresse IP du DNS, le nom du domaine AD, le nom de l'administrateur, le mot de passe. Ce fichier sera chiffré plus tard pour éviter une potentielle faille de sécurité.
* Une console PowerShell

## ** Séquences du script**

Le script va tout d'abord récupérer le contenu de notre fichier de configuration et créer des variables en exploitant ce contenu.

Par la suite, il va mettre à jour le nom de la machine et  la configuration réseau : adresse IP¨et adresse DNS.

Il va ensuite installer le rôle ADDS et joindre le serveur au domaine.

```
#Lire le fichier de configuration
$ConfigContent = Get-Content -Path "Chemin/vers/fichier/config.txt"

# Convertir le contenu du fichier pour en extraire des variables
$config = @{}
    foreach ($line in $ConfigContent) {
        $key, $value = $line -split "="
        $config[$key] = $value
    }

# chaque ligne va être enregistré sous la forme $config["information"] par exemple pour la ligne
# server-name=WINSERV-BACKUP il enregistrera la variable $config["server-name"] = "WINSERV-BACKUP"
# on obtient les variables $config["server-name"] ; $config["IPServ"] ; $config["IPDNS"] ; $config["DomainName"] ; $config["AdminUser"] ; $config["adminPW"] qui seront exploitées dans la suite du script

# Sécuriser le mot de passe
$PWSec = ConvertTo-SecureString $config["adminPW"] -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($config["AdminUser"], $PWSec)

# Renommer le serveur
Rename-Computer -NewName $config["server-name"] -Force

# Configurer l'adresse IP de la machine
New-NetIPAddress -IPAddress $config["IPServ"] -PrefixLength "24" -InterfaceIndex (Get-NetAdapter).ifIndex

# Configurer l'adresse du DNS
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ($config["IPDNS"])

# Installer le rôle ADDS
Add-WindowsFeature -Name "AD-Domain-Services" -IncludeManagementTools -IncludeAllSubFeature

# Installer le rôle DNS
Add-WindowsFeature -Name "DNS" -IncludeManagementTools -IncludeAllSubFeature

# Ajouter le serveur au domaine
# Concernant le mot de passe la ligne sera amenée à changer pour sécuriser la donnée
# Add-Computer -DomainName $config["DomainName"] -Credential (NewObject PSCredential -ArgumentList $config["AdminUser"], $config["AdminPW"])

Add-Computer -DomainName $config["DomainName"] -Credential $cred

# Installer le rôle ADDS et promouvoir le serveur en contrôleur de domaine
Import-Module ADDSDeployment
# Install-ADDSDomainController -DomainName "BillU.Paris" -InstallDns -Credential (Get-Credential) -SiteName "Default-First-Site-Name" -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -Force

Install-ADDSDomainController -DomainName "BillU.Paris" -InstallDns -Credential $cred -SiteName "Default-First-Site-Name" -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -Force
```