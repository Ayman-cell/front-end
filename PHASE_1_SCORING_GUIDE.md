# Système de Notation Phase 1

## Système de Notation Mis à Jour

Le système de notation pour Phase 1 a été complètement restructuré selon les spécifications officielles:

### 1. **Distance Parcourue**
- **Valeur**: 1 point par centimètre
- **Maximum**: 200 points (pour 200 cm)
- **Saisie**: Entrez la distance en centimètres dans le champ dédié pour chaque équipe
- **Exemple**: 150 cm = 150 points

### 2. **Vitesse de Parcours**
- **Valeur**: 0.5 points par seconde d'avance
- **Calcul**: Basé sur le temps de parcours (moins c'est rapide, plus les points sont élevés)
- **Maximum**: 6 minutes (360 secondes) = 180 points de bonus de vitesse
- **Formule**: `(360 - temps_en_secondes) × 0.5`

### 3. **Limite de Temps**
- **Durée**: 6 minutes (360 secondes)
- **Affichage**: Le compte à rebours s'affiche en haut de l'écran de course
- **Dépassement**: À 6 minutes, la course s'arrête automatiquement

## Système de Pénalités

Les trois types de pénalités sont maintenant disponibles via des boutons à bascule sur chaque équipe:

### 1. **Contact Barrière** (🚧)
- **Pénalité**: -20 points
- **Description**: Contact avec une barrière du circuit
- **Activation**: Cliquer sur le bouton "🚧 -20"

### 2. **Mouvement durant Signal d'Arrêt** (⛔)
- **Pénalité**: -30 points
- **Description**: Mouvement du robot ou intervention durant un signal d'arrêt
- **Activation**: Cliquer sur le bouton "⛔ -30"

### 3. **Intervention Humaine** (🤚)
- **Pénalité**: -50 points
- **Description**: Intervention manuelle sur le robot durant la course
- **Activation**: Cliquer sur le bouton "🤚 -50"

## Calcul du Score Final

$$\text{Score Total} = \text{Distance} + \text{Bonus Vitesse} - \text{Pénalités}$$

### Exemple de Calcul:
```
Distance: 150 cm → 150 points
Temps: 120 secondes → Bonus: (360 - 120) × 0.5 = 120 points
Contact Barrière: -20 points
Mouvement Signal d'Arrêt: -30 points

Score Total = 150 + 120 - 20 - 30 = 220 points
```

## Interface de Race

### Avant la Course
1. Cliquez sur "ADD RACE" pour commencer
2. Sélectionnez un profil de roue (wheel) ou utilisez toutes les équipes
3. Sélectionnez les équipes qui participent (jusqu'à 5)
4. Cliquez sur "START"

### Pendant la Course
1. Cliquez sur "BEGIN" pour démarrer le chronomètre
2. Pour chaque équipe:
   - **Distance**: Entrez la distance parcourue en centimètres
   - **Pénalités**: Activez les pénalités applicables en cliquant sur les boutons
   - **STOP**: Arrêtez le chronomètre pour cette équipe quand elle termine
   - **SAVE**: Sauvegardez les données de l'équipe

3. Le compte à rebours de 6 minutes s'affiche en haut

### Après la Course
1. Cliquez sur "FINISH PHASE 1" quand toutes les équipes ont terminé
2. Vérifiez le résumé de la course (distances, pénalités, temps)
3. Cliquez sur "SAVE RACE" pour enregistrer les résultats

## Classement

Le classement est calculé automatiquement par score décroissant:
- Les équipes avec le score le plus élevé apparaissent en première position
- Les équipes qui n'ont pas terminé apparaissent à la fin avec "NOT FINISHED"
- Le score est affiché en jaune pour chaque équipe

## Modifications Techniques

- **TeamTimer Interface**: Ajout de `distance`, `barrierContact`, `stopSignalViolation`, `humanIntervention`
- **MAX_RACE_TIME**: Changé de 60 secondes (1 minute) à 360 secondes (6 minutes)
- **Fonction calculatePhase1Score()**: Implémente le nouveau système de notation
- **Handlers**: `handleSetDistance()`, `handleTogglePenalty()` pour gérer les entrées
- **Classement**: Basé sur le score Phase 1 plutôt que sur le temps
