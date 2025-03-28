if (!instance_exists(oDeathWipe) && !global.player_dying) {
    global.player_dying = true;
    var wipe = instance_create_layer(x, y, layer_exists("Effects") ? "Effects" : layer_get_name(0), oDeathWipe);
    wipe.originator = id;
}
