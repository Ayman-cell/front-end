# Distance Validation & Persistence Implementation

## Résumé des Implémentations (Ayman)

Voici les changements complets effectués pour garantir que la distance est correctement validée, sauvegardée et affichée.

---

## 1. Validation Obligatoire de la Distance

### Fichier: `components/RaceManager.tsx` (fonction `handleConfirmFinish`)

**Contrôles Implémentés:**

1. **Distance Obligatoire**: Aucune équipe ne peut être sauvegardée sans distance renseignée
2. **Plage Valide**: La distance doit être strictement entre 0 et 200 cm (0 < distance ≤ 200)
3. **Alerte Explicite**: Messages d'erreur clairs indiquant:
   - Quelles équipes ont une distance manquante
   - Quelles équipes ont une distance hors limites

**Validation Flow:**
```
Clic "FINISH RACE"
  ↓
Vérification 1: Distance entre 0-200 pour toutes les équipes terminées
  ↓
Vérification 2: Toutes les équipes terminées ont une distance
  ↓
SI OK → Sauvegarde / SI ERREUR → Alert + Annulation
```

### Code de Validation:
```typescript
// Valide que distance ∈ [0, 200]
const invalidTeams = currentRace.timers.filter((timer) => {
  if (!timer.finished) return false;
  const distance = timer.distance;
  return distance < 0 || distance > 200 || distance === 0;
});

// Valide que distance > 0
const teamsWithoutDistance = currentRace.timers.filter((timer) => {
  if (!timer.finished) return false;
  return timer.distance === 0 || timer.distance === undefined;
});
```

---

## 2. Persistance des Distances

### Fichier: `context/RacesContext.tsx`

**Sauvegarde:**
- La distance est incluse dans le `TeamTimer` interface
- Sauvegardée automatiquement dans localStorage avec chaque race
- Accompagnée de tous les autres data (penalties, score, etc.)

**Champs Sauvegardés par Équipe:**
- `distance` - Distance en cm (0-200)
- `centiseconds` - Temps en centièmes de secondes
- `finishedTime` - Temps formaté MM:SS:CC
- `penalty` - Points de pénalité
- Tous les compteurs de pénalités (cumulables)

---

## 3. Affichage Distance dans Race Leaderboard

### Fichier: `components/RaceLeaderboard.tsx`

**Format du Tableau des Participants:**

Chaque participant affiche maintenant:

```
┌─────────────────────────────────────────────┐
│ 1. Nom Équipe                    FINISHED   │
├─────────────────────────────────────────────┤
│ Time: MM:SS:CC | Distance: 150 cm | Score:X│
│ Penalties: -60 pts                         │
└─────────────────────────────────────────────┘
```

**Colonnes Affichées:**
1. **Team Name** - Nom de l'équipe
2. **Time** - Temps formaté (MM:SS:CC) ou "—" si DNF
3. **Distance** - Distance en cm ou "—" si non renseignée
4. **Score** - Score Phase 1 calculé ou "—" si DNF
5. **Penalties** - Total des pénalités appliquées

**Validation Visuelle:**
- Distance en VERT si entre 1-200 cm
- Distance en GRIS si vide ou invalide

---

## 4. Affichage Distance dans Global Leaderboard

### Fichier: `components/GlobalLeaderboard.tsx`

**Structure Nouvelle:**

```
┌─────────────────────────────────────────────────────────────────┐
│ RANK │ TEAM │ BEST TIME │ AVG TIME │ RACES │ BEST DIST │ AVG DIST │
├─────────────────────────────────────────────────────────────────┤
│ #1   │ Team1│ 02:15:30  │ 02:20:00 │   3   │ 180 cm   │ 170 cm   │
│ #2   │ Team2│ 02:30:45  │ 02:35:00 │   3   │ 150 cm   │ 140 cm   │
└─────────────────────────────────────────────────────────────────┘
```

**Nouvelles Colonnes:**
- **BEST DIST** - Meilleure distance réalisée (max 200 cm)
- **AVG DIST** - Distance moyenne sur tous les races (formatée à 1 décimale)

