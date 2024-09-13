# Configuration du stockage partagé pour partenariat d'entreprise

## 1. Mise en place de dossiers partagés

### A. Utilisation d'un serveur de fichiers Windows

1. Créez une nouvelle arborescence de dossiers sur un serveur de fichiers Windows :
   ```
   \\serveur\Partenariat\
      ├── Projets_Communs\
      ├── Ressources_Partagées\
      ├── Echanges_Temporaires\
   ```

2. Configurez les partages réseau pour ces dossiers.

3. Utilisez DFS (Distributed File System) pour créer un espace de noms partagé facile à naviguer :
   ```
   \\votre-entreprise.com\Partenariat\
   ```

### B. Utilisation d'une solution cloud

1. Mettez en place une solution comme SharePoint Online ou OneDrive Entreprise.

2. Créez une structure similaire dans l'environnement cloud choisi.

## 2. Gestion des accès et de la sécurité

### A. Configuration des groupes de sécurité dans Active Directory

1. Créez des groupes de sécurité pour chaque niveau d'accès :
   - PARTENARIAT_Lecture
   - PARTENARIAT_Modification
   - PARTENARIAT_IT_Admin

2. Ajoutez les utilisateurs appropriés de chaque entreprise à ces groupes.

### B. Configuration des permissions NTFS

1. Appliquez les permissions NTFS sur les dossiers :
   - PARTENARIAT_Lecture : Lecture & Exécution
   - PARTENARIAT_Modification : Modification
   - PARTENARIAT_IT_Admin : Contrôle total

2. Utilisez l'héritage des permissions pour simplifier la gestion.

### C. Délégation de la gestion de la sécurité

1. Utilisez la fonctionnalité "Délégation de contrôle" d'Active Directory :
   - Sélectionnez l'OU contenant les groupes de sécurité du partenariat.
   - Déléguez la gestion des membres de groupe aux administrateurs IT du partenaire.

2. Pour les dossiers partagés, accordez des droits de gestion de sécurité avancés :
   - Clic droit sur le dossier > Propriétés > Sécurité > Avancé
   - Ajoutez le groupe PARTENARIAT_IT_Admin avec les permissions de modification de la sécurité.

## 3. Mise en place d'un accès sécurisé

### A. VPN site à site

1. Configurez un VPN site à site entre les deux entreprises.
2. Assurez-vous que les règles de pare-feu autorisent le trafic SMB (port 445) via le VPN.

### B. Authentification multi-facteurs (MFA)

1. Mettez en place une solution MFA pour l'accès aux ressources partagées, surtout si vous utilisez une solution cloud.

## 4. Auditing et surveillance

1. Activez l'auditing sur les dossiers partagés pour tracer les accès et modifications.

2. Configurez des alertes pour les activités suspectes ou les modifications de permissions.

## 5. Politique d'utilisation et formation

1. Rédigez une politique claire d'utilisation des ressources partagées.

2. Formez les utilisateurs et les administrateurs IT des deux entreprises sur :
   - La structure des dossiers
   - Les bonnes pratiques de sécurité
   - Les procédures de demande d'accès

## 6. Révision et maintenance

1. Planifiez des revues trimestrielles des accès et des permissions.

2. Mettez en place un processus formel pour les demandes de modification des accès.