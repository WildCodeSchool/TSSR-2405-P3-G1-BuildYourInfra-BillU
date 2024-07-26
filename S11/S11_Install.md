# Mise en place et configuration d'un routeur VyOS avec une passerelle pfSense sous Proxmox

### Étape 1 : Création des interfaces sur Proxmox pour VyOS

1. **Accéder à l'interface Web de Proxmox** :
    
    - Connectez-vous à l'interface Web de Proxmox.
2. **Créer des interfaces réseau pour VyOS** :
    
    - Sélectionnez la VM de VyOS.
    - Allez dans l'onglet `Hardware`.
    - Cliquez sur `Add` -> `Network Device`.
    - Ajoutez une interface réseau pour chaque sous-réseau en utilisant le modèle suivant :
        - **Bridge** : Choisissez le bridge approprié (pour notre cas, `G1`).
        - **Model** : `INTEL E 1000`
    - Répétez cette étape pour chaque sous-réseau (vous aurez 9 interfaces en tout).

### Étape 2 : Configuration des interfaces sur VyOS

1. **Accéder à VyOS et configurer les interfaces** :
    
    - Connectez-vous à VyOS via la console Proxmox ou SSH.
    - Configurez chaque interface avec l'adresse IP appropriée pour chaque sous-réseau.
    
    Notre configuration :
    
```sh
configure
set interfaces ethernet eth0 address '172.18.1.1/25' 
set interfaces ethernet eth1 address '172.18.1.130/27' 
set interfaces ethernet eth2 address '172.18.1.161/27'
set interfaces ethernet eth3 address '172.18.1.192/28'
set interfaces ethernet eth4 address '172.18.1.208/28' 
set interfaces ethernet eth5 address '172.18.1.224/28' 
set interfaces ethernet eth6 address '172.18.1.240/29' 
set interfaces ethernet eth7 address '172.18.2.0/29' 
set interfaces ethernet eth8 address '172.18.2.8/29'
set interfaces ethernet eth9 address '172.18.3.1/30' 
commit
save
exit`    
```


2. **Configurer la route par défaut pour utiliser pfSense comme passerelle** :
    
    
```sh
    configure
    set protocols static route 0.0.0.0/0 next-hop 172.18.3.2
    commit
    save
    exit
