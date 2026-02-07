# Camera Fix and Debugging Guide

## Changes Made

I've fixed the camera implementation in both RaceManager and RaceDisplay components to ensure proper functionality.

### 1. **RaceManager Camera Fix**

**Problem**: Camera was using `facingMode: 'user'` (front camera) which is incorrect for a race track. Also had inadequate error logging.

**Solution**:
- Changed to `facingMode: { ideal: 'environment' }` for rear/top-mounted cameras
- Added resolution constraints (1280x720)
- Enhanced error logging to diagnose issues
- Proper cleanup of camera tracks
- Added `muted` attribute to video element

```javascript
// Before (WRONG)
navigator.mediaDevices.getUserMedia({
  video: { facingMode: 'user' },
  audio: false
});

// After (CORRECT)
navigator.mediaDevices.getUserMedia({
  video: {
    facingMode: { ideal: 'environment' },
    width: { ideal: 1280 },
    height: { ideal: 720 }
  },
  audio: false
});
```

### 2. **RaceDisplay Camera Fix**

Added missing camera initialization logic that was absent in the component.

**Changes**:
- Added `useRef` hook for video element reference
- Added `useEffect` to initialize getUserMedia on mount
- Added proper error handling and cleanup
- Properly sets the media stream to the video element

### 3. **Video Element Improvements**

Both components now have:
- `ref={videoRef}` - Reference to control the video element
- `autoPlay` - Start playing immediately
- `playsInline` - Play without fullscreen
- `muted` - Required for autoplay to work
- Proper error callback with logging
- Horizontal flip transform for front cameras

## How to Test the Camera

### Test 1: Check Browser Console
When you navigate to a race page, check the browser console (F12):
- Should see: `[v0] Attempting to start camera`
- Should see: `[v0] Camera stream started successfully`
- Should see: `[v0] Video tracks: 1`

If you see errors, they will be logged as:
- `[v0] Camera error: [Error details]`

### Test 2: Check Browser Permissions
1. Open your browser's site settings (usually in the address bar)
2. Look for "Camera" permission
3. It should be set to "Allow" for this site
4. If it says "Block", click it and change to "Allow"

### Test 3: Verify Camera Hardware
- Ensure a camera is physically connected (USB camera or built-in webcam)
- Try another application (like Google Meet or Zoom) to verify camera works
- Some cameras need drivers to be installed

### Test 4: Test Camera Fallback
- DroidCam (IP camera app) works as fallback
- Connect your phone as a camera source if hardware camera unavailable

## Common Issues and Solutions

### Issue 1: "Set DroidCam or connect USB camera"
**Cause**: No camera stream initialized
**Solution**:
1. Check browser console for error message
2. Verify camera is connected
3. Allow camera permission in browser
4. Check camera is not in use by another application

### Issue 2: Black screen in camera feed
**Cause**: Camera not streaming properly
**Solution**:
1. Check console for `[v0] Camera stream started successfully`
2. Verify video element has `srcObject` set
3. Try reloading the page
4. Try disconnecting/reconnecting camera

### Issue 3: Wrong camera orientation
**Cause**: Using wrong facingMode
**Solution**: The code now defaults to 'environment' which is correct for external cameras

### Issue 4: Permission denied error
**Cause**: Browser blocked camera access
**Solution**:
1. Click the permission icon in address bar
2. Change Camera to "Allow"
3. Reload the page

## Logging Output

The camera initialization now logs:
- `[v0] Attempting to start camera` - Process started
- `[v0] Camera stream started successfully` - Stream active
- `[v0] Video tracks: X` - Number of camera tracks
- `[v0] Stopping X camera tracks` - Cleanup on unmount
- `[v0] Camera error: [Error]` - Any errors encountered
- `[v0] Error type: [Type]` - Type of error for debugging

## Browser Compatibility

Camera works in:
- Chrome/Chromium (all versions)
- Firefox (all versions)
- Safari (iOS 11+, macOS Catalina+)
- Edge (all versions)

Requires HTTPS or localhost (security requirement).

## Files Modified

1. `/components/RaceManager.tsx` - Main camera implementation for races
2. `/components/RaceDisplay.tsx` - Secondary camera display (RaceDisplay component)
