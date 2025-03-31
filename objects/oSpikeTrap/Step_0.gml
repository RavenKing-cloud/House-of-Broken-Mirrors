/// @description Insert description here
// You can write your code in this editor

if turn != global.turn_count{
	turn = global.turn_count;
	image_index++;
}
if image_index = 0	instance_deactivate_object(killbox);
else if (!place_meeting(x,y,oPlayer)&&!place_meeting(x,y,OEnemy_parent)) instance_activate_object(killbox);
else alarm[0] = 5;