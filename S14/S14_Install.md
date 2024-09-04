# INSTALLATION SERVEUR DE MESSAGERIE IREDMAIL
### Étape 1 : Configuration initiale du serveur

1. **Mettre à jour le système** :
    
    ```bash
    apt update && apt upgrade -y
    ```
2. **Configurer le nom de l'hôte** :
    
    - Écrire le nom de l'hôte dans le fichier `/etc/hostname` :
    
    ```bash
    echo "mail.billu.paris" > /etc/hostname
    ```
    - Éditer le fichier `/etc/hosts` pour associer l'IP à l'hôte :
    
    ```bash
    nano /etc/hosts
    ```
    Ajouter cette ligne :
    
    `172.18.1.25    mail.billu.paris    mail`
    
3. **Redémarrer le service hostname** :
    
   ```bash
    systemctl restart systemd-hostnamed
    ```
4. **Redémarrer le serveur** pour appliquer les modifications :
    
    ```bash
    reboot
    ```

---

### Étape 2 : Installer les dépendances requises

Installez les paquets nécessaires à l'installation d'iRedMail ainsi que PHP-FPM pour la version PHP que vous utilisez (PHP 8.2) :

```bash
apt install -y curl wget net-tools bc bash-completion lsb-release php8.2-fpm
```
> **Note :** Cette commande installe PHP 8.2 avec PHP-FPM nécessaire pour le traitement des scripts PHP avec Nginx.

---

### Étape 3 : Désactiver AppArmor (si activé)

Pour éviter des conflits avec iRedMail, désactivez AppArmor (si activé) :

```bash
systemctl stop apparmor systemctl disable apparmor
```
---

### Étape 4 : Télécharger et installer iRedMail (version 1.7.1)

1. **Télécharger la version 1.7.1 d'iRedMail** :
    
    ```bash
    cd /root wget https://github.com/iredmail/iRedMail/archive/refs/tags/1.7.1.tar.gz
    ```
2. **Extraire l'archive** :
    
    ```bash
    tar -xvf 1.7.1.tar.gz cd iRedMail-1.7.1
    ```
3. **Lancer l'installateur iRedMail** :
    
    ```bash
    bash iRedMail.sh
    ```

---

### Étape 5 : Suivi de l'installation interactive

Pendant l'installation, suivez les instructions de l'installateur. Voici les principales étapes et choix à effectuer :

1. **Répertoire de stockage des emails** :
    
    - Laissez le chemin par défaut `/var/vmail` ou modifiez-le si nécessaire.
2. **Choix du serveur web** :
    
    - Choisissez `Nginx` (recommandé).
3. **Sélection du backend de stockage des comptes** :
    
    - Sélectionnez `OpenLDAP`, qui est compatible avec votre configuration.
4. **Nom de domaine LDAP** :
    
    - Utilisez `billu.paris` avec la **Base DN** : `dc=billu,dc=paris`.
5. **Mot de passe administrateur LDAP** :
    
    - Définissez un mot de passe sécurisé pour l'utilisateur `admin`.
6. **Composants supplémentaires** :
    
    - Sélectionnez les composants que vous souhaitez installer, comme `Roundcube` pour le webmail.
    
    - Choisissez entre l'utilisation d'un certificat SSL existant ou d'un certificat auto-signé.
7. **SSL/TLS** :
    
    - Choisissez entre l'utilisation d'un certificat SSL existant ou d'un certificat auto-signé.
  
Un message de récap de notre config apparait :

![Install](/Ressources/Images/postinstalliredmail.png)
---

### Étape 6 : Finalisation de l'installation

Une fois l'installation terminée, redémarrez les services pour appliquer les changements.

Assurez-vous que PHP-FPM est bien démarré et activé, puis redémarrez les autres services :

```bash
systemctl start php8.2-fpm
systemctl enable php8.2-fpm
systemctl restart nginx postfix dovecot slapd
```
---

Un message de récap de la config apparait pour signaler le bon déroulement du process :

![Install](/Ressources/Images/postinstall2.png)

### Étape 7 : Configuration des enregistrements DNS

Pour que votre serveur puisse envoyer et recevoir des emails, configurez les enregistrements DNS suivants :

1. **A Record** : Pointez `mail.billu.paris` vers `172.18.1.25`.
    
2. **MX Record** : Créez un enregistrement MX pour `billu.paris` pointant vers `mail.billu.paris`.
    
3. **SPF Record** : Ajoutez un enregistrement TXT pour autoriser votre serveur à envoyer des emails :
    
    `"v=spf1 mx ~all"`
    
4. **DKIM et DMARC** : Ces enregistrements peuvent être configurés après la génération des clés DKIM.
    
---

### Étape 8 : Accéder à l'interface web

Après l'installation, vous pourrez accéder aux interfaces web suivantes :

- **Admin iRedMail** : [https://mail.billu.paris/iredadmin](https://mail.billu.paris/iredadmin)

![Install](/Ressources/Images/adminiredmail.png)
- **Webmail Roundcube** : [https://mail.billu.paris/mail](https://mail.billu.paris/mail)


![Install](/Ressources/Images/roundmail.png)
Utilisez les identifiants LDAP que vous avez configurés pour vous connecter.

---

### Étape 9 : test Envoi/reception d'email

Aprés avoir créer les utilisateurs sur l'interface admin Iredmail dans l'onglet "Add > Users"
se connecter sur le webmail ROundcube avec leurs identifiants pour procéder au test 

Envoi : par l'utilisateur abarbier et recepetion par l'utilisateur BMohamed

![Install](/Ressources/Images/receptionok.png)
