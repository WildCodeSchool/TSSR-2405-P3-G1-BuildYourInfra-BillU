# Plan de Continuité et de Reprise d'Activité (PCRA)

Suite à un problème électrique certains éléments de l'infrastructure ne fonctionnent plus.
Le MCO (*Maintient en Condition Opérationnelle*) n'est plus valide

## 1. Objectifs du PCRA

| Objectif               | Description                                                                         |
|------------------------|-------------------------------------------------------------------------------------|
| Reprise rapide         | Garantir la reprise rapide et efficace des activités en cas de défaillance majeure. |
| Limitation des interruptions | Minimiser les interruptions opérationnelles et assurer la continuité des services critiques. |

## 2. État des lieux au 22/09/2024

| Élément                                         | Catégorie  | Criticité | État                  | Date de résolution prévue |
|-------------------------------------------------|------------|-----------|----------------------|--------------------------|
| Serveur Iredmail                                | Messagerie | Majeur    | Défaillant           | En attente               |
| Routeur Vyos                                    | Réseau     | Critique  | Défaillant           | En attente               |
| Serveur GUI : Disques de sauvegarde et stockage | Stockage   | Majeur    | Fonctionnel en partie| En attente               |
| Windows Server Core                             | Serveur    | Mineur    | Défaillant           | En attente               |
| OpenVPN : Carte réseau                          | Réseau     | Majeur    | Défaillant           | En attente               |
| Zabbix : Carte réseau                           | Réseau     | Majeur    | Défaillant           | En attente               |

## 3. Stratégie de Reprise

   | Priorité               | Description                                                                                 | Éléments concernés                             |
|------------------------|---------------------------------------------------------------------------------------------|------------------------------------------------|
| Critique (Priorité 1)  | Réseau, messagerie et supervision doivent être rétablis immédiatement pour permettre la communication et le suivi des systèmes. | Routeur Vyos, OpenVPN, Zabbix, Iredmail          |
| Majeur (Priorité 2)    | Les serveurs de stockage et les services de sauvegarde doivent être opérationnels pour protéger les données.          | Serveur GUI                                    |
| Mineur (Priorité 3)    | Les systèmes non critiques doivent être rétablis en dernier.                                | Windows Server Core                            |
                 

## 4. Procédures de Remise en État des Services Critiques

| Élément                                         | Catégorie  | Problème                              | Action de reprise                                                                 | Criticité | Date de résolution prévue |
|-------------------------------------------------|------------|--------------------------------------|----------------------------------------------------------------------------------|-----------|--------------------------|
| Serveur Iredmail                                | Messagerie | Défaillant                            | Vérifier et redémarrer les services, restaurer les sauvegardes, tester la messagerie. | Majeur    | 22/09/2024               |
| Routeur Vyos                                    | Réseau     | Défaillant                            | Redémarrer et vérifier la configuration, tester la connectivité réseau.              | Critique  | 22/09/2024               |
| Serveur GUI : Disques de sauvegarde et stockage | Stockage   | Fonctionnalité partielle              | Réparer/remplacer les disques, vérifier l'intégrité des données, relancer les sauvegardes. | Majeur    | 22/09/2024               |
| OpenVPN                                         | Réseau     | Carte réseau HS                       | Remplacer la carte réseau, reconfigurer les interfaces VPN, valider la stabilité.    | Majeur    | 22/09/2024               |
| Zabbix                                          | Réseau     | Carte réseau HS                       | Diagnostiquer et remplacer la carte, reconfigurer les interfaces réseau.             | Majeur    | 22/09/2024               |
| Windows Server Core                             | Serveur    | Défaillant                            | Identifier la cause, redémarrer le serveur, tester la stabilité des services.       | Mineur    | 22/09/2024               |

## 5. Évolution de la remise en route

| Élément                                         | Catégorie  | Criticité | État       | Date de résolution |
|-------------------------------------------------|------------|-----------|------------|-------------------|
| Serveur Iredmail                                | Messagerie | Majeur    | Fonctionnel| 22/09/2024        |
| Routeur Vyos                                    | Réseau     | Critique  | Fonctionnel| 22/09/2024         |
| Serveur GUI : Disques de sauvegarde et stockage | Stockage   | Majeur    | Fonctionnel| 22/09/2024         |
| OpenVPN                                         | Réseau     | Majeur    | Fonctionnel| 22/09/2024          |
| Zabbix                                          | Réseau     | Majeur    | Fonctionnel| 22/09/2024          |
| Windows Server Core                             | Serveur    | Mineur    | Fonctionnel| 22/09/2024          |

## 6. Rôles et Responsabilités

| Rôle                          | Responsabilités                                                             |
|-------------------------------|----------------------------------------------------------------------------|
| Mohamed | Responsable des actions de reprise et du suivi des services réseau.      |
| Joris et Nicolas           | Assister dans la résolution des problèmes et le suivi des incidents.        |
| Mina et Julie                | Superviser les opérations de reprise et communiquer avec les parties prenantes. |

## 7. Communication et Documentation

| Communication          | Fréquence         | Description                                                           |
|------------------------|------------------|----------------------------------------------------------------------|
| Rapports de progrès    | Toutes les 4 heures | Communiquer l'avancement de la reprise aux équipes et à la direction. |
| Documentation des incidents | À chaque incident | Documenter les actions entreprises et les résultats obtenus.          |



