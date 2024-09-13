# Gestion des accès via AD avec domaines en relation de confiance et intégration Zabbix

## 1. Configuration de l'environnement AD

### Cas de fusion de domaines :
- Assurez-vous que la fusion est complète et que tous les utilisateurs sont dans le même domaine.
- Créez une Unité d'Organisation (OU) dédiée pour les utilisateurs et groupes liés à la supervision.

### Cas de relation de confiance :
- Vérifiez que la relation de confiance est bidirectionnelle et correctement configurée.
- Dans le domaine principal, créez des groupes de sécurité globaux pour les accès Zabbix.
- Dans le domaine partenaire, créez des groupes de sécurité domaine local qui incluront les groupes globaux du domaine principal.

## 2. Création des groupes de sécurité

1. Créez un groupe de sécurité global nommé "Zabbix_Superviseurs_ReadOnly".
2. Ajoutez les utilisateurs appropriés de votre domaine et du domaine partenaire à ce groupe.

## 3. Configuration des droits d'accès sur les serveurs Zabbix

1. Sur chaque serveur hébergeant l'interface web Zabbix :
   - Ajoutez le groupe "Zabbix_Superviseurs_ReadOnly" aux droits d'accès RDP (si nécessaire).
   - Configurez les droits NTFS sur le dossier de l'interface web Zabbix pour accorder un accès en lecture à ce groupe.

2. Configurez le serveur web (IIS ou Apache) pour utiliser l'authentification Windows intégrée.

## 4. Configuration de Zabbix pour l'authentification AD

1. Dans la configuration de Zabbix (zabbix_server.conf ou via l'interface web) :
   - Activez l'authentification LDAP/AD.
   - Configurez les paramètres de connexion au contrôleur de domaine.
   - Définissez le mappage entre le groupe AD "Zabbix_Superviseurs_ReadOnly" et un rôle Zabbix en lecture seule.

2. Créez un rôle Zabbix en lecture seule avec les permissions appropriées :
   - Accès en lecture aux tableaux de bord nécessaires.
   - Accès en lecture aux hôtes et groupes d'hôtes pertinents.
   - Aucun accès aux fonctions d'administration ou de configuration.

## 5. Configuration des tableaux de bord et vues Zabbix

1. Créez des tableaux de bord spécifiques pour les superviseurs partenaires.
2. Configurez le partage de ces tableaux de bord pour qu'ils soient accessibles au rôle en lecture seule.

## 6. Mise en place d'un proxy HTTPS (optionnel mais recommandé)

1. Installez et configurez un proxy inverse (comme Nginx ou HAProxy) devant Zabbix.
2. Configurez le proxy pour utiliser HTTPS et pour transmettre les informations d'authentification AD à Zabbix.

## 7. Test et validation

1. Testez la connexion avec des comptes utilisateurs de chaque domaine.
2. Vérifiez que les utilisateurs n'ont accès qu'aux fonctionnalités en lecture seule dans Zabbix.
3. Confirmez que l'authentification unique (SSO) fonctionne correctement.

## 8. Documentation et formation

1. Documentez la configuration pour les équipes IT des deux entreprises.
2. Formez les utilisateurs sur l'accès et l'utilisation de Zabbix via leur compte AD.

## 9. Maintenance et sécurité

1. Mettez en place un processus de révision régulière des accès.
2. Configurez l'audit des connexions dans AD et Zabbix pour la traçabilité.
3. Établissez un processus clair pour l'ajout ou le retrait d'utilisateurs du groupe de sécurité.