```    

### Étape 3 : Création de l'interface sur Proxmox pour pfSense

1. **Créer une interface réseau pour le lien avec VyOS sur pfSense** :
    - Sélectionnez la VM de pfSense.
    - Allez dans l'onglet `Hardware`.
    - Cliquez sur `Add` -> `Network Device`.
    - Ajoutez une interface réseau pour le sous-réseau `172.18.3.0/30` :
        - **Bridge** : Choisissez le bridge approprié (pour nous, `G1`).
        - **Model** : `Intel E 1000`.

### Étape 4 : Configuration de l'interface sur pfSense

1. **Accéder à l'interface Web de pfSense et configurer l'interface `lienversvyos`** :
    - Connectez-vous à l'interface Web de pfSense.
    - Allez dans `Interfaces` -> `Assignments`.
    - Ajoutez la nouvelle interface et nommez-la `lienversvyos`.
    - Configurez l'interface avec l'adresse IP `172.18.3.2/30`.

### Étape 5 : Configuration des règles de pare-feu sur pfSense

#### 5.1 Règles sur l'interface `lienversvyos`

1. **Accéder à l'interface Web de pfSense** :
    
    - Allez dans `Firewall` -> `Rules`.
    - Sélectionnez l'onglet `lienversvyos`.
2. **Ajouter des règles pour autoriser le trafic entre les sous-réseaux internes** :
    
    - Cliquez sur `Add` pour ajouter une nouvelle règle.
    - Configurez la règle comme suit :
        - **Action** : Pass
        - **Interface** : lienversvyos
        - **Protocol** : Any
        - **Source** : Network `172.18.1.0/24`
        - **Destination** : Any
        - **Description** : Allow traffic from 172.18.1.0/24 to any
    - Répétez cette étape pour chaque combinaison de sous-réseaux nécessitant la communication.

#### 5.2 Règles sur l'interface WAN

1. **Accéder à l'interface Web de pfSense** :
    
    - Allez dans `Firewall` -> `Rules`.
    - Sélectionnez l'onglet `WAN`.
2. **Ajouter des règles pour autoriser le trafic sortant** :
    
    - Cliquez sur `Add` pour ajouter une nouvelle règle.
    - Configurez la règle comme suit :
        - **Action** : Pass
        - **Interface** : WAN
        - **Protocol** : Any
        - **Source** : Network `172.18.1.0/24`
        - **Destination** : Any
        - **Description** : Allow outbound traffic from 172.18.1.0/24
    - Répétez cette étape pour chaque sous-réseau si nécessaire.

### Étape 6 : Configuration des règles NAT sur pfSense

1. **Configurer les règles NAT manuelles** :
    - Allez dans `Firewall` -> `NAT` -> `Outbound`.
    - Sélectionnez `Manual Outbound NAT rule generation` et cliquez sur `Save`.
    - Ajoutez une règle NAT pour chaque sous-réseau.
    - Exemple de règle :
        - **Interface** : WAN
        - **Source** : Network `172.18.1.0/24`
        - **Source Port** : Any
        - **Destination** : Any
        - **Destination Port** : Any
        - **NAT Address** : Interface Address (adresse WAN de pfSense)
        - **Description** : NAT for traffic from 172.18.1.0/24
    - Répétez cette étape pour chaque sous-réseau (`172.18.1.128/27`, `172.18.1.160/27`, etc.).

### Étape 7 : Vérification de la connectivité

1. **Depuis une machine sur l'un des sous-réseaux derrière VyOS** :
    
    - Essayez de pinguer l'IP de VyOS `172.18.3.1` 
        
    - Essayez de pinguer l'IP de pfSense `172.18.3.2` 
        
    - Essayez de pinguer une adresse IP externe  `8.8.8.8` 
    
    - Essayez de pinguer une adresse IP d'un autre sous réseau  `172.18.2.1` 

![PING](/Ressources/Images/ping_VYOS_PFS.png)
---
# GPO Gestion de la télémétrie 

Les GPO Gestion de la télémétrie sont des paramètres de stratégie de groupe utilisés pour configurer et contrôler la collecte de données de diagnostic et de télémétrie dans les systèmes Windows au sein d'un réseau. Ils permettent aux administrateurs de gérer et de limiter les informations envoyées à Microsoft, assurant ainsi la conformité aux politiques de confidentialité de l'organisation.

## Pré-requis
Il est impératif de s'assurer que la Console de Gestion des Stratégies de Groupe (GPMC) soit installée sur notre système.

## Création d'une GPO pour les Ordinateurs 

### Étape 1 : Ouvrir la Console de Gestion des Stratégies de Groupe (GPMC) 
Pour ouvrir la Console :
- Appuyez sur les touches `Win + R`, tapez `gpmc.msc` puis appuyez sur Entrée.

### Étape 2 : Créer une nouvelle GPO 
Pour créer une GPO :
- Dans le volet de gauche, effectuez un clic droit sur le domaine ou l'unité d'organisation (OU) où vous souhaitez appliquer la GPO.
- Sélectionnez l'option "Créer un objet de stratégie de groupe dans ce domaine".
- Donnez un nom à la GPO, par exemple **Gestion télémétrie ordinateur**.

### Étape 3 : Configurer les paramètres de télémétrie 
Pour modifier la GPO :
- Effectuez un clic droit sur la nouvelle GPO, puis sélectionnez "Modifier". Dans l'Éditeur de Gestion des Stratégies de Groupe, naviguez vers :

#### GPO_C_ Télémétrie pour Ordinateur
- **Chemin :** `Computer Configuration/Policies/Windows Settings/Security Settings/Local Policies/Security Options`
  - **Paramètre :** Block Microsoft Accounts
  - **Configuration :** Users can't add or log on with Microsoft accounts
  - **Description :** Empêche les utilisateurs d'ajouter ou de se connecter avec des comptes Microsoft.

- **Chemin :** `Computer Configuration/Administrative Templates/Control Panel/Regional and Language Options`
  - **Paramètre :** Allow users to enable online speech recognition services
  - **Configuration :** Disabled
  - **Description :** Désactive la possibilité pour les utilisateurs d'activer les services de reconnaissance vocale en ligne.

- **Chemin :** `Computer Configuration/Administrative Templates/Control Panel/Regional and Language Options/Handwriting personalization`
  - **Paramètre :** Turn off automatic learning
  - **Configuration :** Disabled
  - **Description :** Désactive l'apprentissage automatique de la personnalisation de l'écriture manuscrite.

- **Chemin :** `Computer Configuration/Administrative Templates/System/Internet Communication Management/Internet Communication settings`
  - **Paramètre :** Turn Off access to the store
  - **Configuration :** Enabled
  - **Description :** Empêche l'accès au Microsoft Store.

#### Désactivation des services de télémétrie et de collecte de données
- **Désactiver les ID de publicité :**
  - **Chemin :** `Computer Configuration/Administrative Templates/System/User Profiles`
  - **Paramètre :** Turn off the advertising ID
  - **Configuration :** Enabled
  - **Description :** Désactive l'ID de publicité utilisé pour les expériences publicitaires personnalisées.

#### Gestion des mises à jour automatiques
- **Configurer les mises à jour automatiques :**
  - **Chemin :** `Computer Configuration/Administrative Templates/Windows Components/Windows Update`
  - **Paramètre :** Configure Automatic Updates
  - **Configuration :** Enabled, et mettre le nombre de minutes pour la configuration (ex : 15mn).
  - **Description :** Configure les mises à jour automatiques et définit le délai de redémarrage après installation des mises à jour.

#### Réseaux et Internet
- **Désactiver Interdire la connexion aux réseaux Mobile Broadband en itinérance :**
  - **Chemin :** `Computer Configuration/Administrative Templates/Network/Windows Connection Manager`
  - **Paramètre :** Prohibit connection to roaming Mobile Broadband networks
  - **Configuration :** Enabled
  - **Description :** Empêche la connexion aux réseaux à large bande mobile en itinérance.

- **Désactiver l'envoi de l'historique de saisie à Microsoft :**
  - **Chemin :** `Computer Configuration/Administrative Templates/System/OS Policies`
  - **Paramètre :** Allow Clipboard History
  - **Configuration :** Disabled
  - **Description :** Empêche l'envoi de l'historique du presse-papiers à Microsoft.

#### Autres paramètres de confidentialité
- **Désactiver l'assistant de compatibilité des programmes :**
  - **Chemin :** `Computer Configuration/Administrative Templates/Windows Components/Application Compatibility`
  - **Paramètre :** Turn off Program Compatibility Assistant
  - **Configuration :** Enabled
  - **Description :** Désactive l'assistant de compatibilité des programmes, qui recherche des problèmes de compatibilité connus pour les programmes plus anciens.

### Étape 4 : Créer une nouvelle GPO 
Pour créer une GPO :
- Dans le volet de gauche, effectuez un clic droit sur le domaine ou l'unité d'organisation (OU) où vous souhaitez appliquer la GPO.
- Sélectionnez l'option "Créer un objet de stratégie de groupe dans ce domaine".
- Donnez un nom à la GPO, par exemple **Gestion télémétrie utilisateur**.

#### GPO_U_ Télémétrie pour Utilisateur
- **Chemin :** `User Configuration/Policies/Administrative Templates/Windows Component/Cloud Content`
  - **Paramètre :** Do not use diagnostic data for tailored experience
  - **Configuration :** Enabled
  - **Description :** Empêche l'utilisation des données de diagnostic pour des expériences personnalisées basées sur le cloud.

        
