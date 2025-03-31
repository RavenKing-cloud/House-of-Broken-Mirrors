// === GET CONTROLS ===
getControls();

// === FREEZE LOGIC ===
if (global.freeze_player || is_dead) {
    previousRight = rightKey;
    previousLeft  = leftKey;
    previousUp    = upKey;
    previousDown  = downKey;
    global.player_just_moved = false;
    return;
}

// === RESET PLAYER MOVEMENT SIGNAL ===
global.player_just_moved = false;

// === INPUT DETECTION (fresh press only) ===
var rightPressed = rightKey && !previousRight;
var leftPressed  = leftKey  && !previousLeft;
var upPressed    = upKey    && !previousUp;
var downPressed  = downKey  && !previousDown;

// === EASE TOWARD TARGET POSITION ===
var move_speed = 0.5;
x = lerp(x, target_x, move_speed);
y = lerp(y, target_y, move_speed);

// Snap when close
if (point_distance(x, y, target_x, target_y) < 1) {
    x = target_x;
    y = target_y;
}

// === MOVEMENT CONTROL ===
if (x == target_x && y == target_y) {
    if (move_buffer > 0) move_buffer--;

    var h = (rightPressed ? 1 : 0) - (leftPressed ? 1 : 0);
    var v = (downPressed ? 1 : 0) - (upPressed ? 1 : 0);

    if (h != 0) v = 0;

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


            // === FACING DIR UPDATE ===
            if (buffered_h == 1) facing_dir = "east";
            else if (buffered_h == -1) facing_dir = "west";
            else if (buffered_v == 1) facing_dir = "south";
            else if (buffered_v == -1) facing_dir = "north";
			
			// === SET PLAYER SPRITE BASED ON FACING DIR ===
			switch (facing_dir) {
			    case "north":
			        sprite_index = PlayerIdleNorth;
			        image_xscale = 1;
			        break;
			    case "south":
			        sprite_index = PlayerIdleSouth;
			        image_xscale = 1;
			        break;
			    case "east":
			        sprite_index = PlayerIdleEast;
			        image_xscale = 1;
			        break;
			    case "west":
			        sprite_index = PlayerIdleEast;
			        image_xscale = -1;
			        break;
			}


            move_buffer = buffer_time;

            // === SIGNAL TO MIR CREEPER ===
            global.player_just_moved = true;
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

// === DEATH CHECK ===
if (!is_dead && place_meeting(x, y, oKillBox)) {
    is_dead = true;
    global.freeze_player = true;

    audio_play_sound(sfxDeath, 1, false); // Play the sound once, priority 1

    var wipe = instance_create_layer(x, y, layer_exists("Effects") ? "Effects" : layer_get_name(0), oDeathWipe);
    wipe.originator = id;
} else if (!is_dead && place_meeting(x, y, oMirCreeper)) {
    is_dead = true;
    global.freeze_player = true;

    audio_play_sound(sfxDeath, 1, false); // Same here

    var wipe = instance_create_layer(x, y, layer_exists("Effects") ? "Effects" : layer_get_name(0), oDeathWipe);
    wipe.originator = id;
} else if (!is_dead && place_meeting(x, y, oMirShadow)) {
    is_dead = true;
    global.freeze_player = true;

    audio_play_sound(sfxDeath, 1, false); // Same here

    var wipe = instance_create_layer(x, y, layer_exists("Effects") ? "Effects" : layer_get_name(0), oDeathWipe);
    wipe.originator = id;
}

// === CAMERA BOX CHECK ===
if (!global.camTransitionActive) {
    var newCamBox = instance_position(x, y, oCamBox);

    if (newCamBox != noone && newCamBox != currentCamBox) {
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

// === LAST CAM BOX TRACKER ===
var _box = instance_place(x, y, oCamBox);
if (_box != noone) {
    last_cam_box = _box;
    global.last_cam_box = _box;
}

// === DEBUG MODE TOGGLE ===
if (debugKey) {
    global.debug_mode = !global.debug_mode;
}
