# Système Complet de Pénalité et Sauvegarde

## Vue d'ensemble

Ce guide explique le flux complet de gestion des pénalités pendant une race et leur sauvegarde.

## Flux Détaillé

### 1. Pendant la Race (RaceManager)

#### Affichage des Timers
- Chaque équipe a son propre timer affichant le temps en cours
- Deux boutons de pénalité apparaissent sous chaque timer:
  - **-5** (orange): Ajoute -5 points de pénalité
  - **-10** (rouge): Ajoute -10 points de pénalité

#### Application des Pénalités
```
Quand tu cliques -5:
- La pénalité devient -5 (négatif)
- L'équipe affiche "Penalty: -5" en rouge
- Cette pénalité est stockée dans currentRace.timers[].penalty

Quand tu cliques -10:
- La pénalité devient -10 (négatif)  
- L'équipe affiche "Penalty: -10" en rouge
- La pénalité s'ajoute à la précédente (cumulative)
```

**Structure de données:**
```typescript
interface TeamTimer {
  team: string;
  centiseconds: number;      // Temps écoulé
  finishedTime: string;      // Format MM:SS:CC
  finished: boolean;         // Équipe terminée?
  penalty: number;           // -5, -10, -15, etc.
}
```

### 2. Finir la Race (Étape Critique)

#### Avant la Sauvegarde
Quand tu cliques le bouton **"FINISH PHASE 1"**:
1. Un modal de confirmation s'affiche
2. Il montre TOUS les timers avec leurs pénalités appliquées
3. Un avertissement orange indique le nombre d'équipes avec pénalités

#### Modal de Confirmation
```
┌─────────────────────────────────────┐
│        FINISH RACE?                 │
├─────────────────────────────────────┤
│                                     │
│ RACE SUMMARY                        │
│                                     │
│ Équipe A        01:23:45           │
│ ├─ Penalty: -5 points (500 cs)     │
│                                     │
│ Équipe B        00:59:30           │
│                                     │
│ ⚠ 1 team(s) with penalties         │
│   will be applied when race saved   │
│                                     │
│ [CONFIRM SAVE]  [CANCEL]           │
└─────────────────────────────────────┘
```

### 3. Sauvegarde (handleConfirmFinish)

Quand tu cliques **"CONFIRM SAVE"**:

1. **Les données sauvegardées incluent:**
   - Temps de chaque équipe
   - **Pénalités exactement comme elles ont été appliquées**
   - État finished/not finished de chaque équipe
   - Timestamp et ID unique de la race

2. **Stockage:**
   ```
   RacesContext → localStorage ('urc-races')
   
   Structure:
   {
     id: "race-1707123456789",
     timestamp: 1707123456789,
     participants: ["Équipe A", "Équipe B"],
     timers: [
       {
         team: "Équipe A",
         centiseconds: 8345,
         finishedTime: "01:23:45",
         finished: true,
         penalty: -5  // ← SAUVEGARDÉ ICI
       },
       {
         team: "Équipe B",
         centiseconds: 5930,
         finishedTime: "00:59:30",
         finished: true,
         penalty: 0
       }
     ],
     finished: true,
     phase: "phase-1"
   }
   ```

3. **Message de confirmation:**
   ```
   "Race saved successfully with penalties!"
   ```
   (S'affiche 3 secondes puis disparaît)

### 4. Consultation dans le Leaderboard

Quand tu consultes les résultats sauvegardés:

#### RaceLeaderboard affiche:
```
Classement (avec pénalités considérées):
#1 Équipe B       00:59:30
#2 Équipe A       01:23:45
              ├─ Penalty: -5 points (500 cs)
              └─ Final: 01:32:45
```

#### Calcul du temps final:
```
Temps Final = Temps Réel + (Abs(Pénalité) × 100 centiseconds)

Exemple:
- Équipe A: 01:23:45 (8345 cs) + (-5 pénalité)
- Pénalité en centiseconds: 5 × 100 = 500 cs
- Temps Final: 8345 + 500 = 8845 cs = 01:27:45
```

### 5. Récapitulatif Visuel

```
PENDANT LA RACE
├─ Appliquer pénalités (-5, -10)
├─ Voir les pénalités affichées en rouge
└─ Les pénalités s'accumulent

FINIR LA RACE (FINISH BUTTON)
├─ Modal affiche toutes les pénalités
├─ Vérification avant sauvegarde
└─ Choix: CONFIRM SAVE ou CANCEL

APRÈS SAUVEGARDE
├─ Pénalités sont stockées dans RacesContext
├─ Visibles dans le Leaderboard
├─ Affectent le classement final
└─ Peuvent être consultées ultérieurement
```

## Points Importants

✅ **Les pénalités sont:**
- Appliquées instantanément pendant la race
- Accumulables (multiples clics = pénalités additionnées)
- Affichées en temps réel
- Sauvegardées dans RacesContext quand tu cliques "CONFIRM SAVE"
- Considérées dans le classement final

❌ **Les pénalités ne sont PAS:**
- Perdues si tu annules le modal
- Réinitialisées automatiquement
- Supprimées en cliquant "CANCEL"

## Déboguer les Pénalités

**Vérifier les logs:**
```javascript
// Dans la console du navigateur (F12)
// Tu devrais voir:
[v0] Adding penalty to Équipe A : 5
[v0] Finishing race with penalties: [...]
```

**Vérifier localStorage:**
```javascript
// Dans la console:
JSON.parse(localStorage.getItem('urc-races'))
// Cherche le champ "penalty" dans les timers
```

## Exemple Complet

### Scénario: Race avec Pénalités

**Pendant la race:**
```
Équipe A: 01:20:00
├─ Clics -5 → penalty: -5
├─ Clics -5 → penalty: -10
└─ Affichage: "Penalty: -10"

Équipe B: 01:15:30
└─ Aucune pénalité
```

**Clic "FINISH PHASE 1":**
```
Modal affiche:
- Équipe A: 01:20:00 (Penalty: -10)
- Équipe B: 01:15:30
- Avertissement: 1 team with penalties
```

**Clic "CONFIRM SAVE":**
```
Race sauvegardée avec:
- Équipe A: 01:20:00, penalty: -10
- Équipe B: 01:15:30, penalty: 0
```

**Dans le Leaderboard:**
```
#1 Équipe B: 01:15:30
#2 Équipe A: 01:20:00
   ├─ Penalty: -10 points (1000 cs)
   └─ Final: 01:30:00
```

---

**Résumé:** Les pénalités sont appliquées pendant la race, confirmées avant sauvegarde, et affichées dans les résultats finaux.
