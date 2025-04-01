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

// Continue with existing movement logic if not colliding with oKillBox
if (cambox != noone &&
    oPlayer.x >= cambox.bbox_left && oPlayer.x <= cambox.bbox_right &&
    oPlayer.y >= cambox.bbox_top && oPlayer.y <= cambox.bbox_bottom) {

    // === EASE TOWARD TARGET POSITION ===
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
                target_x = new_x;
                target_y = new_y;
            }

            buffered_h = 0;
            buffered_v = 0;
        }
    }
}
