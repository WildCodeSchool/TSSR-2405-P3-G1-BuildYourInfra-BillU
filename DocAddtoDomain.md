# Déplacement automatisé des machines dans l'Active Directory
## Déploiement automatisé à travers un script
Le déploiement du script Add-To-Domain.ps1 devra permettre de déplacer automatiquement l'ensemble des machines du réseau dans l'Unité Organisationnelle correspondante de l'Active Directory de l'entreprise.

Ce script sera intégré à une stratégie de groupe, ce GPO sera configuré pour exécuter ce script à heure fixe (minuit).


## Fonctionnement du script
Ce script s'exécutera à travers un GPO. Il a pour objectif de déplacer dans l'unité organisationnelle appropriée les diférentes machines de l'Active Directory.

Pour établir dans quelle unité organisationnelle il devra déplacer l'ordinateur, il se base sur un préfixe dans le nom de la machine. Toutefois cela nécessite d'établir une charte de noms en fonction du département auquel appartient l'appareil.

Ainsi, pour assurer le bon fonctionnement de ce script, les ordinateurs devront être renommés avec un préfixe séparé d'un "-" en fonction de leur département:

* Communication et relations publiques : **COMPUB**
* Departement juridique : **JUR**
* Developpement logiciel : **DEV**
* Direction : **DIR**
* DSI : **DSI**
* Finances et comptabilité : **FIN**
* QHSE : **QHSE**
* Service commercial : **COM**
* Service recrutement : **REC**

Ainsi, un ordinateur du département développement logiciel portera le nom "DEV-X".
