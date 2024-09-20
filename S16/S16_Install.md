# Supervision Partenariat d'Entreprise - Zabbix (Serveurs uniquement)

---

## Étapes de mise en place de la supervision

### 1. Supervision des serveurs

#### 1.1 Ajout des serveurs de l'autre entreprise dans Zabbix (Debian)

1. **Connexion SSH à la machine distante** :
   - Ouvrir une connexion SSH vers le serveur cible Debian :
     ```bash
     ssh user@remote-server-ip
     ```

2. **Mise à jour du système** :
   - Mettre à jour les paquets du serveur :
     ```bash
     sudo apt update
     sudo apt upgrade -y
     ```

3. **Ajout du dépôt Zabbix et installation de l'agent** :
   - Télécharger le dépôt Zabbix et installer l'agent sur le serveur :
     ```bash
     wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-1+debian11_all.deb
     sudo dpkg -i zabbix-release_6.0-1+debian11_all.deb
     sudo apt update
     sudo apt install zabbix-agent -y
     ```

4. **Configuration de l'agent Zabbix** :
   - Modifier le fichier de configuration pour qu'il se connecte au serveur Zabbix :
     ```bash
     sudo nano /etc/zabbix/zabbix_agentd.conf
     ```
   - Paramètres à ajuster :
     ```bash
     Server=<IP_serveur_Zabbix>
     ServerActive=<IP_serveur_Zabbix>
     Hostname=<Nom_de_ta_machine_serveur>
     ```

5. **Démarrage et activation de l'agent** :
   - Démarrer et activer l'agent Zabbix pour qu'il fonctionne au démarrage :
     ```bash
     sudo systemctl restart zabbix-agent
     sudo systemctl enable zabbix-agent
     ```

6. **Ajout du serveur dans Zabbix** :
   - Accéder à l'interface Zabbix via le navigateur.
   - Dans **Configuration > Hôtes**, cliquer sur **Créer un hôte**.
   - Remplir les informations pour chaque serveur cible :
     - **Nom** : Nom du serveur.
     - **Adresse IP** : Adresse IP du serveur.
     - **Groupes** : Créer un groupe spécifique pour les serveurs de l'autre entreprise, par exemple : `EcoTechSolutions-Serveurs`.
     - **Templates** : Associer un modèle pour la supervision des serveurs, par exemple **Template OS Linux**.

---

#### 1.2 Installation des agents Zabbix sur Windows

1. **Téléchargement de l'agent Zabbix** :
   - Télécharger l'agent Zabbix pour Windows depuis le site officiel : [Télécharger Zabbix pour Windows](https://www.zabbix.com/download_agents).

2. **Installation de l'agent** :
   - Exécuter l'installeur Zabbix sur la machine Windows.
   - Pendant l'installation, spécifier les paramètres suivants :
     - **Adresse IP du serveur Zabbix** : `<IP_serveur_Zabbix>`.
     - **Nom d'hôte** : Nom de la machine Windows.

3. **Configuration de l'agent** (si nécessaire) :
   - Si des ajustements sont nécessaires, modifier le fichier `zabbix_agentd.conf` qui se trouve par défaut dans le répertoire d'installation (`C:\Program Files\Zabbix Agent\`).
   - Paramètres à ajuster :
     ```bash
     Server=<IP_serveur_Zabbix>
     ServerActive=<IP_serveur_Zabbix>
     Hostname=<Nom_de_ta_machine_Windows>
     ```

4. **Démarrage du service Zabbix Agent** :
   - Démarrer le service Zabbix Agent via le gestionnaire de services Windows ou via PowerShell :
     ```powershell
     Start-Service "Zabbix Agent"
     ```

5. **Ajout du serveur Windows dans Zabbix** :
   - Accéder à l'interface Zabbix via le navigateur.
   - Dans **Configuration > Hôtes**, cliquer sur **Créer un hôte**.
   - Remplir les informations pour chaque serveur Windows :
     - **Nom** : Nom de la machine Windows.
     - **Adresse IP** : Adresse IP de la machine Windows.
     - **Groupes** : Créer un groupe spécifique pour les serveurs Windows de l'autre entreprise.
     - **Templates** : Associer le modèle **Template OS Windows** pour la supervision.

---

### 2. Gestion des Accès Limités aux Tableaux de Bord

#### 2.1 Création d'un rôle spécifique pour les membres IT d'EcoTechSolutions

1. **Création d'un rôle utilisateur restreint** :
   - Accéder à l'interface Zabbix via **Administration > Rôles**.
   - Cliquer sur **Créer un rôle** et définir les permissions :
     - **Nom** : `EcoTech_IT_ViewOnly`.
     - **Permissions** : Choisir `Read` uniquement pour le groupe d'hôtes de l'autre entreprise (`EcoTechSolutions-Serveurs`).
     - Restreindre l'accès aux sections d'administration (configuration, gestion des utilisateurs, etc.).

2. **Création d'un groupe d'utilisateurs** :
   - Dans **Administration > Groupes d'utilisateurs**, créer un groupe pour les membres IT d'EcoTechSolutions, par exemple `EcoTech_IT`.
   - Associer le groupe au rôle créé (`EcoTech_IT_ViewOnly`).

3. **Création des utilisateurs** :
   - Dans **Administration > Utilisateurs**, créer un utilisateur pour chaque membre IT de l'autre entreprise, en les associant au groupe `EcoTech_IT`.

---

#### 2.2 Configuration des droits d'accès aux tableaux de bord

1. **Accès aux tableaux de bord** :
   - Créer un tableau de bord personnalisé pour les membres IT de l'autre entreprise dans **Surveillance > Tableaux de bord**.
   - Cliquer sur **Créer un tableau de bord** et configurer les widgets souhaités (statuts des serveurs, graphiques de performance, etc.).
   - Limiter l’accès à ce tableau de bord spécifique pour le groupe `EcoTech_IT`.

2. **Restriction d'accès aux autres sections** :
   - Limiter l'accès des membres d'EcoTechSolutions aux données de surveillance, sans la possibilité de modifier la configuration ou d’accéder à l'administration Zabbix.

---
