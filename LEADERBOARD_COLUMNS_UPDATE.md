# Leaderboard Columns Update

## Summary
Updated the GlobalLeaderboard component to display the correct columns as requested by Ayman.

## Changes Made

### GlobalLeaderboard Table Columns (Updated)
**Before:**
1. TEAM
2. BEST TIME
3. AVG TIME
4. RACES
5. DISTANCE (cm)
6. SCORE PHASE 1

**After:**
1. TEAM
2. TIME (renamed from "BEST TIME")
3. RACES
4. DISTANCE (cm)
5. SCORE PHASE 1
6. PENALTY (new column)

### Key Updates

1. **Column Header Changes**
   - Changed "BEST TIME" to "TIME"
   - Removed "AVG TIME" column entirely
   - Added "PENALTY" column at the end

2. **Grid Layout**
   - Still maintains 7-column grid structure (TEAM + 6 data columns)
   - TEAM column spans 2 columns
   - Each other column occupies 1 column

3. **Penalty Column Display**
   - Shows the penalty value (negative number) in orange text
   - Shows "0" if no penalty applied
   - Color coding: orange-400 for penalties, cyan-600 for no penalties

4. **Data Used**
   - TIME: Shows `result.bestTimeFormatted` (best finished time)
   - RACES: Shows `result.count` (number of races completed)
   - DISTANCE: Shows `result.lastDistance` (most recent distance recorded)
   - SCORE PHASE 1: Shows `result.phase1Score` (calculated Phase 1 score)
   - PENALTY: Shows `result.totalPenalties` (aggregate penalty points)

## RaceLeaderboard
The RaceLeaderboard component displays individual race details and already shows:
- Time
- Distance
- Score
- Penalties (displayed below when present)

No changes were needed there as it already displays the required information in detail view format.

## Files Modified
- `/components/GlobalLeaderboard.tsx` - Updated header and data rows
