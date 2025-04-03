if global.pause{
	draw_sprite_ext(background, 0, x,y,menu_size,menu_size,0,c_white,0.8);
	if select = 0  draw_sprite_ext(back, 1, x,y,menu_size,menu_size,0,c_white,1);
	else draw_sprite_ext(back, 0, x,y,menu_size,menu_size,0,c_white,1);
	if select = 1 draw_sprite_ext(reset_lelvel, 1, x,y,menu_size,menu_size,0,c_white,1);
	else draw_sprite_ext(reset_lelvel, 0, x,y,menu_size,menu_size,0,c_white,1);
	if select = 2 draw_sprite_ext(hub, 1, x,y,menu_size,menu_size,0,c_white,1);
	else draw_sprite_ext(hub, 0, x,y,menu_size,menu_size,0,c_white,1);
	if select = 3 draw_sprite_ext(quithgame, 1, x,y,menu_size,menu_size,0,c_white,1);
	else draw_sprite_ext(quithgame, 0, x,y,menu_size,menu_size,0,c_white,1);
}