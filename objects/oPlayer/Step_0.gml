// === GET CONTROLS ===
getControls();

// === FREEZE LOGIC ===
if (global.freeze_player || is_dead || global.pause) {
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

		if (enemy_in_front(new_x, new_y)) {
		    audio_play_sound(sfxSwordSwing, 1, false);
		    move_buffer = buffer_time;

		    // Clear previous kill box
		    if (instance_exists(killbox_instance)) {
		        instance_destroy(killbox_instance);
		        killbox_instance = noone;
		    }

		    var offset_x = 0;
		    var offset_y = 0;
		    var dir_angle = 0;

		    if (buffered_h == 1) {
		        dir_angle = 0; offset_x = 12; offset_y = -4;
		    }
		    else if (buffered_h == -1) {
		        dir_angle = 180; offset_x = -20; offset_y = -4;
		    }
		    else if (buffered_v == 1) {
		        dir_angle = 270; offset_y = 12; offset_x = -4;
		    }
		    else if (buffered_v == -1) {
		        dir_angle = 90; offset_y = -20; offset_x = -4;
		    }

		    killbox_instance = instance_create_layer(x + offset_x, y + offset_y, "Instances", oKillBoxSword);
		    killbox_instance.direction = dir_angle;
		    killbox_timer = 5; // Start kill box countdown
		} else {
			// === ONE WAY TILE BLOCK CHECK ===
			var one_way_tile = instance_place(new_x, new_y, oOneWay);
			if (one_way_tile != noone && variable_instance_exists(one_way_tile, "facing")) {
			    var block_move = false;

			    switch (one_way_tile.facing) {
			        case "north":
			            if (buffered_v == 1 && buffered_h == 0) block_move = true; // Trying to move down onto north-facing tile
			            break;
			        case "south":
			            if (buffered_v == -1 && buffered_h == 0) block_move = true; // Trying to move up onto south-facing tile
			            break;
			        case "east":
			            if (buffered_h == -1 && buffered_v == 0) block_move = true; // Trying to move left onto east-facing tile
			            break;
			        case "west":
			            if (buffered_h == 1 && buffered_v == 0) block_move = true; // Trying to move right onto west-facing tile
			            break;
			    }

			    if (block_move) {
			        audio_play_sound(sfxWallBump, 2, false);
			        move_buffer = buffer_time;
			        buffered_h = 0;
			        buffered_v = 0;
			        return;
			    }
			}

            // === NORMAL MOVEMENT ===
            if (can_move_to(new_x, new_y)) {
                audio_play_sound(sfxPlayerMove, 1, false);
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
                    case "north": sprite_index = PlayerIdleNorth; image_xscale = 1; break;
                    case "south": sprite_index = PlayerIdleSouth; image_xscale = 1; break;
                    case "east":  sprite_index = PlayerIdleEast;  image_xscale = 1; break;
                    case "west":  sprite_index = PlayerIdleEast;  image_xscale = -1; break;
                }

                move_buffer = buffer_time;
                global.player_just_moved = true;
            } else if !can_move_to(new_x,new_y) {
				audio_play_sound(sfxWallBump, 2, false);
			}
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
} else if (!is_dead && place_meeting(x, y, oMirCreeper)) || (!is_dead && place_meeting(x, y, oMirShadow)) || (!is_dead && place_meeting(x, y, oEnemy)) {
    is_dead = true;
    global.freeze_player = true;

    audio_play_sound(sfxDeath, 1, false); // Same here

    var wipe = instance_create_layer(x, y, layer_exists("Effects") ? "Effects" : layer_get_name(0), oDeathWipe);
    wipe.originator = id;
}

// Camera Movement
// Assume currentCamBox is an instance variable defined in the player's Create event.
if (!global.camTransitionActive) {
    // Detect the camBox under the player's center.
    var newCamBox = instance_position(x, y, oCamBox);
    
    // Trigger a transition only if a valid new camBox is detected and it differs from the current one.
    if (newCamBox != noone && newCamBox != currentCamBox) {
        // Calculate overlap between the player's bounding box and the new camBox.
        var overlap_left   = max(bbox_left, newCamBox.x);
        var overlap_top    = max(bbox_top, newCamBox.y);
        var overlap_right  = min(bbox_right, newCamBox.x + newCamBox.sprite_width);
        var overlap_bottom = min(bbox_bottom, newCamBox.y + newCamBox.sprite_height);
        var overlap_width  = max(0, overlap_right - overlap_left);
        var overlap_height = max(0, overlap_bottom - overlap_top);
        var overlap_area   = overlap_width * overlap_height;
        
        var player_area = (bbox_right - bbox_left) * (bbox_bottom - bbox_top);
        
        // If more than 50% of the player's collision area overlaps the new camBox, initiate a transition.
        if (overlap_area > player_area * 0.5) {
            global.camTransitionActive = true;
            global.camTransitionTimer  = 0;
            global.targetCamBox        = newCamBox;
        }
    }
} else {
    // Update the transition timer.
    global.camTransitionTimer++;
    
    // Once the transition duration is met, complete the transition.
    if (global.camTransitionTimer >= global.camTransitionDuration) {
        currentCamBox = global.targetCamBox;  // Update active camBox.
        global.camTransitionActive = false;
        global.camTransitionTimer = 0;
        global.targetCamBox = noone;  // Clear the target.
    }
}
/// For Respawn
var _box = instance_place(x, y, oCamBox);
if (_box != noone) {
    last_cam_box = _box; // Store the last `oCamBox` the player was in
}
// === KillBox Timer Logic ===
if (killbox_timer > 0) {
    killbox_timer--;
    if (killbox_timer <= 0 && instance_exists(killbox_instance)) {
        instance_destroy(killbox_instance);
        killbox_instance = noone;
    }
}




// === DEBUG MODE TOGGLE ===
if (debugKey) {
    global.debug_mode = !global.debug_mode;
}
/// == game reset for bug
if (keyboard_check_pressed(ord("R"))) game_restart();