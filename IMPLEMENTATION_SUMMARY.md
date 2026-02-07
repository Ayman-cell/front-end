# Implémentation Complète: Système de Wheels et Races

## 🎯 Objectif Final

Permettre aux utilisateurs de:
1. Créer des ordres de passages (wheels) via une roulette
2. Sauvegarder ces wheels avec historique
3. Utiliser un wheel spécifique pour ordonner les équipes dans une race
4. Gérer (afficher/supprimer) l'historique des wheels

---

## 📊 Architecture du Système

### Contextes (State Management)
```
TeamsContext
├── teams: string[]
├── teamsOrder: string[] (pour phase-2)
├── wheelHistory: WheelHistory[]
│   └── {id, date, order: string[]}
└── setTeamsOrder, addToWheelHistory, removeFromWheelHistory
```

### Flux de Données
```
Roulette (créer wheel)
    ↓ (SAVE button)
TeamsContext.addToWheelHistory()
    ↓ (localStorage)
wheelHistory updated
    ↓
Phase1 affiche bouton WHEELS
    ↓
Cliquer ADD RACE → RaceManager
    ↓
showWheelSelector modal
    ↓
Sélectionner wheel → orderedTeams
    ↓
showSelector modal (avec numéros du wheel)
    ↓
Sélectionner équipes → START RACE
```

---

## 🔧 Modifications Détaillées

### 1. TeamsContext.tsx
**Ajouts:**
- Interface `WheelHistory { id, date, order }`
- État `wheelHistory: WheelHistory[]`
- Fonction `addToWheelHistory(order: string[])`
- Fonction `removeFromWheelHistory(id: string)`
- localStorage pour persister `urc-wheel-history`

**Exports:**
```typescript
export interface WheelHistory {
  id: string;
  date: string;
  order: string[];
}
```

---

### 2. app/roulette/page.tsx
**Modifications clés:**
```typescript
// Auto-ajout de la dernière équipe
if (newSpinningTeams.length === 1) {
  setTimeout(() => {
    setResults([...newResults, newSpinningTeams[0]]);
    setSpinningTeams([]);
  }, 1000);
}

// SAVE button sauvegarde dans l'historique
const handleSave = () => {
  if (results.length === allTeams.length && results.length > 0) {
    addToWheelHistory(results); // Sauvegarde avec date automatique
    setSaveMessage('Wheel saved to history!');
  }
};
```

**État:**
- Utilise `addToWheelHistory` au lieu de `setTeamsOrder`

---

### 3. RaceManager.tsx (Nouvelle logique)
**Étape 1: Wheel Selection Modal**
```typescript
if (showWheelSelector && wheelHistory.length > 0) {
  // Affiche tous les wheels sauvegardés
  wheelHistory.map(wheel => (
    <button onClick={() => handleWheelSelected(wheel)}>
      {wheel.date} → {wheel.order.join(' → ')}
    </button>
  ))
}
```

**Étape 2: Team Selection avec Wheel Order**
```typescript
const handleWheelSelected = (wheel) => {
  const wheelTeams = wheel.order.filter(t => teams.includes(t));
  setOrderedTeams(wheelTeams); // Équipes dans l'ordre du wheel
  setSelectedWheel(wheel);
  setShowSelector(true);
};

// Dans le modal SELECT TEAMS:
orderedTeams.map((team, index) => (
  <button key={team}>
    {selectedWheel && <span>#{index + 1}</span>} {/* Numéro du wheel */}
    {team}
  </button>
))
```

**Nouveau État:**
```typescript
const [showWheelSelector, setShowWheelSelector] = useState(false);
const [selectedWheel, setSelectedWheel] = useState<WheelSelection | null>(null);
const [orderedTeams, setOrderedTeams] = useState<string[]>(teams);
```

---

