# **Installation et configuration des serveurs et clients**
Dans le cadre de la mise en place du réseau de l'entreprise, nous avons mis en place une série de machines virtuelles afin de visualiser les configurations à mettre en place.
Voici les configurations que nous avons établies :

| Fonction de la VM          | Serveur                     | Serveur             | Client         |
| -------------------------- | --------------------------- | ------------------- | -------------- |
| Nom                        | WINSERV                    | WINSERV-BACKUP            | CLIENT        |
| OS                         | Windows Server 2022         | Windows Server 2022 CORE | Windows 10     |
| OS version                 | Standard Desktop Experience | Standard            | Professionnel  |
| RAM                        | 4/8 Go                      | 2/4 Go              | 2/4 Go         |
| Langue à installer         | English (US)                | English (US)        | French         |
| Time and currency/keyboard | French                      | French              | French         |
| Carte réseau               | Réseau privé                | Réseau privé        | Réseau privé   |
| Adresse IP                 | 172.18.1.250/24               | 172.18.1.251/24       | 172.18.2.1/24 |
| DNS                        | 127.0.0.1                  | 172.18.1.250           | 172.18.1.250     |
| Utilisateur local          | Administrator               | Administrator       | Wilder         |
| Firewall                   | Désactivé                   | Désactivé           | Désactivé      |

## **Serveur WINSERV**
Il s'agit ici du serveur principal de notre réseau. Pour une question de confort, il est en installation graphique. Il concentre différents rôles : DHCP, DNS et Active Directory. Nous avons conservé la plage IP du réseau existant.

### **Rôle DHCP**
Le rôle DHCP (Dynamic Host Configuration Protocol) a pour objectif de permettre une attribution dynamique des adresses IP aux machines de notre réseau. 
* Il attribue automatiquement une adresse IP aux appareils connectés au réseau, un gain de temps par rapport à une installation manuelle.
* L'automatisation permet de réduire les risques d'erreurs humaines liés à cette même installation manuelle ainsi que les conflits d'adresses IP.
* Il peut être configuré pour distribuer des adresses en fonction du sous-réseau de l'appareil et permet une adaptation simple aux évolutions du réseau.

Actuellement, une seule étendue (plage d'adresses distribuable) a été configurée sur le serveur (le sous réseau relatif à la salle des serveurs). A terme, on totalisera 10 sous-réseaux : un par département, afin d'optimiser la sécurité du réseau global.
* Si un sous-réseau est compromis, on évite la propagation des effets sur l'ensemble du réseau.
* En plus de réduire l'impact, on réduit aussi la zone à vérifier lors d'un incident.
* Des règles de pare-feu spécifiques et des politiques de sécurité adaptées peuvent être imposées à différents sous-réseaux afin de limiter le trafic.
* Cela permettra également d'optimiser les ressources et les performances.

### **Rôle DNS**
Le rôle DNS a été installé automatiquement lors de l'installation de l'Active Directory. Sa finalité est de traduire les noms de domaine en adresses IP pour permettre aux utilisateurs d'accéder aux ressources du réseau via des noms plus que des adresses. 
* Il permet une simplification de la navigation réseau.
* Il permet de réduire les temps de connexion (résolutions de noms en cache).
* Il permet une gestion centralisée des noms de domaine ce qui facilite la maintenance.
* Il peut être configuré pour contrôler l'accès aux ressources.

Le domaine employé par l'entreprise est le domaine "BillU.Paris".

### **Rôle Active Directory**


## **Serveur WINSERV-BACKUP**
Il s'agit d'un serveur Back-Up si le serveur principal venait à tomber. Nous avons opté pour une version Core, plus légère et moins gourmande en ressources.
Le rôle Active Directory et DNS lui on été alloué, afin de maintenir le réseau en cas de panne. Pour cela, nous l'avons promu en contrôleur de domaine.