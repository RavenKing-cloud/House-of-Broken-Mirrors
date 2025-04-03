// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function returnToOrigin(Object){
	instance_activate_object(Object);
	with(Object){
		if Object = oMirCrumble{
			is_broken = false;
			has_been_stepped_on = false;
			player_last_step = false;
		}
		else if Object = oGate_parent{
			active = true;
		}
		else{
			x = origin_x;
			y = origin_y;
			image_index = origin_index;
			visible = true;
			if(Object == oEnemy) || (Object == oMirShadow) || (Object == oMirCreeper) {
				target_x = x;
				target_y = y;
				if  (Object == oMirCreeper) {
					facing_dir = "east";
					turning_dir = "south";
				}
			}
		}
	}
}