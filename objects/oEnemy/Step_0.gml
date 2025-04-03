// Check for collision with oKillBox first
if (place_meeting(x, y, oKillBox)) {
	audio_play_sound(sfxDemonDeath, 3, false);
    visible = false;
    instance_deactivate_object(id);
    return;
}

// List of enemy types that cause death on overlap
var death_enemies = [oMirCreeper, oMirShadow, oMirGuardLoop];

// Get current tile position
var my_tile_x = floor(x / tile_size);
var my_tile_y = floor(y / tile_size);

var found_overlap = false;

// Check against each enemy type
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

// Handle the result
if (found_overlap) {
    overlap_counter++;
    if (overlap_counter >= 3) {
		audio_play_sound(sfxDemonDeath, 3, false);
	    visible = false;
	    instance_deactivate_object(id);
	    return;
    }
} else {
    overlap_counter = 0;
}


// Check if enemy exited its assigned cambox
if (cambox != noone) {
    var outside_cambox = (x < cambox.bbox_left || x > cambox.bbox_right ||
                          y < cambox.bbox_top || y > cambox.bbox_bottom);
    
    var player_outside_cambox = (oPlayer.x < cambox.bbox_left || oPlayer.x > cambox.bbox_right ||
                                 oPlayer.y < cambox.bbox_top || oPlayer.y > cambox.bbox_bottom);
    
    if (outside_cambox && player_outside_cambox) {
        // Enemy is outside its own cambox, and player has moved on
        visible = false;
        instance_deactivate_object(id);
        return;
    }

    // Enemy is within its own cambox, or player is still in it – proceed with logic
    if (!player_outside_cambox) {
        var move_speed = 0.5;
        x = lerp(x, target_x, move_speed);
        y = lerp(y, target_y, move_speed);

        if (point_distance(x, y, target_x, target_y) < 1) {
            x = target_x;
            y = target_y;
        }

        if (turn != global.turn_count) {
            turn = global.turn_count;

            if (buffered_h != 0 || buffered_v != 0) {
                var new_x = x - buffered_h * tile_size;
                var new_y = y - buffered_v * tile_size;

			if (can_move_to(new_x, new_y)) {
			    // Check if another oEnemy is already at the target tile
			    var other_enemy = instance_place(new_x, new_y, oEnemy);
			    if (other_enemy == noone || other_enemy.id == id) {
			        target_x = new_x;
			        target_y = new_y;
			    }
			}
                buffered_h = 0;
                buffered_v = 0;
            }
        }
    }
}
