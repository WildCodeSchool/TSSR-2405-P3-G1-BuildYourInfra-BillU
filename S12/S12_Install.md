## Procédure d'installation de Windows LAPS avec Active Directory 
---
1. **Prérequis**:
    
    - Vérifiez la compatibilité des systèmes (Windows 10, Windows Server 2022 - 21H2).
    - Installez les mises à jour cumulatives d'avril 2023.
    - Assurez-vous que les contrôleurs de domaine et les machines à gérer sont à jour.
    
2. **Mise à jour du schéma Active Directory**:
    
    - Ouvrez PowerShell en tant qu'administrateur.
    - Exécutez `Get-Command -Module LAPS` pour vérifier l'accessibilité du module.
    - Importez le module et mettez à jour le schéma :
        
        
```powershell
        Import-Module LAPS Update-LapsADSchema -Verbose
```  

3. **Vérification des attributs LAPS**:
    
    - Dans la console "Utilisateurs et ordinateurs Active Directory", activez l'affichage avancé.
    - Vérifiez la présence des attributs LAPS (msLAPS-Password, msLAPS-EncryptedPassword, etc.).

  ![LAPS](/Ressources/Images/attribus_laps.png)


4. **Attribution des droits d'écriture aux machines**:
    
    - Donnez les autorisations nécessaires à l'OU ciblée :
        
        
```powershell
Set-LapsADComputerSelfPermission -Identity "OU=PC,DC=BillU,DC=Paris"
```

5. **Configuration de la GPO Windows LAPS**:
    

    - Importez les fichiers ADMX et ADML : 
    
	  - **C:\Windows\PolicyDefinitions\LAPS.admx**  : qui correspond aux modèles d'administration de Windows LAPS
	  - **C:\Windows\PolicyDefinitions\fr-FR\LAPS.adml**  : qui correspond au fichier de langue FR du fichier ADMX

	  Dans le magasin central SYSVOL :

	  -  Ce PC > Disque local (C:) > Windows > SYSVOL > sysvol > bILLU.paris > Policies > PolicyDefinitions >LAPS.admx
	  -  Ce PC > Disque local (C:) > Windows > SYSVOL > sysvol > bILLU.paris > Policies > PolicyDefinitions > en-US > LAPS.adml
 
 
6. Créez une nouvelle GPO sur le GPM                                    
    
    - Configuration ordinateur > Stratégies > Modèles d'administration > LAPS
    - Configurez le répertoire de sauvegarde de mot de passe sur "Active Directory".  
    - Définissez les paramètres de complexité et d'âge du mot de passe.  
    - Activez le chiffrement du mot de passe.    
    - Activez et configurez la taille de l'historique des mots de passe chiffrés.
       
         ![LAPS](/Ressources/Images/laps_gpofinal.png)
        
7. **Application des GPOs**:

