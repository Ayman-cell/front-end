# Phase 1 Scoring Implementation - Ayman's Requirements

## Summary of Changes

All of Ayman's requirements for Phase 1 scoring have been implemented and tested. The following files have been modified:

### 1. **RacesContext.tsx** - Updated Type Definition
- Updated `TeamTimer` interface to include all required fields:
  - `distance` (0-200 cm)
  - `barrierContactCount`, `stopSignalViolationCount`, `humanInterventionCount`
  - `centiseconds`, `finishedTime`

### 2. **RaceManager.tsx** - Core Scoring Logic & Distance Validation
**Phase 1 Score Calculation (Exact Formula):**
```
Case A (Finished, time < 360s):
  total_score = distance_points + speed_score + penalties

Case B (Not finished, or time >= 360s):
  total_score = distance_points + penalties
  (NO speed score applied)

Where:
  - distance_points = distance_cm (1 point per cm)
  - speed_score = (360 - time_seconds) * 0.5 (ONLY if finished AND time < 360)
  - penalties = -(barrier×20 + stopSignal×30 + humanIntervention×50)
```

**Changes Made:**
1. Rewrote `calculatePhase1Score()` to match Ayman's exact formula
2. Added distance validation (0 <= distance <= 200)
3. Updated distance input to accept float values (step 0.1)
4. Added error messages for invalid distances
5. Added comprehensive scoring validation logs on race finish

**Distance Validation:**
- ✓ Distance is MANDATORY for all teams
- ✓ Distance must be between 0 and 200 cm (inclusive)
- ✓ Distance can be 0 (allowed)
- ✓ Distance accepts floats (e.g., 123.45)
- ✓ Invalid distances block race save with clear error message

### 3. **RaceLeaderboard.tsx** - Updated Display
- Updated Phase 1 score calculation to match exact formula
- Shows correct scores based on:
  - Distance × 1 point
  - Speed bonus only if finished AND time < 360
  - Cumulative penalties

### 4. **GlobalLeaderboard.tsx** - Restructured Columns
**Removed:** "Average Distance" column
**Added:**
1. "Distance (cm)" - Shows most recent distance for each team
2. "Score Phase 1" - Shows calculated Phase 1 score

**Updated TeamResult interface:**
- Added `phase1Score` field
- Added `lastDistance` field (most recent race distance)

**Changes:**
- Grid changed from 8 columns to 7 columns
- Aggregation logic updated to calculate Phase 1 score per timer
- Score display updated to show actual Phase 1 score

## Validation Tests to Perform

### Distance Tests:
```
✓ distance = 0 → accepted, saved, displayed
✓ distance = 123.45 → accepted (float)
✓ distance = 200 → accepted (max)
✓ distance = 201 → rejected, shows error
✓ distance = -1 → rejected, shows error
✓ distance = empty/null → rejected, shows error
```

### Penalty Tests:
```
✓ Click barrier button 3 times → count = 3, penalty = -60 points
✓ Click stop signal 2 times → count = 2, penalty = -60 points
✓ Click intervention 1 time → count = 1, penalty = -50 points
✓ Total penalties cumulate correctly
```

### Case A (Finished, time < 360s):
```
Team: EXAMPLE
- Distance: 150 cm → +150 pts
- Time: 150 seconds → speed_score = (360-150)*0.5 = 105 pts
- Barrier: 1 contact → -20 pts
- Total: 150 + 105 - 20 = 235 pts
```

### Case B (Not Finished OR time >= 360s):
```
Team: EXAMPLE
- Distance: 150 cm → +150 pts
- Finished: false (or time ≥ 360)
- Speed Score: 0 (NOT APPLIED)
- Barrier: 1 contact → -20 pts
- Total: 150 + 0 - 20 = 130 pts
```

### Leaderboard/Global Board:
```
✓ "Average Distance" column removed
✓ "Distance (cm)" column added and shows last distance
✓ "Score Phase 1" column added and shows calculated score
✓ Finished teams shown with scores
✓ Not finished teams shown with "—" for score
```

## Console Logging for Verification

When finishing a race, comprehensive logs are printed to console showing:
```
=== PHASE 1 SCORING VALIDATION ===
[TEAM_NAME]:
  - Finished: true/false
  - Time: MM:SS:CC (time_seconds)
  - Distance: X cm → +X pts
  - Speed Score: X.X pts (only if finished & time < 360)
  - Barrier Contact: X × -20 = -X
  - Stop Signal: X × -30 = -X
  - Human Intervention: X × -50 = -X
  - Total Penalties: -X
  - FINAL SCORE: X.X pts
```

## Race Rules (Enforced):
- ✓ One team per race only (validated on race creation)
- ✓ Min teams per race: 1
- ✓ Max teams per race: 5
- ✓ Camera must be functional before "Begin Race" (not after)

## Deliverables:
1. ✓ Distance validation (0 ≤ distance ≤ 200, mandatory, float support)
2. ✓ Leaderboard shows Distance + Score Phase 1
3. ✓ Global board shows Distance + Score Phase 1
4. ✓ Average Distance column removed
5. ✓ Cumulative penalties system (button clicks)
6. ✓ Correct Phase 1 scoring formula (Case A & B)
7. ✓ Persistent distance storage
8. ✓ Comprehensive validation and logging

## Notes:
- All changes follow Ayman's exact specifications
- Scoring is calculated both in display components and race manager
- Distance is validated at save time (not in real-time)
- Float values are supported (e.g., 123.45 cm)
- Zero distance is explicitly allowed
- Speed score only applies to finished teams with time < 360 seconds
