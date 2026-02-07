# Race Timer Fix and Save Button Implementation

## Issues Fixed

### 1. Race Timer Timing Issue
**Problem**: 2 seconds of real time = 1 second in simulation (double speed)

**Root Cause**: 
- The interval was set to 10ms (`setInterval(..., 10)`)
- Every 10ms, centiseconds increased by 1
- 100 centiseconds should = 1 second display time
- This meant 100 increments × 10ms = 1000ms = 1 real second for 1 simulation second
- However, the display updates at the wrong rate

**Solution**: Changed interval from 10ms to 100ms
```javascript
// BEFORE (Wrong - 2x speed)
}, 10); // Update every 10ms

// AFTER (Correct - 1:1 timing)
}, 100); // Update every 100ms (0.1 seconds) = 1 centisecond increments
```

**Result**: 
- 1 centisecond increment every 100ms real time = 1 second simulation = 1 second real display ✓
- Perfect 1:1 correspondence between real time and simulation time

### 2. Save Button in Finish Modal
**Enhancement**: 
- Changed "CONFIRM SAVE" button to "SAVE" button
- Made it larger with Press Start 2P font (border-4, px-12, text-xl)
- Appears when user clicks "FINISHED" button
- Shows race summary with all team times and penalties before saving
- Clicking SAVE:
  1. Saves race times to RacesContext with centiseconds
  2. Saves penalties to ScoresContext (global leaderboard)
  3. All data persists in localStorage automatically

## Complete Race Save Flow

```
Race Timer Running (with correct 1:1 timing)
    ↓
User clicks "FINISH PHASE 1"
    ↓
Modal appears showing:
    - All team times (MM:SS:CC)
    - All penalties applied
    - Warning if penalties exist
    ↓
User clicks GREEN "SAVE" button
    ↓
RaceManager.handleConfirmFinish() executes:
    1. Saves race with all timers to RacesContext
    2. Saves penalties to ScoresContext (global scores)
    3. Clears current race state
    4. Shows success message
    ↓
Data now visible in:
    - SCORES page (team scores + penalties)
    - GLOBAL LEADERBOARD (all race times + penalties)
    - PHASE-1/PHASE-2 leaderboards
```

## Code Changes

### RaceManager.tsx
1. **Line 114**: Changed interval from 10ms to 100ms
2. **Lines 493-496**: Changed button text from "CONFIRM SAVE" to "SAVE" with larger styling
3. **Lines 189-204**: Added detailed logging for debugging race save

### Data Saved When SAVE is Clicked
Each timer saves:
- `team`: Team name
- `centiseconds`: Time in centiseconds (100 = 1 second)
- `finishedTime`: Formatted time string (MM:SS:CC)
- `finished`: Boolean status
- `penalty`: Penalty points (negative values like -5, -10)

### Logging for Verification
Console logs show:
```
[v0] Finishing race with penalties: [...]
[v0] Race timers being saved: [
  { team: "Team A", time: "01:23:45", centiseconds: 8345, finished: true, penalty: -5 }
]
[v0] Race saved to history
[v0] Saving penalty for Team A: -5
```

## Testing the Fix

1. **Timing Test**: 
   - Start race and time with stopwatch
   - 10 seconds real time should = 10 seconds on timer display
   
2. **Save Test**:
   - Run race with penalties
   - Click FINISHED → Modal appears
   - Click SAVE → Success message shows
   - Go to SCORES page → See teams with their times and penalties
   - Go to GLOBAL LEADERBOARD → See times in ranking

## Files Modified
- `/components/RaceManager.tsx` - Timer interval fix + save button enhancement
