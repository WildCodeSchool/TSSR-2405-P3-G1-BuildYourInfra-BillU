# Ce script s'exécutera quotidiennement à une heure fixe

# Initialisation de la variable nom de domaine
$NomdeDomaine = "BillU.Paris"

# Etablissement de prefixes selon le chemin de l'OU cible
$DictionnairePrefixes = @{
    "COMPUB" = "OU=Communication et relations publiques,DC=BillU,DC=Paris"
    "JUR" = "OU=Departement juridique,DC=BillU,DC=Paris"
    "DEV" = "OU=Developpement logiciel,DC=BillU,DC=Paris"
    "DIR" = "OU=Direction,DC=BillU,DC=Paris"
    "DSI" = "OU=DSI,DC=BillU,DC=Paris"
    "FIN" = "OU=Finances et comptabilité,DC=BillU,DC=Paris"
    "QHSE" = "OU=QHSE,DC=BillU,DC=Paris"
    "COM" = "OU=Service commercial,DC=BillU,DC=Paris"
    "REC" = "OU=Service recrutement,DC=BillU,DC=Paris"
}

# Fonction de déplacement des ordinateurs en fonction de son nom
function Deplacement-Ordinateur {
    param (
        [string]$NomOrdinateur
        [string]$UOCible
    )

    try {
        Get-ADComputer -Identity $NomOrdinateur | Move-ADObject -TargetPath $UOCible
# En cas d'erreur, le script continue
    } catch { 

    }
}

# Initialisation du nom de l'ordinateur cible
$NomOrdinateur = $env:COMPUTERNAME

# Initialisation de l'OU où sera déplacée l'ordinateur à partir de son nom
$Prefixe = $NomOrdinateur.Split("-")[0]
$UOCible = $DictionnairePrefixes[$Prefixe]

# Déplacer l'ordinateur dans la bonne UO
if ($UOCible -ne $null) {
    Deplacement-Ordinateur -NomOrdinateur $NomOrdinateur -UOCible $UOCible
}
