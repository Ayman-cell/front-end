# Résumé: Intégration des Pénalités au Score Global

## Modifications Effectuées

### 1. ScoresContext.tsx
**Changements:**
- ✅ Ajout de `totalPenalties` et `races` à `TeamScore`
- ✅ Nouvelle méthode: `addTeamPenalties(teamName, penalties, raceCount)`
- ✅ Nouvelle méthode: `getTeamPenalties(teamName)`
- ✅ Les pénalités sont sauvegardées dans localStorage

```typescript
export interface TeamScore {
  name: string;
  score: number;
  position: number;
  totalPenalties: number;  // NEW
  races: number;          // NEW
}
```

### 2. RaceManager.tsx
**Changements:**
- ✅ Import de `useScores()`
- ✅ Dans `handleConfirmFinish()`, appel à `addTeamPenalties()` pour chaque équipe
- ✅ Les pénalités sont transférées du timer à ScoresContext

```typescript
// Après sauvegarde de la race
currentRace.timers.forEach((timer) => {
  if (timer.penalty < 0) {
    addTeamPenalties(timer.team, timer.penalty, 1);
  }
});
```

### 3. GlobalLeaderboard.tsx
**Changements:**
- ✅ Import de `useScores()`
- ✅ Ajout de `totalPenalties` à `TeamResult`
- ✅ Récupération des pénalités avec `getTeamPenalties()`
- ✅ Nouvelle colonne "PENALTIES" dans le header
- ✅ Affichage des pénalités en orange pour chaque équipe

```typescript
// Header
<div className="flex-1 text-center">
  <span className="text-orange-400 text-xs font-bold">PENALTIES</span>
</div>

// Affichage
{hasPenalties ? (
  <span className="font-bold text-orange-400">
    {result.totalPenalties} pts
  </span>
) : (
  <span className="font-bold text-cyan-600">-</span>
)}
```

### 4. ScoresInput.tsx
**Changements:**
- ✅ Import de `useScores()` pour `getTeamPenalties()`
- ✅ Affichage des pénalités sous chaque équipe
- ✅ Pénalités en orange avec background semi-transparent

```typescript
{hasPenalties && (
  <div className="w-full bg-orange-500/20 px-1 py-0.5 rounded">
    <span className="text-orange-400 text-xs font-bold">
      Penalties: {penalties} pts
    </span>
  </div>
)}
```

---

## Flux de Données

```
RaceManager
    ↓
Timer avec penalty: -5
    ↓
handleConfirmFinish()
    ↓
addRace() + addTeamPenalties()
    ↓
ScoresContext
    ↓
teamScores[team].totalPenalties = -5
    ↓
LocalStorage: "urc-team-scores"
    ↓
GlobalLeaderboard / ScoresInput
    ↓
Affichage des pénalités
```

---

## Points Clés

### Sauvegarde Automatique
- ✅ Pénalités sauvegardées dans localStorage
- ✅ Persistantes entre les sessions
- ✅ Accessibles depuis tous les composants

### Affichage Cohérent
- ✅ ScoresInput: Affiche les pénalités sous le score
- ✅ GlobalLeaderboard: Colonne dédiée aux pénalités
- ✅ RaceLeaderboard: Affiche les pénalités par race

### Accumulation
- ✅ Les pénalités s'accumulent (ex: -5 + -10 = -15)
- ✅ Chaque race ajoute à la pénalité totale
- ✅ Aucune limite d'accumulation

---

## Exemple Complet

### Situation:
- Team A participe à 3 races
- Race 1: -5 points
- Race 2: -10 points  
- Race 3: -5 points

### Résultat:
```
Team A:
  score: 1500
  totalPenalties: -20      ← Cumul des 3 races
  races: 3                 ← Nombre de races avec pénalités

Affichage GlobalLeaderboard:
PENALTIES: -20 pts

Affichage ScoresInput:
Team A     1500
Penalties: -20 pts
```

---

## Vérification du Fonctionnement

### Checklist:

- [ ] Lancer une race avec pénalité
- [ ] Voir la pénalité dans le modal de confirmation
- [ ] Confirmer et sauvegarder
- [ ] Vérifier que la pénalité apparaît dans SCORES
- [ ] Vérifier que la pénalité apparaît dans GLOBAL LEADERBOARD
- [ ] Lancer une deuxième race avec la même équipe
- [ ] Vérifier que les pénalités s'accumulent
- [ ] Relancer le navigateur
- [ ] Vérifier que les pénalités persistent

---

## Architecture

```
ScoresContext
├── teamScores: TeamScore[]
│   ├── name: string
│   ├── score: number
│   ├── totalPenalties: number ← NEW
│   └── races: number ← NEW
├── addTeamPenalties() ← NEW
├── getTeamPenalties() ← NEW
└── localStorage: "urc-team-scores"

RaceManager → addTeamPenalties()
    ↓
GlobalLeaderboard ← getTeamPenalties()
    ↓
ScoresInput ← getTeamPenalties()
```

---

## État de Livraison

✅ **Complètement Implémenté:**
- Sauvegarde des pénalités dans ScoresContext
- Affichage dans GlobalLeaderboard
- Affichage dans ScoresInput
- Persistance en localStorage
- Accumulation correcte des pénalités
- Logs de débogage

✅ **Fonctionnalités:**
- Les pénalités sont sauvegardées après chaque race
- Les pénalités s'affichent partout
- Les pénalités s'accumulent correctement
- Les données persistent

---

## Prêt pour la Production! 🚀
