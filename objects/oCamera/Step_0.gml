// --- Camera Step Event ---
// Exit if the player instance does not exist.
if (!instance_exists(oPlayer)) exit;

// Retrieve the camera's dimensions.
var _camWidth  = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

// Calculate the desired camera position centered on the player.
var _camX = oPlayer.x - _camWidth * 0.5;
var _camY = oPlayer.y - _camHeight * 0.5;

// Determine boundaries for clamping.
if (global.camTransitionActive) {
    // Compute interpolation factor (t) linearly from 0 to 1.
    var t = global.camTransitionTimer / global.camTransitionDuration;
    
    // Retrieve boundaries from the current (old) camBox.
    var oldLeft, oldTop, oldRight, oldBottom;
    if (oPlayer.currentCamBox != noone) {
        oldLeft   = oPlayer.currentCamBox.x;
        oldTop    = oPlayer.currentCamBox.y;
        oldRight  = oPlayer.currentCamBox.x + oPlayer.currentCamBox.sprite_width;
        oldBottom = oPlayer.currentCamBox.y + oPlayer.currentCamBox.sprite_height;
    } else {
        oldLeft   = 0;
        oldTop    = 0;
        oldRight  = room_width;
        oldBottom = room_height;
    }
    
    // Retrieve boundaries from the target (new) camBox.
    var newLeft   = global.targetCamBox.x;
    var newTop    = global.targetCamBox.y;
    var newRight  = global.targetCamBox.x + global.targetCamBox.sprite_width;
    var newBottom = global.targetCamBox.y + global.targetCamBox.sprite_height;
    
    // Linearly interpolate between the old and new boundaries.
    var leftBound   = lerp(oldLeft, newLeft, t);
    var topBound    = lerp(oldTop, newTop, t);
    var rightBound  = lerp(oldRight, newRight, t);
    var bottomBound = lerp(oldBottom, newBottom, t);
    
    // Clamp the target camera position within the interpolated boundaries.
    _camX = clamp(_camX, leftBound, rightBound - _camWidth);
    _camY = clamp(_camY, topBound, bottomBound - _camHeight);
    
    // Update transition timer.
    global.camTransitionTimer++;
} else {
    // Normal operation: clamp to the current camBox boundaries or full room bounds.
    var leftBound, topBound, rightBound, bottomBound;
    if (oPlayer.currentCamBox != noone) {
        leftBound   = oPlayer.currentCamBox.x;
        topBound    = oPlayer.currentCamBox.y;
        rightBound  = oPlayer.currentCamBox.x + oPlayer.currentCamBox.sprite_width;
        bottomBound = oPlayer.currentCamBox.y + oPlayer.currentCamBox.sprite_height;
    } else {
        leftBound   = 0;
        topBound    = 0;
        rightBound  = room_width;
        bottomBound = room_height;
    }
    
    _camX = clamp(_camX, leftBound, rightBound - _camWidth);
    _camY = clamp(_camY, topBound, bottomBound - _camHeight);
}

// Smoothly interpolate the final camera position using a trailing effect.
finalCamX += (_camX - finalCamX) * camTrailSpd;
finalCamY += (_camY - finalCamY) * camTrailSpd;
camera_set_view_pos(view_camera[0], finalCamX, finalCamY);
