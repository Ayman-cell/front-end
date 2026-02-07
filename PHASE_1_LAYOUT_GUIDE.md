# Phase 1 - New Layout Guide

## Overview
La Phase 1 a été restructurée pour offrir un meilleur espace pour la caméra lors du déroulement de la course.

## Layout Structure

### Left Panel (30% - 384px)
**Fonction**: Panneau de contrôle compact avec tous les contrôles de l'équipe

**Contient**:
- **BEGIN/FINISH RACE**: Boutons pour démarrer/arrêter la course
- **TIME LIMIT**: Affichage du temps restant (6 minutes max)
- **Teams List**: Liste verticale de toutes les équipes (max 5) avec:
  - Numéro et nom de l'équipe
  - Temps écoulé (MM:SS:CC)
  - Status (✓ DONE ou ✗ TIME OVER)
  - Champ saisie distance (cm)
  - 3 boutons pénalités compacts: 🚧 ⛔ 🤚
  - Boutons STOP et SAVE

**Features**:
- Scroll vertical automatique si nécessaire
- Toutes les informations et contrôles sont accessibles en un coup d'œil
- Design compact pour gagner de l'espace

### Right Panel (70% - Reste)
**Fonction**: Grand espace dédié à la caméra/flux vidéo DroidCam

**Contient**:
- Header "CAMERA FEED"
- Zone vidéo grande (flex-1)
- Affichage "Set DroidCam" si caméra non disponible

**Features**:
- Espace maximisé pour voir la course
- Support natif du flux vidéo
- Message d'aide pour DroidCam

## Système de Notation Phase 1 (Inchangé)

**Distance**: 1 point par cm (max 200 pts)
**Vitesse**: 0.5 points/seconde d'avance
**Pénalités**:
- 🚧 Contact Barrière: -20 pts
- ⛔ Mouvement Signal Arrêt: -30 pts
- 🤚 Intervention Humaine: -50 pts

## Fonctionnalités Conservées

✅ Tous les timers et contrôles existants
✅ Système de notation Phase 1 complet
✅ Saisie distance et pénalités
✅ Sauvegarde automatique des résultats
✅ Modal de confirmation de fin
✅ Historique des courses

## Notes Importantes

- Le layout s'adapte automatiquement à l'écran
- Max 5 équipes supportées
- Scroll vertical du panneau gauche si besoin
- Caméra en plein écran à droite
- Aucune fonctionnalité supprimée, seulement réorganisée
