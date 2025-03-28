// --- Room Start Event ---
// Exit if no player instance exists.
if (!instance_exists(oPlayer)) exit;

// Retrieve the camera's dimensions.
var _camWidth  = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);

// Calculate the desired camera position centered on the player.
var _camX = oPlayer.x - _camWidth * 0.5;
var _camY = oPlayer.y - _camHeight * 0.5;

// Determine the camBox under the player.
var startingBox = instance_position(oPlayer.x, oPlayer.y, oCamBox);

// Set the player's current camBox (if one exists) or default to room bounds.
if (startingBox != noone) {
    oPlayer.currentCamBox = startingBox;
    // Snap the camera directly to the starting camBox boundaries.
    _camX = clamp(_camX, startingBox.x, startingBox.x + startingBox.sprite_width - _camWidth);
    _camY = clamp(_camY, startingBox.y, startingBox.y + startingBox.sprite_height - _camHeight);
} else {
    oPlayer.currentCamBox = noone;
    _camX = clamp(_camX, 0, room_width - _camWidth);
    _camY = clamp(_camY, 0, room_height - _camHeight);
}

// Initialize the final camera coordinates.
finalCamX = _camX;
finalCamY = _camY;
camera_set_view_pos(view_camera[0], finalCamX, finalCamY);

// Ensure no transition is active on room load.
global.camTransitionActive = false;
global.camTransitionTimer  = 0;
global.targetCamBox        = noone;
