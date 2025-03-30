if (state == "fade_in") {
    alpha += fade_speed;

    if (alpha >= 0.98 && !respawn_triggered) {
        respawn_triggered = true;
		
		// return objects to original;
		returnToOrigin(oEnemy);
		returnToOrigin(oSpikeTrap);

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

                    // Face correct direction based on cam box position
                    var _left_edge = last_cam_box.bbox_left;
                    var _right_edge = last_cam_box.bbox_right;
                    var _dist_left = abs(x - _left_edge);
                    var _dist_right = abs(x - _right_edge);
                    facingDir = (_dist_right > _dist_left) ? 1 : -1;

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
