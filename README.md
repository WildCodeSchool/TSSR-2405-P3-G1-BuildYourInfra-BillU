# TSSR-2405-P3-G1-BuildYourInfra-BillU

# Projet 3 : Construction d’une infrastructure réseau pour BillU

## Présentation du Projet

**Contexte :** BillU, une filiale de RemindMe spécialisée dans le développement de logiciels de facturation, a besoin d'une nouvelle infrastructure réseau. Notre équipe de cinq étudiants en formation de technicien support systèmes et réseaux a été mandatée pour réaliser ce projet. Le siège de BillU est situé à Paris, 20ème arrondissement, et compte 167 employés répartis en 9 départements.

**Objectifs Finaux :**

- Analyser l’état actuel de l’infrastructure réseau.
- Proposer une architecture réseau sécurisée et évolutive.
- Implémenter et configurer le réseau.
- Documenter toutes les étapes du projet.
- Assurer une collaboration efficace en équipe.

## Introduction

BillU, filiale du groupe international RemindMe, souhaite moderniser son infrastructure réseau pour répondre aux besoins croissants de ses équipes. Actuellement, l'infrastructure est basique avec un réseau wifi fourni par une box FAI, sans serveur dédié, ni sécurité avancée. Notre mission est de concevoir et de mettre en place une infrastructure réseau robuste et évolutive.

## Structure de la Documentation par Sprint  :
# Sprint 1 - Analyse de l'État Actuel

## Objectifs du sprint

**Mise en Place et Gestion Initiale de l'Infrastructure AD et des VMs**

1. **AD-DS - Création d'un domaine AD**
    1. Un serveur Windows Server 2022 GUI avec les rôles AD-DS, DHCP, DNS
    2. Un serveur Windows Server 2022 Core avec le rôle AD-DS
    3. Les deux serveurs sont des DC du domaine et ont une réplication complète gérée
2. **Gestion de l'arborescence AD**
    1. Création des OU
    2. Création des groupes
    3. Création des comptes
3. **Création d'une VM Serveur Linux Debian**
    1. Mise sur le domaine AD
    2. Accessible en SSH
4. **Création d'une VM client**
    1. Sur le domaine AD
    2. Avec un compte utilisateur ayant un accès SSH sur le serveur Linux
5. **Automatisation**
    1. Automatisation complète à partir du fichier CSV
6. **Documentation**
    1. Création des structures de documentation (README.md, Install et user guide)

## Récapitulatif des Tâches

| Personne | Rôle               | Tâches                                                                                                                                                                                                  |
| -------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mina     | Développeuse       | - Etablissement d'une partie de la liste de matériel  -Doc sur l'AD|
| Julie    | Développeuse       | - Découpage réseau                                                                                                                                                                                      |
| Joris    | Product Owner (PO) | - Script d'ajout d'utilisateurs AD<br>- Documentation                                                                                                                                                   |
| Nicolas  | Développeur        | - Installation du serveur Windows GUI (DHCP, DNS)<br>- Installation de Windows Core (réplication)  -Doc                                                                                                      |
| Mohammed | Scrum Master (SM)  | - Création VM serveur Debian<br>- Création VM client Windows 10<br>- Ajout des VMs sur l'AD et configuration des pare-feux<br>- Installation et configuration du SSH<br>- Doc |


## Choix Techniques

- VM Serveur Linux Debian
- VM client Windows 10
- Serveur Windows Server 2022 GUI
- Serveur Windows Server 2022 Core

## Difficultés Rencontrées :
    
    - 
    - 
## Solutions Trouvées :
    
    - 
    - 
## Améliorations Possibles :

    -

  

---
#### Sprint 2 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

  ---
#### Sprint 3 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

  ---
#### Sprint 4 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

---
#### Sprint 5 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

  ---
#### Sprint 6 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

---
#### Sprint 7 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

  ---
#### Sprint 8 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

  ---
#### Sprint 9 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

  ---
#### Sprint 10 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -

  ---
#### Sprint 11 : 

- **Membres du Groupe (Rôles) :**
    
    - Scrum Master (SM) : 
    - Product Owner (PO) : 
    - Developpeurs : 
- **Choix Techniques :**
    
    - 
- **Difficultés Rencontrées :**
    
    - 
    - 
- **Solutions Trouvées :**
    
    - 
    - 
- **Améliorations Possibles :**

    -
