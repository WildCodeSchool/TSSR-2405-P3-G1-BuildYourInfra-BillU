## Relation de confiance

Dans le cadre de la gestion conjointe des domaines Active Directory au sein de notre partenariat, deux alternatives se présentent à nous : nous avons choisi de mettre en place une relation de confiance. Cette approche permet à chaque domaine de rester indépendant tout en offrant des accès contrôlés aux ressources entre les deux domaines.

**Avantages** :
- Moins complexe, avec des domaines autonomes.
- Flexibilité dans la gestion des ressources.

**Inconvénients** :
- Nécessité d'une gestion séparée pour chaque domaine.
- Potentiel de vulnérabilités.

**Notre choix** : Pour une indépendance avec collaboration, choisir la relation de confiance.  
Dans tous les cas, une planification minutieuse est cruciale.

## Prérequis

Avant de commencer, assurez-vous des points suivants :

- **Connectivité réseau** : Les deux domaines doivent pouvoir communiquer entre eux via le réseau, dans notre cas ce sera le VPN. Vérifiez que les pare-feux permettent le trafic entre les contrôleurs de domaine.
- **DNS** : Chaque domaine doit pouvoir résoudre les noms DNS de l'autre domaine. Il est nécessaire de mettre en place la configuration de la résolution DNS entre les deux domaines (en utilisant une zone de transfert ou un forwarder DNS).
- **Compte d’administrateur** : Nous aurons besoin d'un compte avec des droits d'administrateur dans les deux domaines.

## Étapes pour configurer une relation de confiance

### 1. Configurer la résolution DNS
Pour que les deux domaines puissent communiquer, la résolution DNS entre eux doit être configurée :

- Ouvrez la console DNS sur chacun des serveurs DNS des domaines.
- Ajoutez une zone de transfert ou configurez un redirecteur conditionnel pour rediriger vers le serveur DNS de la deuxième zone.
- Vérifiez que chaque domaine peut résoudre le nom de l'autre avec des commandes comme `nslookup` pour tester la résolution DNS.

### 2. Créer la relation de confiance

Une fois la connectivité réseau et DNS vérifiée, vous pouvez créer la relation de confiance entre les domaines :

1. **Ouvrir Active Directory Domains and Trusts** sur un contrôleur de domaine.
   - Sur le domaine source, faites un clic droit sur le nom du domaine et choisissez **Propriétés**.
2. **Accéder à l'onglet Confiance**.
   - Cliquez sur l'onglet **Trusts** (Confiance), puis cliquez sur **New Trust** (Nouvelle confiance).
3. **Utiliser l'assistant de création de relations de confiance**.
   - L'assistant **New Trust Wizard** s'ouvre. Cliquez sur **Next**.
4. **Entrer le nom DNS du domaine partenaire**.
   - Entrez le nom DNS complet du domaine avec lequel vous souhaitez établir la relation de confiance.
5. **Choisir le type de relation de confiance**.
   - **Unidirectionnelle** : Un seul domaine pourra accéder aux ressources de l'autre.
   - **Domain Trust** (confiance de domaine) si la relation doit être limitée à un domaine spécifique.
6. **Sécuriser la relation de confiance**.
   - Vous pouvez choisir entre l'authentification sélective ou de domaine. L'authentification sélective permet de mieux contrôler les accès.
7. **Fournir les informations d'authentification**.
   - Saisissez les informations administratives pour les deux domaines afin de finaliser la relation de confiance.
8. **Confirmer la relation de confiance**.
   - Une fois configurée, l'assistant vous demande de valider la confiance. Il est recommandé de le faire pour s'assurer que tout fonctionne correctement.

### 3. Configurer les permissions d'accès aux ressources

Une fois la relation de confiance établie, configurez les permissions pour les utilisateurs du domaine partenaire afin qu'ils puissent accéder aux ressources de votre domaine :

- Allez dans les propriétés des ressources (fichiers, dossiers, imprimantes, etc.) et ajoutez des groupes ou utilisateurs du domaine partenaire dans les listes de contrôle d'accès (ACL).
- Configurez des autorisations spécifiques selon les besoins.

### Conseils supplémentaires
- **Sécurisation** : Configurez les ACL pour limiter l'accès du domaine partenaire aux ressources essentielles.
- **Audit et journalisation** : Activez les journaux d'événements pour suivre les tentatives d'authentification entre les domaines et détecter tout problème potentiel.

## Gérer l'accès distant des membres IT d'une autre entreprise

Pour gérer l'accès distant des membres IT d'une autre entreprise, voici les étapes :

### 1. Utilisation de la relation de confiance existante
- Créez un groupe dans votre AD pour les membres IT de l'autre entreprise.
- Configurez des permissions pour ce groupe afin de définir les ressources accessibles.

### 2. Définir les ressources accessibles
Cela inclut :
- Accès aux serveurs via Remote Desktop Protocol (RDP).
- Accès aux partages de fichiers.
- Accès aux consoles de gestion (Hyper-V, VMWare vSphere, etc.).
- Accès à l'administration réseau (pare-feux, routeurs, etc.).

### 3. Configuration du VPN ou d'une solution d'accès distant sécurisé
- Configurez un VPN avec authentification AD pour les utilisateurs de l'autre entreprise.
- Utilisez un bastion host (jump server) pour sécuriser l'accès.

### 4. Configurer les autorisations RDP
- Créez un GPO pour autoriser l'accès RDP aux membres du groupe AD.
- Configurez le pare-feu pour limiter les connexions RDP aux plages IP du VPN.

### 5. Utiliser des outils de gestion à distance spécifiques
- Activez PowerShell Remoting pour exécuter des commandes à distance.
- Utilisez RSAT pour gérer certaines fonctions à distance.

### 6. Auditer et surveiller les connexions
- Activez les journaux d’audit pour enregistrer les connexions et actions réalisées.
- Utilisez des outils de monitoring comme Nagios ou Splunk pour surveiller en temps réel.

### 7. Sécuriser les comptes et l'accès
- Utilisez une authentification à plusieurs facteurs (MFA).
- Appliquez une gestion des permissions basée sur les rôles (RBAC).

### 8. Gestion des sessions et des politiques de déconnexion
- Configurez des politiques de déconnexion automatique après une période d’inactivité.
- Utilisez Remote Desktop Session Host pour mieux gérer les sessions RDP.

## Exemple d’architecture

1. VPN : Connexion via VPN avec authentification AD.
2. Serveur Bastion : Connexion à un jump server sécurisé.
3. Accès à distance contrôlé : Accès aux serveurs ou ressources via RDP, SSH ou PowerShell.
4. Surveillance : Utilisation d’outils d’audit et de monitoring pour surveiller les accès et actions.

Avec cette configuration, nous pouvons offrir un accès complet ou partiel tout en maintenant un contrôle strict et en garantissant la sécurité.

