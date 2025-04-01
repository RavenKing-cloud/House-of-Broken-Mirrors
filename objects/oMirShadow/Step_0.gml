// Check for collision with oKillBox first
if (place_meeting(x, y, oKillBox)) {
    // The enemy has collided with oKillBox and should now "die"
    
    // Hide the sprite so it is not visible on screen
    visible = false;
    
    // Deactivate the enemy instance to prevent further processing
    instance_deactivate_object(id);
    
    // Optionally, set a custom flag if further logic depends on the enemy's state
    // alive = false;
    
    // Terminate further execution for this step
    return;
}

// Check if player is inside the same cambox
if (cambox != noone &&
    oPlayer.x >= cambox.bbox_left && oPlayer.x <= cambox.bbox_right &&
    oPlayer.y >= cambox.bbox_top && oPlayer.y <= cambox.bbox_bottom) {

    // === EASE TOWARD TARGET POSITION ===
    var move_speed = 0.5;
    x = lerp(x, target_x, move_speed);
    y = lerp(y, target_y, move_speed);

    // Snap to target
    if (point_distance(x, y, target_x, target_y) < 1) {
        x = target_x;
        y = target_y;
    }

	// === MOVEMENT LOGIC ===
	if (x == target_x && y == target_y) {
	    if (move_buffer > 0) move_buffer--;

	    if (global.player_just_moved && move_buffer <= 0) {
	        var dx = global.player.x - x;
	        var dy = global.player.y - y;

	        var abs_dx = abs(dx);
	        var abs_dy = abs(dy);

	        var preferred_dirs = [];

	        // Add preferred directions (based on player position)
	        if (abs_dx > abs_dy) {
	            array_push(preferred_dirs, [sign(dx), 0]); // horizontal first
	            array_push(preferred_dirs, [0, sign(dy)]); // vertical second
	        } else {
	            array_push(preferred_dirs, [0, sign(dy)]); // vertical first
	            array_push(preferred_dirs, [sign(dx), 0]); // horizontal second
	        }

	        // Add all directions (if not already added)
	        var all_dirs = [
	            [1, 0], [-1, 0],
	            [0, 1], [0, -1]
	        ];

	        for (var i = 0; i < array_length(all_dirs); i++) {
	            var dir = all_dirs[i];
	            var found = false;
	            for (var j = 0; j < array_length(preferred_dirs); j++) {
	                if (preferred_dirs[j][0] == dir[0] && preferred_dirs[j][1] == dir[1]) {
	                    found = true;
	                    break;
	                }
	            }
	            if (!found) array_push(preferred_dirs, dir);
	        }

	        // Try every direction until one works
	        var moved = false;
	        for (var i = 0; i < array_length(preferred_dirs); i++) {
	            var d = preferred_dirs[i];
	            var new_x = x + d[0] * tile_size;
	            var new_y = y + d[1] * tile_size;

	            if (can_move_to(new_x, new_y)) {
	                target_x = new_x;
	                target_y = new_y;

	                // Set facing direction
	                if (d[0] == 1) facing_dir = "east";
	                else if (d[0] == -1) facing_dir = "west";
	                else if (d[1] == 1) facing_dir = "south";
	                else if (d[1] == -1) facing_dir = "north";

	                move_buffer = buffer_time;
	                moved = true;
	                break;
	            }
	        }

	        // Optional: set a "stuck" flag if needed
	        // is_stuck = !moved;
	    }
	}

}
