// oMirCrumble Create Event
has_been_stepped_on = false;
player_last_step = false;
is_broken = false;


killbox = instance_create_layer(x,y,"Instances",oKillBox);
killbox.visible = false;
instance_deactivate_object(killbox);