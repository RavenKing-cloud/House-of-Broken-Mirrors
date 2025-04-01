/// @description Insert description here
// You can write your code in this editor
killbox = instance_create_layer(x-4,y-4,"Instances",oKillBox);
killbox.image_xscale = .5;
killbox.image_yscale = .5;
image_speed = 0;
turn = global.turn_count;
origin_x = x;
origin_y = y;
origin_index = image_index;