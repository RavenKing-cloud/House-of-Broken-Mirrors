/// @description Insert description here
// You can write your code in this editor
// === EASE TOWARD TARGET POSITION ===
// Use lerp() to move towards target_x and target_y smoothly
var move_speed = 0.5; // Between 0 (no movement) and 1 (instant)
x = lerp(x, target_x, move_speed);
y = lerp(y, target_y, move_speed);

// Optional: Snap to target when very close to avoid jitter
if (point_distance(x, y, target_x, target_y) < 1) {
    x = target_x;
    y = target_y;
}

// Do something then turn passes
if turn != global.turn_count {
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
// move the hitbox
killbox.x = x-4;
killbox.y = y-4;