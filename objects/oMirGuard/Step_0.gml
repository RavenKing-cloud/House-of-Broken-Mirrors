
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
