// Check for collision with oKillBox first
if (place_meeting(x, y, oKillBox)) {
	audio_play_sound(sfxCreeperDeath, 3, false);
    visible = false;
    instance_deactivate_object(id);
    return;
}

// === PREVENT TILE OVERLAP WITH SAME TYPE ===
var my_tile_x = floor(x / tile_size);
var my_tile_y = floor(y / tile_size);

var other_creeper = instance_place(target_x, target_y, oMirCreeper);
if (other_creeper != noone && other_creeper.id != id) {
    // Die
		audio_play_sound(sfxCreeperDeath, 3, false);
	    visible = false;
	    instance_deactivate_object(id);
	    return;
}


// === DIE IF SHARING TILE WITH SPECIFIC ENEMIES FOR 3 FRAMES ===
var death_enemies = [oMirShadow, oMirGuardLoop];
var found_overlap = false;

for (var i = 0; i < array_length(death_enemies); i++) {
    var type = death_enemies[i];
    with (type) {
        if (id != other.id) {
            var tile_x = floor(x / tile_size);
            var tile_y = floor(y / tile_size);
            if (tile_x == my_tile_x && tile_y == my_tile_y) {
                found_overlap = true;
            }
        }
    }
}

if (found_overlap) {
    overlap_counter++;
    if (overlap_counter >= 3) {
		audio_play_sound(sfxCreeperDeath, 3, false);
	    visible = false;
	    instance_deactivate_object(id);
	    return;
    }
} else {
    overlap_counter = 0;
}


// Check if the enemy has exited its own cambox and the player is no longer in it
if (cambox != noone) {
    var outside_cambox = (x < cambox.bbox_left || x > cambox.bbox_right ||
                          y < cambox.bbox_top || y > cambox.bbox_bottom);

    var player_outside_cambox = (oPlayer.x < cambox.bbox_left || oPlayer.x > cambox.bbox_right ||
                                 oPlayer.y < cambox.bbox_top || oPlayer.y > cambox.bbox_bottom);

    if (outside_cambox && player_outside_cambox) {
        visible = false;
        instance_deactivate_object(id);
        return;
    }

    // Proceed only if the player is still inside the enemy's cambox
    if (!player_outside_cambox) {
        // === EASE TOWARD TARGET POSITION ===
        var move_speed = 0.5;
        x = lerp(x, target_x, move_speed);
        y = lerp(y, target_y, move_speed);

        // Snap to target
        if (point_distance(x, y, target_x, target_y) < 1) {
            x = target_x;
            y = target_y;
        }

        // === TILE MOVEMENT LOGIC ===
        if (x == target_x && y == target_y) {
            if (move_buffer > 0) move_buffer--;

            if (global.player_just_moved && move_buffer <= 0) {
                var moved = false;

                repeat (4) {
                    var h = 0;
                    var v = 0;

                    switch (facing_dir) {
                        case "north": v = -1; break;
                        case "south": v =  1; break;
                        case "east":  h =  1; break;
                        case "west":  h = -1; break;
                    }

                    var new_x = x + h * tile_size;
                    var new_y = y + v * tile_size;

                    if (can_move_to(new_x, new_y)) {
                        target_x = new_x;
                        target_y = new_y;
                        move_buffer = buffer_time;
                        moved = true;
                        break;
                    } else {
                        // Turn instantly when blocked
                        switch (turning_dir) {
                            case "north":
                                if (facing_dir == "east") facing_dir = "north";
                                else if (facing_dir == "south") facing_dir = "east";
                                else if (facing_dir == "west") facing_dir = "south";
                                else facing_dir = "west";
                                break;

                            case "south":
                                if (facing_dir == "east") facing_dir = "south";
                                else if (facing_dir == "north") facing_dir = "east";
                                else if (facing_dir == "west") facing_dir = "north";
                                else facing_dir = "west";
                                break;

                            case "east":
                                if (facing_dir == "north") facing_dir = "east";
                                else if (facing_dir == "west") facing_dir = "north";
                                else if (facing_dir == "south") facing_dir = "west";
                                else facing_dir = "south";
                                break;

                            case "west":
                                if (facing_dir == "north") facing_dir = "west";
                                else if (facing_dir == "east") facing_dir = "north";
                                else if (facing_dir == "south") facing_dir = "east";
                                else facing_dir = "south";
                                break;
                        }
                    }
                }

                if (!moved) {
                    move_buffer = buffer_time;
                }
            }
        }
    }
}
