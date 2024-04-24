# Description de l'Utilitaire de Blocage d'Adresses IP pour Pare-feu Windows

---

## Description

Cet utilitaire PowerShell est conçu pour aider à bloquer les connexions inutiles sur un pare-feu Windows en utilisant des règles spécifiques. Il surveille le trafic réseau à l'aide de Wireshark, identifie les adresses IP uniques qui communiquent avec la connexion Ethernet, puis crée des règles de pare-feu pour bloquer ces adresses IP. Il effectue également une vérification et une suppression des règles en doublon pour maintenir un pare-feu propre et efficace.

---

## Fonctionnalités

- Observation du trafic réseau à l'aide de Wireshark.
- Identification des adresses IP uniques communiquant avec la connexion Ethernet.
- Création de règles de pare-feu pour bloquer ces adresses IP.
- Nettoyage des règles en doublon pour maintenir un pare-feu propre.

---

## Utilisation

1. Exécutez le script PowerShell dans un environnement compatible avec Windows PowerShell.
2. Laissez le script observer le trafic avec Wireshark et créer les règles de pare-feu appropriées.
3. Assurez-vous d'exécuter le script en tant qu'administrateur pour autoriser la création de règles de pare-feu.

---

## Contributeurs

- Romain CASTAGNÉ - https://github.com/CastagneSenpai
