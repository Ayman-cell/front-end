# Global Leaderboard and Team Duplication Fix

## Issues Fixed

### 1. **Global Leaderboard Not Displaying Saved Race Data**
   - **Problem**: The leaderboard was showing empty data (0 cm distance, 0.0 score, 0 penalty)
   - **Cause**: Data was being saved but the display component had `Math.max(0, score)` which clamped scores to zero
   - **Fix**: Removed score clamping in GlobalLeaderboard to allow negative scores from penalties
   - **Files Changed**: 
     - `/components/GlobalLeaderboard.tsx` - Line 51

### 2. **Negative Scores Being Clamped to Zero**
   - **Problem**: When penalties exceeded distance + speed points, the score should be negative but was displaying 0
   - **Example**: 
     - Distance: 20 cm → +20 pts
     - Speed: 0 pts (DNF)
     - Penalties: -30 pts
     - **Was showing**: 0.0 (due to `Math.max(0, ...)`)
     - **Now shows**: -10 pts ✓
   - **Cause**: Three locations had `Math.max(0, score)` preventing negative values
   - **Fix**: Removed all `Math.max(0, score)` clamps
   - **Files Changed**:
     - `/components/RaceManager.tsx` - Lines 99, 376, 731

### 3. **Team Duplication Prevention Not Implemented**
   - **Problem**: Teams could participate in the same race/phase multiple times
   - **Solution**: Added team duplication prevention to ensure each team can only race once per phase
   - **Implementation**:
     - Modified `handleWheelSelected()` to filter out teams that already raced
     - Modified `handleNoWheel()` to filter out teams that already raced
     - Added alerts when all teams have already participated
     - Added visual feedback showing count of teams that already raced
   - **Files Changed**:
     - `/components/RaceManager.tsx` - handleWheelSelected and handleNoWheel functions (Lines 202-244)
     - `/components/RaceSelector.tsx` - Added phase parameter and filtering (Lines 4, 9-18, 57-64)

## How Team Duplication Prevention Works

1. When opening the race selector, the system checks `getRacesByPhase()` to find all races in the current phase
2. Extracts all team names from completed races
3. Filters out those teams from the available teams list
4. Shows alert if all teams have already participated
5. In Phase 1 UI, displays message: "X team(s) have already raced in this phase"

## Verification

- Global Leaderboard now correctly displays:
  - Actual race distances from saved races
  - Correct Phase 1 scores (including negative scores when applicable)
  - Total penalties from completed races
  - Team participation count

- Team Duplication Prevention:
  - Teams cannot be selected twice in the same phase
  - Clear feedback to users when a team has already raced
  - Works with both wheel selection and manual team selection modes