```powershell
- Actualisez les GPOs sur les postes :
        
    gpupdate /force
     

-Actualisez les GPOs sur les postes :

    gpresult /r
````
       
  ![LAPS](/Ressources/Images/gporesult.png)  
  
8. **Récupérer le mot de passe généré par Windows LAPS**:  

Ces informations sont  visibles dans l'onglet "**LAPS**" de l'objet ordinateur en question à partir **des consoles d'administration de l'Active Directory**.

![LAPS](/Ressources/Images/laps_mdpclient.png)




9. **Tester le mdp généré en se connectant avec l'administrateur local du PC client**:

![LAPS](/Ressources/Images/Co_client.png)  

---
## 2 - SAUVEGARDE

### Sauvegarde sur un volume spécifique

Nous avons intégralement ajouté un volume spécifique de 10 Go afin de garantir la prise en charge adéquate des sauvegardes.
![Ajout du disque.1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Ajout%20du%20disque.1.png).

Nous procéderons ensuite à l'ajout du rôle Windows Server Backup dans le Gestionnaire de Serveur.
![Install et config Windows Server Backup.1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20%20%20Windows%20Server%20Backup.1.png).

![Install et config Windows Server Backup.2.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20%20Windows%20Server%20Backup.2.png).

![Install et config Windows Server Backup.3.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.3.png).

![Install et config Windows Server Backup.4.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.4.png).

![Install et config Windows Server Backup.5.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20%20Windows%20Server%20Backup.5.png).

![Install et config Windows Server Backup.6.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.6.png).

![Install et config Windows Server Backup.7.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20%20Windows%20Server%20Backup.7.png).

![Install et config Windows Server Backup.8.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20%20Windows%20Server%20Backup.8.png).

Une fois l'installation fini nous allons nous rendre sur le Computer Management pour initialiser le disque.
![Install et config Windows Server Backup.9.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20%20Windows%20Server%20Backup.9.png).

![Install et config Windows Server Backup.10.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.10.png).

![Install et config Windows Server Backup.11.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.11.png).

Nous allons maintenant nous rendre sur le Windows Server Backup
![Install et config Windows Server Backup.12.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.12.png).

![Install et config Windows Server Backup.13.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.13.png).

![Install et config Windows Server Backup.14.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.14.png).

![Install et config Windows Server Backup.15.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.15.png).

![Install et config Windows Server Backup.16.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.16.png).

![Install et config Windows Server Backup.17.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.17.png).

On sélectionne Custom pour configurer manuellement la configuration de la sauvegarde
![Install et config Windows Server Backup.18.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.18.png).

Nous sélectionnerons ensuite les fichiers devant faire l'objet de la sauvegarde.
![Install et config Windows Server Backup.19.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.19.png).

Il sera également nécessaire de définir une heure précise dans la journée pour effectuer la sauvegarde.
![Install et config Windows Server Backup.20.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.20.png).

Enfin, nous déterminerons la destination pour la sauvegarde et, conformément aux captures d'écran ci-dessous, le volume sera dûment configuré.
![Install et config Windows Server Backup.21.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.21.png).

![Install et config Windows Server Backup.22.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.22.png).

![Install et config Windows Server Backup.23.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.23.png).

![Install et config Windows Server Backup.24.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.24.png).

![Install et config Windows Server Backup.25.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Install%20et%20config%20Windows%20Server%20Backup.25.png).

# STOCKAGE AVANCÉ - Mettre en place du RAID 1 sur Windows Server 2022 en GUI

## Création d'un snapshot

Avant de commencer, rendez-vous dans l'onglet Snapshots de votre serveur sur Proxmox, puis cliquez sur "Take Snapshot".

![Créer un snapchot Server Core.1](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20snapchot%20Server%20Core.1.png).

![Créer un snapchot Server Core.2](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20snapchot%20Server%20Core.2.png).

## Ajout d'un disque sur Proxmox

Puis cliquez sur "Add".

![Créer un RAID.4.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.4.png)

Comme on peut le constater, le disque dur a été correctement créé.

![Créer un RAID.5.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.5.png)

## Configuration du RAID

Faire un clic-droit sur le bouton Windows puis "Disk Management".
![Créer un RAID.6.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.6.png)

Lorsque vous ouvrez, un message vous informe que vous devez démarrer le nouveau disque pour y accéder. Cliquez sur le bouton "OK".
![Créer un RAID.7.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.7.png)

Faites clic-droit sur "Disk 0" puis "Convert to Dynamic Disk".
![Créer un RAID.8.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.8.png)

Sélectionnez "Disk 0" et "Disk 1" puis cliquez sur "OK".
![Créer un RAID.9.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.9.png)

Cliquez sur "Convert".
![Créer un RAID.10.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.10.png)

Un message vous informe que vous ne pourrez pas démarrer un autre système d'exploitation à l'exception de celui déjà installé après la conversion. Cliquez sur "Oui".
![Créer un RAID.11.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.11.png)

Faites clic-droit sur votre partition Windows C: puis "Add Mirror".
![Créer un RAID.12.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.12.png)

Choisissez le disque 1 puis cliquez sur "Ajouter un miroir".
![Créer un RAID.13.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.13.png)

Les volumes vont être placés en statut de resynchronisation. Cette étape pourrait nécessiter un certain temps. Le pourcentage de progression s'affichera dans la partition.
![Créer un RAID.14.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.14.png)

Une fois la synchronisation achevée, les volumes retrouvent un statut de "Santé". Votre configuration RAID est désormais pleinement opérationnelle.
![Créer un RAID.15.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID.15.png)

