# Guide de Configuration de la Caméra - Phase 1

## 📹 Où modifier la caméra ?

Le fichier principal pour la gestion de la caméra est:
**`components/RaceManager.tsx`**

## 🎥 Auto-Start de la Caméra

La caméra démarre **automatiquement** au clic sur le bouton "BEGIN RACE".

### Emplacement du code auto-start (lignes 149-179):
```typescript
// Auto-start camera when race begins
useEffect(() => {
  if (!raceStarted || !videoRef.current) return;

  const startCamera = async () => {
    try {
      console.log('[v0] Attempting to start camera');
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'user' },
        audio: false
      });
      // ... caméra démarre ici
    } catch (err) {
      console.log('[v0] Camera access denied or not available:', err);
      setCameraError(true);
    }
  };
  
  startCamera();
  
  return () => {
    // Arrête la caméra quand la course se termine
    if (videoRef.current?.srcObject) {
      const tracks = (videoRef.current.srcObject as MediaStream).getTracks();
      tracks.forEach((track) => track.stop());
    }
  };
}, [raceStarted]);
```

## 🔧 Comment Personnaliser la Caméra ?

### 1. Changer le type de caméra (facingMode)

**Ligne 160** - Changez `facingMode`:
- `'user'` = Caméra frontale (défaut, pour selfie)
- `'environment'` = Caméra arrière (pour capture d'environnement)

```typescript
video: { facingMode: 'environment' }  // Pour arrière
```

### 2. Ajouter la résolution de la caméra

Pour forcer une résolution spécifique, modifiez **ligne 159**:
```typescript
video: {
  facingMode: 'user',
  width: { ideal: 1280 },
  height: { ideal: 720 }
}
```

### 3. Changer le flux vidéo en flux externe (DroidCam, RTMP, etc.)

Pour utiliser **DroidCam** ou une source externe:

**Remplacez** la section auto-start (lignes 156-170) par:
```typescript
const startCamera = async () => {
  try {
    // Pour DroidCam sur localhost:4747
    if (videoRef.current) {
      videoRef.current.src = 'http://localhost:4747/video';
      videoRef.current.play();
      console.log('[v0] DroidCam connected');
    }
  } catch (err) {
    console.log('[v0] DroidCam connection failed:', err);
    setCameraError(true);
  }
};
```

**Pour DroidCam sur IP distante:**
```typescript
videoRef.current.src = 'http://192.168.1.100:4747/video';
```

### 4. Affichage de la Caméra (position et style)

L'élément vidéo se trouve **lignes 834-844** dans le JSX:
```typescript
<video
  ref={videoRef}
  autoPlay
  playsInline
  className="w-full h-full object-cover"
  onError={() => setCameraError(true)}
  style={{
    WebkitTransform: 'scaleX(-1)',  // Miroir horizontal
    transform: 'scaleX(-1)',
  }}
/>
```

**Personnalisations possibles:**
- Ajouter `muted` si vous ne voulez pas de son
- Retirer `scaleX(-1)` pour enlever l'effet miroir
- Changer `object-cover` par `object-contain` pour adapter à la zone

## 📍 Emplacements Clés dans RaceManager.tsx

| Ligne | Élément | Description |
|------|---------|-------------|
| 70 | `videoRef` | Référence React au vidéo |
| 149-179 | `useEffect` | Auto-start de la caméra |
| 658-667 | Toast Pénalité | Notification quand pénalité appliquée |
| 817-850 | Section caméra | Panneau caméra côté droit |
| 825-826 | Élément vidéo | Tag `<video>` avec ref |

## ✅ Feedback de Pénalités (Notification)

Quand une pénalité est appliquée, une notification apparaît en **haut à droite** pendant 2 secondes avec:
- Le nom de l'équipe
- Le type et montant de la pénalité (🚧 Barrière -20, ⛔ Signal -30, 🤚 Intervention -50)

**Code** (lignes 658-667):
```typescript
{penaltyFeedback && (
  <div className="fixed top-8 right-8 z-40 animate-pulse">
    <div className="border-4 border-red-500 bg-red-500/20 px-6 py-4 text-red-300 font-bold text-center">
      <div className="text-lg">{penaltyFeedback.team}</div>
      <div className="text-sm mt-1">✗ {penaltyFeedback.type}</div>
    </div>
  </div>
)}
```

## 🔌 Connexion DroidCam - Étapes

1. Téléchargez DroidCam sur votre téléphone
2. Lancez DroidCam et notez l'adresse IP et le port (ex: 192.168.1.100:4747)
3. Modifiez **ligne 160** pour pointer vers votre IP DroidCam
4. Cliquez sur "BEGIN RACE" - la caméra devrait démarrer automatiquement

## 📝 Notes

- La caméra s'arrête automatiquement quand la course se termine
- Si la caméra échoue, le message "Set DroidCam" s'affiche
- La notification de pénalité s'affiche pendant 2 secondes (modifiable ligne 407)
- Les pénalités sont sauvegardées dans la base de données globale
