origin_x = x;
origin_y = y;

origin_index = image_index;
active = true;
overlap_counter = 0;


// variables
image_speed = 0;
turn = global.turn_count;
target_x = x;
target_y = y;
buffered_h = 0;
buffered_v = 0;
tile_size = 16;

// Find the cambox that contains this object
cambox = noone;
with (oCamBox) {
    if (other.x >= bbox_left && other.x <= bbox_right &&
        other.y >= bbox_top && other.y <= bbox_bottom) {
        other.cambox = id;
    }
}
