// === If we're in the middle of movement ===
if (move_timer > 0) {
    move_timer--;
    
    // Linear step toward target position
    var move_step = tile_size / move_cooldown;
    x = approach(x, target_x, move_step);
    y = approach(y, target_y, move_step);
    
    // Final snap on completion
    if (move_timer == 0) {
        x = target_x;
        y = target_y;
    }
    
    return;
}

// === If we're ready to decide next tile ===
if (x == target_x && y == target_y) {
    var dx = (axis == "x") ? dir * tile_size : 0;
    var dy = (axis == "y") ? dir * tile_size : 0;

    var next_x = x + dx;
    var next_y = y + dy;

    var hit_wall = place_meeting(next_x, next_y, oWall);
    var hit_self = instance_place(next_x, next_y, oMirCreeper);

    if (hit_wall || (hit_self != noone && hit_self.id != id)) {
        dir *= -1; // Flip direction
        // Try the opposite direction immediately
        dx = (axis == "x") ? dir * tile_size : 0;
        dy = (axis == "y") ? dir * tile_size : 0;
        next_x = x + dx;
        next_y = y + dy;

        hit_wall = place_meeting(next_x, next_y, oWall);
        hit_self = instance_place(next_x, next_y, oMirCreeper);
        
        // If blocked both ways, do nothing
        if (hit_wall || (hit_self != noone && hit_self.id != id)) {
            return;
        }
    }

    target_x = x + dx;
    target_y = y + dy;
    move_timer = move_cooldown;
}
