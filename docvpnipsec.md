# **Mise en place tunnel VPN IPSEC**

## **Configuration de l'interface IPv6**
Afin de pouvoir accéder en IPv6, il faut mettre en place une nouvelle interface sur notre pare-feu PfSense.
Une fois celle-ci ajoutée physiquement, accéder à l'interface web de PfSense avec les identifiants administrateur, puis accéder à ```Interfaces > Interfaces Assignements```
Sélectionner la nouvelle interface et l'assigner au bon port.

Pour vérifier si la connectivité avec l'extérieur en IPv6 est possible, on peut ping google en IPv6 depuis la console PfSense
```ping6 2001:4860:4860::8888```
En principe, aucune route ne devrait être trouvée, il faut reconfigurer le routage du pare-feu.

Pour cela, accéder à ```System > Routing```et configurer la Gateway IPv6. Par la suite, il faut définir cette Gateway comme Gateway par défaut juste en dessous.

Il est désormais possible d'accéder à internet en IPv6.

## **Configuration du tunnel VPN IPSEC**

### **Configuration Phase 1**
La phase 1 va permettre d'indiquer comment les réseaux vont communiquer entre eux : par les interfaces IPv6 de leur pare-feu.

Pour créer le tunnel VPN IPSEC, il faut se rendre sur l'interface web de PfSense sur notre pare-feu, puis sélectionner les onglets ```VPN > IPsec > Tunnels```. On sélectionne ensuite ```Add P1```
![vpnADD-p1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/Fichiers-en-cours/vpnAdd-p1.png?raw=true)

On renseigne la description de notre tunnel (le nom qui s'affichera pour la P1), puis le protocole correspondant ainsi que l'interface. Dans ```Remote Gateway```on renseigne l'adresse IPv6 du pare-feu avec lequel on formera le tunnel.
![vpnAdd-p1-config.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/Fichiers-en-cours/vpnAdd-p1-config.png?raw=true)

Ensuite, dans ```Pre-Shared Key```, on renseigne la clé de sécurité du tunnel. On peut en générer une directement, il faudra la noter avec soin.
![vpnAdd-p1-config2.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/Fichiers-en-cours/vpnAdd-p1-config2.png?raw=true)

Une fois ces étapes faites sur notre pare-feu, les mêmes étapes doivent être effectuées sur le second pare-feu avec lequel on établit le contact.

### **Configuration Phase 2**
La phase 2 va renseigner quels réseaux vont communiquer à travers le tunnel VPN, on va ainsi indiquer quels réseaux locaux vont communiquer.

On peut y renseigner un mode Tunnel IPv4, car nos réseaux locaux sont configurés de la sorte. Cela ne pose pas de problème avec le Tunnel IPv6 de la Phase 1, car les protocoles IPv4 seront encapsulés dans les protocoles IPv6.
![configuration phase2.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/Fichiers-en-cours/configuration%20phase2.png?raw=true)

On va ensuite renseigner quels réseaux vont pouvoir communiquer : ici notre réseau local (on renseigner le réseau de notre interface LAN) et du réseau distant (l'adresse IPv4 du réseau du site distant).

On peut ensuite adapter les protocoles d'échange. Nous avons opté pour le protocole ESP qui est le protocle VPN par défaut.

![configurationvpn.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/Fichiers-en-cours/configurationvpn.png?raw=true)

### **Configuration des règles de pare-feu pour le VPN**
Afin d'assurer la sécurité de notre réseau, des règles de pare-feu doivent être établies entre les deux réseaux locaux. Après l'activation du tunnel VPN, une nouvelle "interface" apparaît dans les règles de pare-feu. On peut dès lors appliquer la politique du "Deny All" et autoriser uniquement les communications nécessaires.

Les règles de la phase 1 doivent être configurées sur l'interface WAN, et donc en IPv6.
Les règles de la phase 2 doivent être configurées sur l'interface IPsec et sur la LAN, et donc en IPv4.

![rulesipsec.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/Fichiers-en-cours/rulesipsec.png?raw=true)

