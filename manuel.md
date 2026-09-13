# Manuel d'Installation et d'Utilisation - Snap-Flap EdgeTX

Ce document vous guide pas à pas dans l'installation et la configuration du système Snap-Flap sur votre radiocommande EdgeTX.

---

## 1. Prérequis

- Une radiocommande sous **EdgeTX** (version 2.8 ou supérieure recommandée).
- Un écran couleur (type Radiomaster TX16S).
- L'accès à la carte SD de votre radio (via USB ou lecteur de carte).

---

## 2. Copie des fichiers sur la carte SD

1. Connectez votre radio à votre ordinateur en mode **Stockage USB** (USB Storage).
2. Décompressez l'archive du projet.
3. Copiez l'architecture à la racine de votre carte SD. Vous devez obtenir ceci :

   - `SDCARD/SCRIPTS/MIXES/snflp.lua`
   - `SDCARD/SCRIPTS/TOOLS/SnapFlap Config.lua`
   - `SDCARD/SCRIPTS/CONFIG/snap_cfg.lua`
   - `SDCARD/WIDGETS/SnapInfo/main.lua`

---

## 3. Configuration du Mixage (La mécanique)

Le script de mixage se charge des mathématiques et de l'envoi de la commande aux gouvernes.

1. Allumez votre radio et sélectionnez votre modèle 
2. Allez dans le menu **Mixages** (Mixes).
3. Sur la voie correspondant à vos volets (ou sur une voie virtuelle intermédiaire), ajoutez un nouveau mixage.
4. Dans le champ **Source**, choisissez **Script LUA**..
6. Sélectionnez le script `snflp`.

<img width="748" height="315" alt="image" src="https://github.com/user-attachments/assets/e10982b9-0521-44c9-b531-bcc2485a0412" />
<img width="732" height="302" alt="image" src="https://github.com/user-attachments/assets/ab0b7007-24be-4654-bdd3-92e56d330a1f" />



---

## 4. Utilisation de l'Outil de Configuration (Le réglage)

C'est ici que vous définissez le comportement de votre planeur.

1. Appuyez longuement sur la touche **SYS** pour accéder aux paramètres système.
2. Allez dans l'onglet **Outils** (Tools).
3. Faites défiler vers le bas et sélectionnez **snap** (ou Snap-Flap Config).

<img width="706" height="291" alt="image" src="https://github.com/user-attachments/assets/1ec525de-9515-40e9-a88b-7eb365b0ce74" />


L'interface s'ouvre. Vous y trouverez 4 paramètres et le graphique de réponse à droite :
- **Zone Morte** : Ignorer les petits mouvements autour du neutre (ex: 5%).
- **Expo** : Courbure logarithmique. Plus la valeur est haute, plus le début de course est doux.
- **Ratio Base** : Le pourcentage d'action global sur les volets.
- **Saturation** : Le point du manche de profondeur où le snap-flap atteint son maximum.

**Comment régler ?**
- Utilisez la **Molette** pour naviguer entre les champs.
- Le paramètre sélectionné est encadré en **Bleu**.
- Appuyez sur **ENTRÉE** pour modifier une valeur (le cadre clignote en **Orange**).
- Tournez la molette pour changer la valeur :
  - **Chiffre fixe** (ex: 25%) : La valeur sera la même pour toutes les phases de vol.
  - **Variable Globale** (ex: `[GV1]`) : La valeur lira le contenu de la GV1, idéal pour changer l'agressivité entre la phase "Gratte" et la phase "Vitesse/F3F".
- Appuyez sur **ENTRÉE** pour valider, ou **RETOUR/EXIT** pour sauvegarder et quitter.

<img width="662" height="290" alt="image" src="https://github.com/user-attachments/assets/001f9210-88d5-419e-a6ca-b92e55b91c65" />


---

## 5. Ajout du Widget (Le contrôle visuel)

Pour garder un œil sur vos réglages en vol :

1. Sur l'écran principal, appuyez longuement sur la touche **TELEMETRY** (ou l'icône de l'écran).
2. Sélectionnez **Configuration des widgets** (Setup Widgets).
3. Choisissez une zone libre sur votre écran, appuyez dessus et sélectionnez **SnapInfo**.
4. Le widget s'adapte automatiquement à la taille de la zone :
   - **Petite zone** : Affichage compact des 4 valeurs.
   - **Grande zone / Plein écran** : Affichage des valeurs + tracé en direct de la courbe de réponse.

<img width="685" height="286" alt="image" src="https://github.com/user-attachments/assets/340ecaf2-3bb2-41e7-9788-5aab6ac4d385" />


---

**Bon vols et bons chronos !**
