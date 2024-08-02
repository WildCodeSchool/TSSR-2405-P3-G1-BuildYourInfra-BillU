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
2 - SAUVEGARDE  

![Ajout du disque.1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Ajout%20du%20disque.1.png).




