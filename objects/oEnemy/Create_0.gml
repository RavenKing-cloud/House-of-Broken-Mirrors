/// initiate hitbox
killbox = instance_create_layer(x-8,y-8,"Instances",oKillBox);
killbox.image_xscale = .5;
killbox.image_yscale = .5;
// variables
image_speed = 0;
turn = global.turn_count;
target_x = x;
target_y = y;
buffered_h = 0;
buffered_v = 0;
tile_size = oPlayer.tile_size;

origin_x = x;
origin_y = y;
origin_index = image_index;