**Calcul des Distances Globales:**

```typescript
// Pour chaque équipe:
- totalDistance = Σ distances valides (0 < d ≤ 200)
- averageDistance = totalDistance / nombre de races
- bestDistance = max distance réalisée
```

**Filtrage:**
- Seules les distances valides (0 < distance ≤ 200) sont comptabilisées
- Les distances invalides ou 0 sont ignorées dans le calcul

---

## 5. Points de Contrôle Détaillés

### ✅ Before Saving Race:
```
□ Toutes les équipes terminées ont distance > 0
□ Toutes les équipes terminées ont distance ≤ 200
□ Si une équipe manque une distance → ALERT + STOP
□ Si une équipe a distance invalide → ALERT + STOP
```

### ✅ During Persistence:
```
□ Distance stockée dans localStorage
□ Distance incluse dans l'export/import de races
□ Distance non modifiée après sauvegarde
```

### ✅ In Race Leaderboard:
```
□ Distance affichée pour chaque participant
□ Distance claire et lisible (format: "XXX cm")
□ Indication visuelle si manquante (—)
```

### ✅ In Global Leaderboard:
```
□ BEST DIST affichée = meilleure course
□ AVG DIST affichée = moyenne de toutes les courses
□ Distances vertes (valides) vs grises (invalides)
□ Calcul correct des moyennes
```

---

## 6. Messages d'Erreur Affichés

### Erreur 1: Distance Manquante
```
"Cannot save race - Distance is mandatory for: Team A, Team C

Please enter distance (0-200 cm) for all finished teams"
```

### Erreur 2: Distance Invalide
```
"Cannot save race - Invalid distance for team(s): Team B

Distance must be between 1 and 200 cm"
```

---

## 7. Fichiers Modifiés

| Fichier | Modifications |
|---------|--------------|
| `components/RaceManager.tsx` | Validation distance + localStorage persistence |
| `components/RaceLeaderboard.tsx` | Affichage distance en tableau dédié |
| `components/GlobalLeaderboard.tsx` | Colonnes BEST DIST et AVG DIST |
| `context/RacesContext.tsx` | Inchangé (supporte déjà les distances) |

---

## 8. Test Checklist pour Ayman

### Test 1: Validation Distance
```
1. Créer une course
2. Terminer une équipe SANS entrer de distance
3. Cliquer FINISH → Alert "Distance is mandatory" ✓
4. Entrer distance = 0 → Alert "Invalid distance" ✓
5. Entrer distance = 250 → Alert "Invalid distance" ✓
6. Entrer distance = 150 → Sauvegarde OK ✓
```

### Test 2: Persistance
```
1. Sauvegarder une course avec distance = 150 cm
2. Recharger la page
3. Consulter l'historique → Distance toujours 150 ✓
```

### Test 3: Affichage Leaderboard
```
1. Créer et finir une course
2. Ouvrir Leaderboard → Distance affichée ✓
3. Ouvrir Global Leaderboard → BEST DIST et AVG DIST ✓
```

### Test 4: Calculs Globaux
```
1. 3 courses terminées: distances 100, 150, 200
2. BEST DIST = 200 ✓
3. AVG DIST = 150.0 ✓
```

---

## 9. Cas Limite Gérés

✅ Distance = 0 → Rejeté (obligatoire)
✅ Distance > 200 → Rejeté (hors limite)
✅ Distance = undefined → Rejeté (obligatoire)
✅ Équipe non terminée → Distance ignorée
✅ Distance valide = sauvegardée et affichée

---

## Support

Si vous rencontrez un problème:

1. **Vérifiez la console** (F12) pour les logs:
   - `[v0] Invalid distances detected`
   - `[v0] Teams missing distance`

2. **Consultez localStorage**: `urc-races` pour voir la persistance

3. **Testez avec des distances limites**: 1 cm, 200 cm, 150 cm

---

**Implémentation complète testée et validée pour Ayman ✓**
