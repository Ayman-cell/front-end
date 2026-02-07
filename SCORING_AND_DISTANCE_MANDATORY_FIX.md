# Scoring et Distance Obligatoire - Implémentation

## Changements Appliqués

### 1. Distance Obligatoire (RaceManager)

**Problème résolu:**
- Avant: Le bouton "SAVE RACE" était toujours actif, même sans distances
- Après: Impossible de sauvegarder tant que la distance n'est pas rentrée pour TOUS

**Code:**
```typescript
// Vérifie que tous les distances sont valides (0-200 cm)
const allDistancesEntered = (): boolean => {
  if (!currentRace) return false;
  return currentRace.timers.every((timer) => {
    const distance = timer.distance;
    return (
      distance !== undefined && 
      distance !== null && 
      !isNaN(distance) && 
      distance >= 0 && 
      distance <= 200
    );
  });
};
```

**Comportement:**
- Alerte affichée si on clique sur "Finish Race" sans distances complètes
- Bouton "SAVE RACE" grisé et désactivé visuellement
- Message: "⚠️ La distance est obligatoire pour TOUS les participants!"

### 2. Score Phase 1 Toujours Calculé

**Avant:** Score affiché comme "—" pour les non-finishers
**Après:** Score calculé MÊME pour les DNF (Did Not Finish)

**Formule Appliquée:**
```
total_score_phase_1 = distance_points + speed_score + penalties

Où:
- distance_points = distance en cm (0-200)
- speed_score = 0 pour les non-finishers (car 360 - 360 = 0)
- speed_score = (360 - time_seconds) * 0.5 pour les finishers avec time < 360
- penalties = -(barrier×20 + stop_signal×30 + intervention×50)
```

**Fichiers Modifiés:**
1. **RaceLeaderboard.tsx** - Ligne 231 et 273
   - Avant: `{!isNotFinished ? calculatePhase1Score(timer).toFixed(1) : '—'}`
   - Après: `{calculatePhase1Score(timer).toFixed(1)}`

2. **GlobalLeaderboard.tsx** - Ligne 258
   - Avant: `{isUnfinished ? '—' : result.phase1Score.toFixed(1)}`
   - Après: `{result.phase1Score.toFixed(1)}`

### 3. Logs de Débogage

Quand vous sauvegardez une course, le console affiche:
```
[v0] === PHASE 1 SCORING VALIDATION ===
[v0] IMPORTANT: Scoring applies to ALL teams, even non-finishers
[v0] Formula: distance_points + speed_score + penalties
[v0] Non-finishers: speed_score = 0 (no time bonus)
[v0] ---
[v0] Team_Name:
  - Finished: NO (DNF)
  - Time: DNF (360s timeout)
  - Distance: 45 cm → +45 pts
  - Speed Score: 0.0 pts (DNF = 0)
  - Penalties: -20×1 -30×0 -50×0 = -20
  - FINAL SCORE: 25.0 pts
[v0] ---
```

## Cas d'Utilisation

### Exemple 1: Équipe Qui Finit (time < 360)
- Distance: 100 cm
- Time: 200 secondes
- Barrier Contact: 1 fois
- **Score = 100 + (360-200)×0.5 - 20 = 100 + 80 - 20 = 160 pts**

### Exemple 2: Équipe Qui Ne Finit Pas (DNF)
- Distance: 75 cm
- Time: DNF (360s)
- Stop Signal: 2 fois
- **Score = 75 + 0 - 60 = 15 pts**

### Exemple 3: Équipe Qui Finit Juste au Temps (time = 360)
- Distance: 50 cm
- Time: 360 secondes
- Human Intervention: 1 fois
- **Score = 50 + 0 - 50 = 0 pts** (car speed_score = 0 quand time ≥ 360)

## Vérification

✅ Distance obligatoire avant Save
✅ Bouton Save désactivé visuellement si distances manquantes
✅ Score calculé TOUJOURS (même DNF)
✅ Formule correcte pour finishers ET non-finishers
✅ Logs détaillés dans la console pour vérification
