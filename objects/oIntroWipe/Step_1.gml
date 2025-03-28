if (!teleported && instance_exists(originator)) {
    teleported = true;

    with (originator) {
        var _closest_respawn = noone;
        var _min_dist = 999999;

        if (instance_exists(last_cam_box)) {
            with (oRespawn) {
                var box = other.last_cam_box;

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

        if (_closest_respawn != noone) {
            x = _closest_respawn.x;
            y = _closest_respawn.y;
            target_x = x; // <<< CRITICAL FIX
            target_y = y;

            var _left_edge = last_cam_box.bbox_left;
            var _right_edge = last_cam_box.bbox_right;
            var _dist_left = abs(x - _left_edge);
            var _dist_right = abs(x - _right_edge);
            facingDir = (_dist_right > _dist_left) ? 1 : -1;
        }
    }
}
