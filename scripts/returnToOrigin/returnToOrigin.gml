// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function returnToOrigin(Object){
	instance_activate_object(Object);
	with(Object){
		x = origin_x;
		y = origin_y;
		image_index = origin_index;
		if(Object == oEnemy){
			target_x = x;
			target_y = y;
		}
	}
}