alpha -= fade_speed;

if (alpha <= 0) {
    alpha = 0;

    // Only trigger teleport once
    if (!teleported && instance_exists(originator)) {
        teleported = true;

        with (originator) {
            var _closest_respawn = noone;
            var _min_dist = 999999;

            var box = noone;
            if (instance_exists(last_cam_box)) {
                box = last_cam_box;
            } else if (instance_exists(global.last_cam_box)) {
                box = global.last_cam_box;
            }

            if (box != noone) {
                with (oRespawn) {
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
				var respawn  = instance_create_layer(oPlayer.x,oPlayer.y,"instances",oRespawn);
                x = respawn.x;
                y = respawn.y;
                target_x = x;
                target_y = y;

                // Facing direction calculation
                if (box != noone) {
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
            } else {
                show_debug_message("No valid respawn found.");
            }
        }
    }

    // Unfreeze and end
    global.freeze_player = false;
    instance_destroy();
}

