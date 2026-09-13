# EdgeTX Snap-Flap System 🚀

Système de mixage **Snap-Flap** avancé pour EdgeTX, développé spécialement pour les planeurs de performance (F3F, voltige, vélivolerie). 

Ce système remplace les mixages standards par une solution dynamique offrant une courbe de réponse logarithmique, une gestion complète par Variables Globales (GVars), et une interface graphique directement intégrée à l'écran de votre radiocommande.

## ✨ Fonctionnalités clés

- **Courbe logarithmique** : Action douce autour du neutre et réponse agressive en fin de course, sans cassure.
- **Variables Globales (GV1-GV9)** : Ajustement dynamique de chaque paramètre selon vos phases de vol.
- **Outil de Configuration Visuel** : Interface de réglage (`Tool`) avec tracé de la courbe en temps réel.
- **Widget Adaptatif** : Affichage compact ou plein écran (avec graphique dynamique) de vos réglages actuels sur l'écran principal.
- **Zero-Lag** : Chargement optimisé de la configuration au démarrage pour préserver la carte SD et garantir une latence nulle en vol.

## 📁 Installation rapide

1. Téléchargez la dernière version dans la section **Releases**.
2. Copiez les dossiers `SCRIPTS` et `WIDGETS` à la racine de la carte SD de votre radio EdgeTX.
3. Déclarez le script `snap_mix.lua` dans la page **Mixages** de votre modèle.
4. Lancez le script `snap.lua` depuis le menu **Outils** (Système) pour initialiser la configuration.

📖 **Pour un guide détaillé pas-à-pas avec images, consultez le [Manuel d'Installation PDF](MANUEL_INSTALLATION.pdf).**

## 🛠️ Compatibilité
Testé et validé sur les radios sous **EdgeTX** disposant d'un écran couleur (Radiomaster TX16S, Boxer avec écran couleur externe, etc.).

## 📝 Licence
Ce projet est open-source sous licence **MIT**. Sentez-vous libre de le modifier pour vos propres planeurs.
