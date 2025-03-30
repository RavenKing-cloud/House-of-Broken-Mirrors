
// === GET CONTROLS ===
getControls();

// === FREEZE LOGIC ===
if (global.freeze_player || is_dead) {
    previousRight = rightKey;
    previousLeft  = leftKey;
    previousUp    = upKey;
    previousDown  = downKey;
    return; // Skip entire movement/input block
}

// === INPUT DETECTION (fresh press only) ===
var rightPressed = rightKey && !previousRight;
var leftPressed  = leftKey  && !previousLeft;
var upPressed    = upKey    && !previousUp;
var downPressed  = downKey  && !previousDown;

// === EASE TOWARD TARGET POSITION ===
// Use lerp() to move towards target_x and target_y smoothly
var move_speed = 0.5; // Between 0 (no movement) and 1 (instant)
x = lerp(x, target_x, move_speed);
y = lerp(y, target_y, move_speed);

// Optional: Snap to target when very close to avoid jitter
if (point_distance(x, y, target_x, target_y) < 1) {
    x = target_x;
    y = target_y;
}

// === MOVEMENT CONTROL ===
if (x == target_x && y == target_y) {

    // Decrease buffer cooldown if active
    if (move_buffer > 0) {
        move_buffer--;
    }

    // Read one-frame directional input
    var h = (rightPressed ? 1 : 0) - (leftPressed ? 1 : 0);
    var v = (downPressed ? 1 : 0) - (upPressed ? 1 : 0);

    // Only allow one direction at a time
    if (h != 0) v = 0;

    // Store buffered input (last pressed direction)
    if (h != 0 || v != 0) {
        buffered_h = h;
        buffered_v = v;
    }

    if (move_buffer <= 0 && (buffered_h != 0 || buffered_v != 0)) {
        var new_x = x + buffered_h * tile_size;
        var new_y = y + buffered_v * tile_size;

        if (can_move_to(new_x, new_y)) {
            target_x = new_x;
            target_y = new_y;
			global.turn_count++;
			with oEnemy {
				buffered_h = other.buffered_h;
				buffered_v = other.buffered_v;
			}
            move_buffer = buffer_time;
        }

        buffered_h = 0;
        buffered_v = 0;
    }
}

// === UPDATE PREVIOUS KEY STATES ===
previousRight = rightKey;
previousLeft  = leftKey;
previousUp    = upKey;
previousDown  = downKey;

// Kill Box Trigger
if (!is_dead && place_meeting(x, y, oKillBox)) {
    is_dead = true;
    global.freeze_player = true;

    var wipe = instance_create_layer(x, y, layer_exists("Effects") ? "Effects" : layer_get_name(0), oDeathWipe);
    wipe.originator = id;
}


// ===================
// === CAMERA BOX CHECK ===
// ===================
if (!global.camTransitionActive) {
    var newCamBox = instance_position(x, y, oCamBox);

    if (newCamBox != noone && newCamBox != currentCamBox) {
        // Compute area overlap
        var overlap_left   = max(bbox_left, newCamBox.x);
        var overlap_top    = max(bbox_top, newCamBox.y);
        var overlap_right  = min(bbox_right, newCamBox.x + newCamBox.sprite_width);
        var overlap_bottom = min(bbox_bottom, newCamBox.y + newCamBox.sprite_height);
        var overlap_width  = max(0, overlap_right - overlap_left);
        var overlap_height = max(0, overlap_bottom - overlap_top);
        var overlap_area   = overlap_width * overlap_height;

        var player_area = (bbox_right - bbox_left) * (bbox_bottom - bbox_top);

        if (overlap_area > player_area * 0.5) {
            global.camTransitionActive = true;
            global.camTransitionTimer  = 0;
            global.targetCamBox        = newCamBox;
        }
    }
} else {
    global.camTransitionTimer++;

    if (global.camTransitionTimer >= global.camTransitionDuration) {
        currentCamBox = global.targetCamBox;
        global.camTransitionActive = false;
        global.camTransitionTimer = 0;
        global.targetCamBox = noone;
    }
}

// ===================
// === LAST CAM BOX TRACKER (FOR RESPAWN)
// ===================
var _box = instance_place(x, y, oCamBox);
if (_box != noone) {
    last_cam_box = _box;
    global.last_cam_box = _box;
}

// ===================
// === DEBUG MODE TOGGLE ===
// ===================
if (debugKey) {
    global.debug_mode = !global.debug_mode;
}


