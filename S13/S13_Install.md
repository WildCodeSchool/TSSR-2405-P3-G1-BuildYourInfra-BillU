# Mise en place du RAID 1 lors de l'installation de Debian

L'installation de RAID 1 lors de l'installation de Debian est une étape essentielle pour assurer la redondance des données et la tolérance aux pannes. RAID 1 fonctionne en créant une copie exacte (ou miroir) de toutes les données sur un autre disque. Voici un guide étape par étape pour configurer RAID 1 lors de l'installation de Debian.

## Étape 1 : Démarrer l'installation
Démarrez votre ordinateur avec le support d'installation de Debian. Suivez les instructions à l'écran jusqu'à atteindre l'étape du partitionnement des disques.

## Étape 2 : Partitionner les disques

### Sélection du disque
Lorsque vous arrivez à l'étape "Partitionner les disques", sélectionnez "Manuel".  
![Créer un RAID 1 Debian.1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.1.png)

Comme vous le voyez sur cette image, nous avons bien les deux disques.  
![Créer un RAID 1 Debian.2.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.2.png)

### Partitionner les disques

Comme vous le voyez, la fenêtre sera comme cette image :  
![Créer un RAID 1 Debian.3.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.3.png)

Appuyez ensuite sur "partitionnement assisté".

## Étape 3 : Configurer le RAID logiciel
![Créer un RAID 1 Debian.41.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.41.png)

![Créer un RAID 1 Debian.42.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.42.png)

Il faut choisir "Créer un périphérique multidisque" :  
![Créer un RAID 1 Debian.43.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.43.png)

## Étape 4 : Formater les partitions
Pour chaque partition créée, sélectionnez le type de système de fichiers approprié. Par exemple, utilisez ext4 pour les partitions principales et swap pour l'échange :  
![Créer un RAID 1 Debian.55.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.55.png)

![Créer un RAID 1 Debian.56.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.56.png)  
![Créer un RAID 1 Debian.57.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.57.png)  
![Créer un RAID 1 Debian.58.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.58.png)  
![Créer un RAID 1 Debian.59.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.59.png)  
![Créer un RAID 1 Debian.60.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.60.png)

Nous allons mettre cette partition en swap :  
![Créer un RAID 1 Debian.61.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.61.png)  
![Créer un RAID 1 Debian.62.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.62.png)  
![Créer un RAID 1 Debian.63.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.63.png)  
![Créer un RAID 1 Debian.64.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.64.png)

## Étape 5 : Finaliser le partitionnement
![Créer un RAID 1 Debian.65.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.65.png)  
![Créer un RAID 1 Debian.66.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.66.png)  
![Créer un RAID 1 Debian.67.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID%201%20Debian.67.png)

# Mettre en place du RAID 1 sur Windows Server Core

## Étapes

### 1. Lancer Diskpart

diskpart

2. Lister les disques
list disk

3. Sélectionner le disque 0 et le convertir en dynamique
select disk 0
convert dynamic

4. Idem pour le nouveau disque ajouté
select disk 1
convert dynamic

5. Lister les volumes
list volume
![Créer un RAID1 sur Windows Core.1.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID1%20sur%20Windows%20Core.1.png).
6. Sélectionner le volume C et ajouter le deuxième disque
select volume V
add disk=1

7. Vérification
list disk
list volume
![Créer un RAID1 sur Windows Core.2.png](https://github.com/WildCodeSchool/TSSR-2405-P3-G1-BuildYourInfra-BillU/blob/main/Ressources/Créer%20un%20RAID1%20sur%20Windows%20Core.2.png).


