# Ce script s'exécutera quotidiennement à une heure fixe


# Fonction pour ajouter un élément aux logs
Function Write-Log {
    param (
        [string]$Message,
        [string]$JournalName = "Add_to_Domain_Script",
        [string]$Source = "Add_to_domain_script",
        [ValidateSet("Information", "Warning", "Error")]
        [string]$EntryType = "Information"
    )
    # Vérification / Création du journal d'événements
    if (-not [System.Diagnostics.EventLog]::SourceExists($Source)) {
        [System.Diagnostics.EventLog]::CreateEventSource($Source, $JournalName)
    }    
    Write-EventLog -LogName $JournalName -Source $Source -EntryType $EntryType -EventId 1 -Message $Message
}
# Initialisation de la variable nom de domaine
$NomdeDomaine = "BillU.Paris"

# Etablissement de prefixes selon le chemin de l'OU cible
$DictionnairePrefixes = @{
    "COMPUB" = "OU=Communication et relations publiques,DC=BillU,DC=Paris"
    "JUR"    = "OU=Departement juridique,DC=BillU,DC=Paris"
    "DEV"    = "OU=Developpement logiciel,DC=BillU,DC=Paris"
    "DIR"    = "OU=Direction,DC=BillU,DC=Paris"
    "DSI"    = "OU=DSI,DC=BillU,DC=Paris"
    "FIN"    = "OU=Finances et comptabilité,DC=BillU,DC=Paris"
    "QHSE"   = "OU=QHSE,DC=BillU,DC=Paris"
    "COM"    = "OU=Service commercial,DC=BillU,DC=Paris"
    "REC"    = "OU=Service recrutement,DC=BillU,DC=Paris"
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
    }
    catch { 
        #Inscription de l'erreur dans les logs
        Write-Log -Message "Erreur lors du déplacement de l'ordinateur $NomOrdinateur vers l'UO $UOCible. Détails: $_" -EntryType "Error"

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
    #Inscription dans les logs du déplacement de l'ordinateur dans l'UO
    Write-Log -Message "Déplacement de l'ordinateur $NomOrdinateur dans l'UO $UOCible" -EntryType "Information"
}