pfSense est un logiciel Open source permettant de configurer des pare-feu et des routeurs. 

# **Installation de pfsense**
## **Configuration des interfaces**
La machine sur laquelle est installée pfSense dispose de trois interfaces.

* vtnet0 : il s'agit de l'interface WAN de notre pare-feu.
Son adresse est la suivante IPv4: 10.0.0.3/29
                            IPv6: 2a01:4f8:222:2d0e::1112/64

* vtnet1 : il s'agit de l'interface LAN de notre pare-feu.
Son adresse est la suivante : IPv4: 172.18.1.252/24
                              IPv6 : 2a01:4f8:222:2d0e::1113/64

* em0 : il s'agit de l'interface en lien avec le routeur Vyos
Son adresse est la suivante : IPv4 : 172.18.3.2/30


## **Configuration du DHCP**
Afin que le pare-feu permette une connexion à internet depuis le réseau local, il faut modifier les paramètres du serveur DHCP.
Sur le serveur, il faut accéder aux paramètres DHCP. On clique droit sur **Server Options** > **Configure Options...** > **003 Routeur** et on indique l'adresse LAN de notre pare-feu comme passerelle par défaut.

Les différentes machines de notre réseau local obtiendront la nouvelle passerelle au renouvellement de leur bail. On peut aussi forcer le renouvellement avec ```ipconfig /release```suivi de ```ipconfig /renew```afin d'obtenir immédiatement la nouvelle passerelle. 

## **Configuration des règles de pare-feu**
Afin de configurer notre pare-feu, il faut y accéder depuis un poste client. On ouvre un navigateur est on rentre dans la barre d'adresse l'adresse IP du pare-feu. 
Les identifiants par défaut de pfSense sont : 
* Identifiant : admin
* Mot de passe : pfsense

On définit un nouveau mot de passe. On peut désormais définir les règles de pare-feu.

### **Règles de pare-feu côté LAN**
Les règles suivantes ont été intégrées :

En LAN
- Autorisation d'accès aux pages HTTP via le port TCP 80 ; source : LANsubnet ; destination : any
- Autorisation d'accès aux pages HTTPS via le port TCP 443 ; source : LANsubnet ; destination : any
- Autorisation de transfert de fichiers internes (FTP) via le port TCP 21 ; source : LANsubnet ; destination : any
- Autorisation d'accès aux serveurs de messagerie (SMTP) via le port TCP 25 ; source : LANsubnet ; destination : any
- Autorisation d'accès aux serveurs de messagerie (POP3) via le port TCP 110 ; source : LANsubnet ; destination : any
- Autorisation d'accès aux serveurs de messagerie (IMAP) via le port TCP 143 ; source : LANsubnet ; destination : any
- Autorisation d'accès pour les connexions en remote vers le serveur via le port TCP/UDP 3389 ; source : LANsubnet ; destination : Adresse IP du serveur remote

On applique ensuite la règle du "Deny all", c'est à dire de bloquer par défaut toutes les entrées et sorties qui ne sont pas explicitement autorisées, elle suivra la règle suivante :
- Bloquer tous les trafics du réseau LAN ; source : LAN ; destination : any

![listeregleslan.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/Fichiers-en-cours/Ressources/Images/listeregleslan.png?raw=true)