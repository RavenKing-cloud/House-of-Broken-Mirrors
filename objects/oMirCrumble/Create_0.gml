// oMirCrumble Create Event
has_been_stepped_on = false;
player_last_step = false;
is_broken = false;


killbox = instance_create_layer(x,y,"Instances",oKillBox);
killbox.image_xscale = .5;
killbox.image_yscale = .5;
instance_deactivate_object(killbox);