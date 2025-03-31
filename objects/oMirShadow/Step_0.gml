// TODO: Fix Glitch where it gets stuck on walls every once in a while!

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

        var h = 0;
        var v = 0;

        // Prefer the longer axis toward the player
        if (abs_dx > abs_dy) {
            h = sign(dx);
        } else if (abs_dy > abs_dx) {
            v = sign(dy);
        } else {
            // If equal, randomly choose axis
            if (choose(true, false)) h = sign(dx); else v = sign(dy);
        }

        // Primary attempt
        var new_x = x + h * tile_size;
        var new_y = y + v * tile_size;

        if (can_move_to(new_x, new_y)) {
            target_x = new_x;
            target_y = new_y;

            // Facing direction
            if (h == 1) facing_dir = "east";
            else if (h == -1) facing_dir = "west";
            else if (v == 1) facing_dir = "south";
            else if (v == -1) facing_dir = "north";

            move_buffer = buffer_time;
        } else {
            // Secondary direction (try the other axis)
            h = 0;
            v = 0;

            if (abs_dx > abs_dy) v = sign(dy);
            else h = sign(dx);

            new_x = x + h * tile_size;
            new_y = y + v * tile_size;

            if (can_move_to(new_x, new_y)) {
                target_x = new_x;
                target_y = new_y;

                // Facing direction
                if (h == 1) facing_dir = "east";
                else if (h == -1) facing_dir = "west";
                else if (v == 1) facing_dir = "south";
                else if (v == -1) facing_dir = "north";

                move_buffer = buffer_time;
            }
        }
    }
}

// move the hitbox
killbox.x = x-4;
killbox.y = y-4;