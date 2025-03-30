if (state == "fade_in") {
    alpha += fade_speed;

    if (alpha >= 0.98 && !respawn_triggered) {
        respawn_triggered = true;

        if (instance_exists(originator)) {
            with (originator) {
                var _closest_respawn = noone;
                var _min_dist = 999999;

                if (instance_exists(last_cam_box)) {
                    with (oRespawn) {
                        var box = other.last_cam_box;

                        // Check if respawn is within cam box bounds
                        if (x > box.bbox_left && x < box.bbox_right &&
                            y > box.bbox_top  && y < box.bbox_bottom) {

                            var _dist = point_distance(x, y, other.x, other.y);
                            if (_dist < _min_dist) {
                                _min_dist = _dist;
                                _closest_respawn = self;
                            }
                        }
                    }
                }

                // Move player to respawn
                if (_closest_respawn != noone) {
                    x = _closest_respawn.x;
                    y = _closest_respawn.y;

				// === Face correct direction based on furthest cam box boundary ===
				if (instance_exists(last_cam_box)) {
				    var box = last_cam_box;

				    var cam_left   = box.bbox_left;
				    var cam_right  = box.bbox_right;
				    var cam_top    = box.bbox_top;
				    var cam_bottom = box.bbox_bottom;

				    var d_left   = abs(x - cam_left);
				    var d_right  = abs(cam_right - x);
				    var d_top    = abs(y - cam_top);
				    var d_bottom = abs(cam_bottom - y);

				    var max_dist = max(d_left, d_right, d_top, d_bottom);

				    if (max_dist == d_left) facing_dir = "west";
				    else if (max_dist == d_right) facing_dir = "east";
				    else if (max_dist == d_top) facing_dir = "north";
				    else if (max_dist == d_bottom) facing_dir = "south";
				}

                    // Reset movement target if needed
                    target_x = x;
                    target_y = y;
                }
            }
        }
    }

    if (alpha >= 1) {
        alpha = 1;
        state = "fade_out";
    }

} else if (state == "fade_out") {
    alpha -= fade_speed;

    if (alpha <= 0) {
        alpha = 0;

        // Unfreeze and unlock player
        if (instance_exists(originator)) {
            with (originator) {
                is_dead = false;
            }
        }

        global.freeze_player = false;
        instance_destroy();
    }
}
