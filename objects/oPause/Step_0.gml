if keyboard_check_pressed(vk_escape) global.pause = !global.pause;
if global.pause {

var key_select = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) ||  gamepad_button_check(0, gp_face1);
if keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")) || gamepad_button_check(0, gp_padd)
{
	if select < max_select select++
	else select = 0;

}
if keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))|| gamepad_button_check(0, gp_padu){
	if select > 0 select--;
	else select = max_select;
}
if key_select{
	switch(select){
		case 0:
			global.pause  = false;
		break;
		case 1:
			global.pause = false;
			room_restart();
		break;
		case 2:
			global.pause = false;
			room_goto(Hub);
		break;
		case 3:
			game_end();
		break;
	}
}
}