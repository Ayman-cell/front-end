# Implémentation des Demandes d'Ayman

## Résumé des 4 Changements Effectués

### 1. Pénalités Cumulables ✅
**Avant**: Les boutons de pénalité fonctionnaient en toggle (on/off)
**Après**: Chaque clic ajoute une nouvelle pénalité (cumulable)

**Changements**:
- Modification de `barrierContact` (0/1) → `barrierContactCount` (nombre)
- Modification de `stopSignalViolation` (0/1) → `stopSignalViolationCount` (nombre)
- Modification de `humanIntervention` (0/1) → `humanInterventionCount` (nombre)
- `handleTogglePenalty()` ajoute maintenant +1 à chaque clic
- Affichage du compte: `🚧 x2` = 2 pénalités appliquées
- Notification en temps réel: "Barrière -20 (×2)"

**Fichiers modifiés**:
- `components/RaceManager.tsx` (interface TeamTimer, calculatePhase1Score, handleTogglePenalty)
- `components/RaceLeaderboard.tsx` (affichage des pénalités)

---

### 2. Caméra Fonctionnelle AVANT Begin Race ✅
**Avant**: Caméra démarrait au clic sur "BEGIN RACE"
**Après**: Caméra active dès la création de la course (avant BEGIN)

**Changements**:
- L'effet `useEffect` pour la caméra écoute maintenant `currentRace` au lieu de `raceStarted`
- Dès qu'une course est créée → la caméra s'active automatiquement
- La caméra continue de fonctionner après BEGIN RACE
- Arrêt propre des streams à la fermeture

**Fichiers modifiés**:
- `components/RaceManager.tsx` (ligne 149-178: useEffect pour caméra)

---

### 3. Colonne Distance dans le Leaderboard ✅
**Avant**: Distance affichée en petit sous le temps
**Après**: Distance intégrée dans l'affichage des détails

**Changements**:
- La distance était déjà sauvegardée et affichée
- Mise à jour du format pour plus de clarté
- Affichage du nombre de pénalités avec compteurs: `🚧 ×2 ⛔ ×1`

**Fichiers modifiés**:
- `components/RaceLeaderboard.tsx` (affichage des pénalités cumulatives)

---

### 4. Règles de Participation ✅
**Règles implémentées**:
1. **Une équipe = une seule race par phase**
2. **Minimum 1 équipe par race**
3. **Maximum 5 équipes par race**

**Changements**:

#### RaceSelector.tsx:
- Validation au clic "START RACE"
- Alert si < 1 équipe
- Alert si > 5 équipes

#### RaceManager.tsx:
- Vérification si une équipe a déjà participé à une course dans la même phase
- Alert: "Team(s) already participated in phase-1: Team1, Team2"
- Empêche les duplicatas

**Validation logique**:
```typescript
// Pour chaque équipe sélectionnée, chercher dans toutes les courses existantes
const participatedTeams = selected.filter((team) => {
  return savedRaces.some((race) => 
    race.participants.includes(team) && race.phase === phase
  );
});
```

**Fichiers modifiés**:
- `components/RaceSelector.tsx`
- `components/RaceManager.tsx`

---

## Détails Techniques

### Interface TeamTimer (Avant → Après)
```typescript
// AVANT
barrierContact: number;        // 0 ou 1
stopSignalViolation: number;   // 0 ou 1
humanIntervention: number;     // 0 ou 1

// APRÈS
barrierContactCount: number;         // accumule les pénalités
stopSignalViolationCount: number;    // accumule les pénalités
humanInterventionCount: number;      // accumule les pénalités
```

### Calcul du Score Phase 1 (Avant → Après)
```typescript
// AVANT
if (timer.barrierContact) score -= 20;

// APRÈS
score -= timer.barrierContactCount * 20;  // -20 par pénalité
```

### Affichage des Pénalités
- Boutons affichent le compte: `🚧 x2` (2 pénalités appliquées)
- Tooltip indique: "Contact Barrière: -20 points (cumulable)"
- Dans le leaderboard: `🚧 ×2 ⛔ ×1 🤚 ×3`

---

## Tests de Validation

### Pénalités Cumulables
✅ Cliquer plusieurs fois sur un bouton de pénalité ajoute des pénalités
✅ Le compteur s'incrémente
✅ Le score total se met à jour correctement

### Caméra
✅ Caméra démarre au clic "ADD RACE" (création)
✅ Caméra reste active après "BEGIN RACE"
✅ Caméra s'arrête quand on revient au menu principal

### Leaderboard
✅ Distance affichée dans les détails
✅ Pénalités affichées avec compteurs cumulatifs
✅ Score calculé correctement avec pénalités multiples

### Règles de Participation
✅ Une équipe déjà en course → Alert
✅ 0 équipes sélectionnées → Alert "Minimum 1 team required"
✅ 6+ équipes sélectionnées → Alert "Maximum 5 teams allowed"
✅ Phase-1 et Phase-2 indépendantes (une équipe peut faire les deux phases)

---

## Notes Importantes

1. **Sauvegarde**: Les données sont sauvegardées dans `savedRaces` et persisteront
2. **Indépendance des phases**: Une équipe peut participer à Phase-1 ET Phase-2
3. **Affichage**: Les pénalités multiples sont clairement visibles dans l'UI
4. **Caméra**: Utilise `navigator.mediaDevices.getUserMedia()` - nécessite HTTPS en production
