/// @description Insert description here
// You can write your code in this editor
var obj = instance_place(x,y,oPlayer);
with obj{
	if (x == target_x && y == target_y){
		target_x = other.dest.x;
		target_y = other.dest.y;
		x = target_x;
		y = target_y;
	}
}