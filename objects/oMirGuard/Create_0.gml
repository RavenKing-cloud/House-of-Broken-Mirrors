origin_x = x;
origin_y = y;
origin_index = image_index;

facing_dir = "east";
turning_dir = "south"; // Can be "north", "south", "east", "west"
is_inactive = false;

move_buffer = 0;
buffer_time = 6; // Or whatever your player's `buffer_time` is

tile_size = 16;
target_x = x;
target_y = y;

buffered_h = 0;
buffered_v = 0;

move_buffer = 0;

// Find the cambox that contains this object
cambox = noone;
with (oCamBox) {
    if (other.x >= bbox_left && other.x <= bbox_right &&
        other.y >= bbox_top && other.y <= bbox_bottom) {
        other.cambox = id;
    }
}