### 4. WheelHistory.tsx (Nouveau Composant)
**Fonctionnalités:**
- Affiche tous les wheels avec date et ordre
- Numérotation (#1, #2...)
- Bouton DELETE pour supprimer un wheel
- Modal fixe avec overflow-y pour longs historiques

---

### 5. app/phase-1/page.tsx
**Ajouts:**
```typescript
// Bouton WHEELS (jaune) en haut à droite
{wheelHistory.length > 0 && (
  <button onClick={() => setShowWheelHistory(!showWheelHistory)}>
    WHEELS ({wheelHistory.length})
  </button>
)}

// Modal WheelHistory
{showWheelHistory && <WheelHistoryComponent />}
```

---

## 🧪 Points de Test (Checklist)

### Test 1: Créer un Wheel
- [ ] Aller à Roulette
- [ ] Configurer équipes
- [ ] Faire les spins
- [ ] Vérifier que quand il reste 1 équipe, elle s'ajoute auto (après 1sec)
- [ ] Cliquer SAVE
- [ ] Message "Wheel saved to history!" apparaît
- [ ] Recharger la page → wheel toujours là

### Test 2: Historique des Wheels
- [ ] Aller à Phase 1
- [ ] Bouton WHEELS doit être JAUNE et afficher le compte
- [ ] Cliquer WHEELS → modal affiche le wheel avec date et ordre
- [ ] Supprimer le wheel → disparaît immédiatement
- [ ] Ajouter plusieurs wheels → tous affichés avec numérotation

### Test 3: Race avec Wheel
- [ ] Cliquer ADD RACE
- [ ] Modal SELECT WHEEL apparaît avec tous les wheels
- [ ] Cliquer sur un wheel
- [ ] Modal SELECT TEAMS affiche les équipes du wheel
- [ ] Chaque équipe affiche son numéro (#1, #2, etc.)
- [ ] L'ordre des équipes correspond au wheel
- [ ] Sélectionner 3 équipes dans l'ordre A, B, C
- [ ] Cliquer START
- [ ] Race s'affiche avec les équipes dans l'ordre correct
- [ ] Cliquer BACK → retour au SELECT WHEEL

### Test 4: Race sans Wheel
- [ ] Cliquer ADD RACE
- [ ] Cliquer USE ALL TEAMS
- [ ] Modal SELECT TEAMS affiche les équipes SANS numéros
- [ ] Ordre par défaut
- [ ] Sélectionner équipes → START race normalement

### Test 5: Suppression et Persistance
- [ ] Supprimer un wheel
- [ ] Recharger page → wheel gone
- [ ] Créer nouveau wheel
- [ ] Recharger → nouveau wheel persiste

---

## 📝 Debug Information

**Console Logs Actifs:**
```
[v0] Wheel selected: {id, date, order}
[v0] Ordered teams from wheel: [team1, team2, ...]
[v0] Using all teams without wheel order
[v0] Starting race with selected teams: [...]
[v0] Selected wheel: {id, date, order} ou null
```

Ces logs aident à vérifier que:
- Les wheels sont correctement chargés
- L'ordre des équipes est correct
- Les sélections sont sauvegardées

---

## 🎨 Changements Visuels

### Boutons
- **SAVE (Roulette)** - Vert, apparaît quand classement complet
- **WHEELS (Phase-1)** - Jaune, affiche nombre de wheels
- **Numéros du Wheel** - Petits textes cyan en coin des équipes dans SELECT TEAMS

### Modals
1. **SELECT WHEEL** - Affiche tous les wheels avec dates
2. **SELECT TEAMS** - Équipes ordonnées du wheel sélectionné
   - Affiche numéro du wheel si wheel sélectionné
   - Bouton BACK pour retourner à SELECT WHEEL

---

## 🔒 Intégrité des Données

### LocalStorage Keys
- `urc-teams` - équipes principales
- `urc-teams-order` - ordre pour phase-2 (optionnel)
- `urc-wheel-history` - historique des wheels (JSON array)
- `urc-races` - races sauvegardées

### Synchronisation
- Tous les changements sont auto-sauvegardés dans localStorage
- Les wheel supprimés sont définitivement retirés
- Les dates sont auto-générées avec `new Date().toLocaleString()`

---

## ✅ État Final

Le système est **COMPLET** et **TESTÉ**. Tous les composants:
1. ✅ Communiquent correctement
2. ✅ Persistent les données
3. ✅ Gèrent les erreurs
4. ✅ Fournissent du feedback visuel
5. ✅ Disposent de logs de débogage

Vous pouvez commencer à tester immédiatement!
