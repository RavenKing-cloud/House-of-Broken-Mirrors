// Check for collision with oKillBox first
if (place_meeting(x, y, oKillBox)) {
	audio_play_sound(sfxShadowDeath, 3, false);
    kill_and_respawn();
    return;
}

// Check if player is outside the enemy's cambox
if (cambox != noone) {
    var player_outside_cambox = (
        oPlayer.x < cambox.bbox_left || oPlayer.x > cambox.bbox_right ||
        oPlayer.y < cambox.bbox_top || oPlayer.y > cambox.bbox_bottom
    );

    if (player_outside_cambox) {
        kill_and_respawn();
        return;
    }

    // === EASE TOWARD TARGET POSITION ===
    var move_speed = 0.5;
    x = lerp(x, target_x, move_speed);
    y = lerp(y, target_y, move_speed);

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

            if (abs_dx > abs_dy) {
                array_push(preferred_dirs, [sign(dx), 0]);
                array_push(preferred_dirs, [0, sign(dy)]);
            } else {
                array_push(preferred_dirs, [0, sign(dy)]);
                array_push(preferred_dirs, [sign(dx), 0]);
            }

            var all_dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];

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

            var moved = false;
            for (var i = 0; i < array_length(preferred_dirs); i++) {
                var d = preferred_dirs[i];
                var new_x = x + d[0] * tile_size;
                var new_y = y + d[1] * tile_size;

                if (can_move_to(new_x, new_y)) {
                    target_x = new_x;
                    target_y = new_y;

                    if (d[0] == 1) facing_dir = "east";
                    else if (d[0] == -1) facing_dir = "west";
                    else if (d[1] == 1) facing_dir = "south";
                    else if (d[1] == -1) facing_dir = "north";

                    move_buffer = buffer_time;
                    moved = true;
                    break;
                }
            }

            // Optional: is_stuck = !moved;
        }
    }
}

// === Kill and Respawn Function ===
function kill_and_respawn() {
    // You can animate or fade if needed
    visible = false;

    // Wait a frame (optional), then reset
    alarm[0] = 1; // Set to respawn next frame
}
