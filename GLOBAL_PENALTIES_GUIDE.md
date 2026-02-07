# Système Global de Pénalités - Guide Complet

## Vue d'ensemble

Les pénalités appliquées pendant les races sont maintenant intégrées dans le système global de scores et sauvegardées automatiquement.

---

## Flux Complet

### 1. **Pendant la Race (Phase 1 ou Phase 2)**

```
Race en cours
    ↓
Clique -5 ou -10 pour chaque équipe
    ↓
La pénalité s'affiche en rouge sous le timer
    ↓
Clique FINISH PHASE 1/2
    ↓
Modal de confirmation affiche toutes les pénalités
    ↓
Clique CONFIRM SAVE
```

### 2. **Sauvegarde des Pénalités**

Quand tu confirmes la sauvegarde:
- ✅ La race est sauvegardée dans RacesContext avec les pénalités
- ✅ Les pénalités sont transférées dans ScoresContext
- ✅ Chaque pénalité est tracée avec le nombre de races

### 3. **Affichage des Pénalités**

#### Dans l'écran SCORES (Phase 2):
```
CURRENT RANKING
#1  Team A     1500
    Penalties: -10 pts

#2  Team B     1200
```

#### Dans le GLOBAL LEADERBOARD:
```
| TEAM  | BEST TIME | AVG TIME | RACES | PENALTIES |
|-------|-----------|----------|-------|-----------|
| Team A| 00:45:30  | 00:50:00 | 3     | -10 pts   |
| Team B| 00:48:20  | 00:51:00 | 3     | -        |
```

---

## Structure de Données

### TeamScore (ScoresContext)

```typescript
interface TeamScore {
  name: string;
  score: number;           // Score de phase-2
  position: number;
  totalPenalties: number;  // Total des pénalités (négatif)
  races: number;          // Nombre de races avec pénalités
}
```

### Exemple:
```json
{
  "name": "Team A",
  "score": 1500,
  "position": 1,
  "totalPenalties": -15,   // 3 races: -5, -5, -5
  "races": 3
}
```

---

## Détails Techniques

### 1. **RaceManager.tsx**

Quand la race est sauvegardée:

```typescript
addRace({ ...finishedRace, phase });

// Pour chaque équipe avec pénalité
currentRace.timers.forEach((timer) => {
  if (timer.penalty < 0) {
    addTeamPenalties(timer.team, timer.penalty, 1);
  }
});
```

### 2. **ScoresContext.tsx**

Nouvelle méthode `addTeamPenalties`:

```typescript
const addTeamPenalties = (teamName: string, penalties: number, raceCount: number) => {
  // Ajoute les pénalités au score global
  // penalties est négatif (ex: -5, -10)
  // raceCount track le nombre de races affectées
};
```

### 3. **GlobalLeaderboard.tsx**

Récupère les pénalités:

```typescript
const { getTeamPenalties } = useScores();
result.totalPenalties = getTeamPenalties(timer.team);
```

Affiche dans la colonne "PENALTIES":
- `-10 pts` si des pénalités
- `-` si aucune pénalité

---

## Cas d'Utilisation

### Scénario 1: Race avec une équipe pénalisée

1. Race Phase 1 terminée
2. Team A a -5 de pénalité
3. Confirmation et sauvegarde
4. Team A.totalPenalties = -5

### Scénario 2: Multiple races avec pénalités

1. Première race: Team A -5
2. Deuxième race: Team A -10
3. Troisième race: Team A -5
4. **Team A.totalPenalties = -20**

### Scénario 3: Vue globale

Dans GLOBAL LEADERBOARD:
- Toutes les pénalités de toutes les races sont cumulées
- Affichées clairement en orange
- Permettent de voir l'impact total des pénalités

---

## Persistance des Données

Les pénalités sont sauvegardées dans localStorage:

```
Key: "urc-team-scores"
Value: [
  {
    "name": "Team A",
    "score": 1500,
    "totalPenalties": -15,
    "races": 3
  },
  ...
]
```

Les données persistent:
- ✅ Entre les sessions
- ✅ Entre les navigations
- ✅ Entre les phases

---

## Affichage Récapitulatif

### ScoresInput.tsx (Phase 2)
- Affiche le score et les pénalités côte à côte
- Pénalités en orange avec texte "Penalties: -X pts"
- Se met à jour automatiquement après chaque race

### GlobalLeaderboard.tsx
- Colonne supplémentaire "PENALTIES"
- Agrège les pénalités de toutes les races
- Trie d'abord par temps, puis affiche les pénalités

---

## Actions Possibles

### Pour ajouter une pénalité:
```typescript
handleAddPenalty(teamName, 5);   // Ajoute -5
handleAddPenalty(teamName, 10);  // Ajoute -10
```

### Pour consulter les pénalités:
```typescript
const penalties = getTeamPenalties("Team A");  // Retourne -15
```

### Pour réinitialiser:
```typescript
resetScores();  // Efface tous les scores ET les pénalités
```

---

## Logs de Débogage

Le système loggue les actions importantes:

```javascript
[v0] Finishing race with penalties: [...]
[v0] Adding penalty to Team A : 5
[v0] Saving penalty for Team A : -5
[v0] Adding penalties to Team A : -5
```

Consultez la console pour vérifier les opérations.

---

## Notes Importantes

⚠️ **Points clés à retenir:**

1. Les pénalités sont **négatives** (-5, -10, etc.)
2. Elles s'**accumulent** à travers les races
3. Elles sont **sauvegardées** automatiquement
4. Elles s'affichent dans **TOUS les leaderboards**
5. Elles persistent en **localStorage**

---

## Procédure Complète de Test

1. Crée 2-3 équipes
2. Lance une race Phase 1
3. Ajoute -5 à la première équipe
4. Ajoute -10 à la deuxième équipe
5. Termine la race et confirme
6. Vérifie dans SCORES que les pénalités sont affichées
7. Vérifie dans GLOBAL LEADERBOARD que la colonne PENALTIES montre les pénalités
8. Relance le navigateur - les données persistent
