# Système de Wheels et Races - Guide de Vérification

## Vue d'ensemble du système

Ce système permet de:
1. Créer des wheels (ordres de passages d'équipes) via la roulette
2. Sauvegarder ces wheels avec historique
3. Gérer les races en sélectionnant un wheel existant pour ordonner les équipes

---

## Étape 1: Créer un Wheel (Roulette)

**Accès:** Menu principal → ROULETTE

### Processus:
1. ✅ Ajouter des équipes (teams page)
2. ✅ Aller à ROULETTE
3. ✅ Configurer les équipes à la roulette
4. ✅ Lancer chaque spin (SPIN button)
5. ✅ L'ordre des équipes sélectionnées s'affiche à droite (SELECTED)
6. ✅ Quand une équipe est sélectionnée, elle est retirée de la roulette
7. **AUTO:** Quand il reste 1 équipe, elle est automatiquement ajoutée aux résultats
8. ✅ Cliquer SAVE pour sauvegarder le classement dans l'historique des wheels

**Résultat:** Un nouveau wheel avec la date et l'ordre est sauvegardé

---

## Étape 2: Consulter l'Historique des Wheels

**Accès:** Phase 1 → Bouton WHEELS (jaune) en haut à droite

### Processus:
1. ✅ Le bouton WHEELS n'apparaît que s'il y a au moins 1 wheel sauvegardé
2. ✅ Affiche tous les wheels avec:
   - Date/heure de création
   - Ordre des équipes (Team1 → Team2 → Team3...)
3. ✅ Chaque wheel peut être supprimé avec le bouton DELETE (rouge)

**Important:** Supprimer un wheel le retire complètement de l'historique

---

## Étape 3: Créer une Race avec un Wheel Spécifique

**Accès:** Phase 1 → Bouton ADD RACE

### Processus détaillé:

#### Étape 3A: Sélectionner le Wheel
1. Cliquer ADD RACE
2. **Nouveau modal:** "SELECT WHEEL" apparaît
3. Options:
   - Cliquer sur un wheel existant → sélectionne cet ordre
   - Cliquer "USE ALL TEAMS" → utilise toutes les équipes sans ordre spécifique
   - Cliquer "CANCEL" → annule et ferme le modal

#### Étape 3B: Sélectionner les Équipes
1. Le modal "SELECT TEAMS" apparaît
2. **Les équipes sont dans l'ordre du wheel choisi**
3. ✅ **Chaque équipe affiche son numéro du wheel** (coin supérieur droit)
   - Exemple: "#1" pour la première du wheel, "#2" pour la deuxième, etc.
4. Cliquer sur les équipes pour les sélectionner (max 5)
5. Les équipes sélectionnées se surlignent (cyan-300 / cyan-400)
6. Boutons:
   - START → Lance la race avec les équipes sélectionnées
   - BACK → Revenir au modal de sélection du wheel
   - Affiche "X/5 teams selected"

#### Étape 3C: Race
1. Cliquer BEGIN pour lancer les timers
2. Chaque équipe a son timer indépendant
3. Les équipes s'affichent dans l'ordre du wheel
4. Cliquer STOP pour arrêter une équipe
5. Cliquer FINISH PHASE 1 pour sauvegarder la race

---

## Points Clés à Vérifier

### ✅ Roulette (Wheel Creation)
- [ ] Quand il reste 1 équipe, elle s'ajoute automatiquement
- [ ] Le bouton SAVE apparaît quand toutes les équipes sont utilisées
- [ ] Le message "Wheel saved to history!" s'affiche

### ✅ Historique (Wheel History)
- [ ] Le bouton WHEELS n'apparaît que si wheelHistory.length > 0
- [ ] Chaque wheel affiche: date + liste ordonnée des équipes
- [ ] DELETE supprime complètement un wheel

### ✅ Race avec Wheel (Critical)
- [ ] ADD RACE → modal SELECT WHEEL apparaît
- [ ] Sélectionner un wheel → teams ordonnées dans cet ordre
- [ ] Les nombres (#1, #2, #3) s'affichent quand un wheel est choisi
- [ ] USE ALL TEAMS → pas de numéros, ordre normal
- [ ] BACK → retour au modal SELECT WHEEL
- [ ] Les équipes sélectionnées gardent leur ordre du wheel
- [ ] Race s'exécute avec l'ordre correct

### ✅ Intégration Data
- [ ] wheelHistory sauvegardé dans localStorage
- [ ] orderTeams non visible dans le contexte de races
- [ ] Wheel date formatée correctement
- [ ] Suppressions de wheels persistent après rechargement

---

## Fichiers Modifiés

1. **TeamsContext.tsx** - Ajout de wheelHistory et gestion
2. **RaceManager.tsx** - Modal de sélection du wheel + ordonnancement
3. **WheelHistory.tsx** - Affichage et suppression des wheels
4. **app/roulette/page.tsx** - Auto-ajout de dernière équipe + Save
5. **app/phase-1/page.tsx** - Bouton WHEELS et modal

---

## État du Système

Tous les composants sont intégrés et testables. Le flux complet fonctionne comme suit:

```
1. Teams → 2. Roulette (créer wheel) → 3. Save wheel
   ↓
4. Phase 1 → 5. ADD RACE → 6. SELECT WHEEL → 7. SELECT TEAMS (ordonnées) → 8. RACE
   ↓
9. Consulter wheels via bouton WHEELS
   ↓
10. Supprimer wheels si nécessaire
```
