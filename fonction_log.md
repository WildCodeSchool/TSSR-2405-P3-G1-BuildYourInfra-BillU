# **Mise en place d'une fonction de journalisation**
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