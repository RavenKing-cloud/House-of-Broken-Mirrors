// Check for collision with oKillBox first
if (place_meeting(x, y, oKillBox)) {
    visible = false;
    instance_deactivate_object(id);
    return;
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
                    target_x = new_x;
                    target_y = new_y;
                }

                buffered_h = 0;
                buffered_v = 0;
            }
        }
    }
}
