var _player = instance_find(oPlayer, 0);
if (_player != noone) {
    var wipe = instance_create_layer(_player.x, _player.y, "Effects", oIntroWipe);
    wipe.originator = _player.id;
}
