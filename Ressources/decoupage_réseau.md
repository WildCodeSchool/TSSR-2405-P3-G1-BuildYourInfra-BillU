# Proposition de Découpage Réseau Asymétrique pour l'Entreprise BillU

## Réseau :

### IP : 172.18.1.0/24

### Table des Pouvoirs de 2

- 2^0 = 1
- 2^1 = 2
- 2^2 = 4
- 2^3 = 8
- 2^4 = 16
- 2^5 = 32
- 2^6 = 64
- 2^7 = 128
- 2^8 = 256
- 2^9 = 512
- 2^10 = 1024
- 2^11 = 2048

### Répartition par département en fonction de l'effectif

| Département                          | Effectif | Calcul              | Sous-réseau | Adresses Disponibles |
| ------------------------------------ | -------- | ------------------- | ----------- | -------------------- |
| Communication et relations publiques | 18       | 2^5 = 32 - 2 = 30   | /27         | 30                   |
| Département juridique                | 10       | 2^4 = 16 - 2 = 14   | /28         | 14                   |
| Développement logiciel               | 94       | 2^7 = 128 - 2 = 126 | /25         | 126                  |
| Direction                            | 3        | 2^3 = 8 - 2 = 6     | /29         | 6                    |
| DSI                                  | 12       | 2^4 = 16 - 2 = 14   | /28         | 14                   |
| Finance et comptabilité              | 8        | 2^4 = 16 - 2 = 14   | /28         | 14                   |
| QHSE                                 | 4        | 2^3 = 8 - 2 = 6     | /29         | 6                    |
| Service commercial                   | 15       | 2^5 = 32 - 2 = 30   | /27         | 30                   |
| Service recrutement                  | 3        | 2^3 = 8 - 2 = 6     | /29         | 6                    |

### Adressage des Réseaux

#### Développement logiciel

- **Adresse de réseau** : 172.18.1.0/25
- **Début de plage IP disponible** : 172.18.1.1
- **Fin de plage IP disponible** : 172.18.1.127
- **Adresse de broadcast** : 172.18.1.128

#### Communication et relations publiques

- **Adresse de réseau** : 172.18.1.129/27
- **Début de plage IP disponible** : 172.18.1.130
- **Fin de plage IP disponible** : 172.18.1.160
- **Adresse de broadcast** : 172.18.1.161

#### Service commercial

- **Adresse de réseau** : 172.18.1.162/27
- **Début de plage IP disponible** : 172.18.1.163
- **Fin de plage IP disponible** : 172.18.1.193
- **Adresse de broadcast** : 172.18.1.194

#### Département juridique

- **Adresse de réseau** : 172.18.1.195/28
- **Début de plage IP disponible** : 172.18.1.196
- **Fin de plage IP disponible** : 172.18.1.210
- **Adresse de broadcast** : 172.18.1.211

#### DSI

- **Adresse de réseau** : 172.18.1.212/28
- **Début de plage IP disponible** : 172.18.1.213
- **Fin de plage IP disponible** : 172.18.1.227
- **Adresse de broadcast** : 172.18.1.228

#### Finance et comptabilité

- **Adresse de réseau** : 172.18.1.229/28
- **Début de plage IP disponible** : 172.18.1.230
- **Fin de plage IP disponible** : 172.18.1.244
- **Adresse de broadcast** : 172.18.1.245

#### Direction

- **Adresse de réseau** : 172.18.1.246/29
- **Début de plage IP disponible** : 172.18.1.247
- **Fin de plage IP disponible** : 172.18.1.253
- **Adresse de broadcast** : 172.18.1.254

#### QHSE

- **Adresse de réseau** : 172.18.2.0/29
- **Début de plage IP disponible** : 172.18.2.1
- **Fin de plage IP disponible** : 172.18.2.7
- **Adresse de broadcast** : 172.18.2.8

#### Service recrutement

- **Adresse de réseau** : 172.18.2.9/29
- **Début de plage IP disponible** : 172.18.2.10
- **Fin de plage IP disponible** : 172.18.2.16
- **Adresse de broadcast** : 172.18.2.17
