// oMirCrumble Collision with oPlayer
if (is_broken) {
    // Kill the player manually
    with (other) {
        if (!is_dead) {
            is_dead = true;
            global.freeze_player = true;
            audio_play_sound(sfxDeath, 1, false);

            var wipe = instance_create_layer(x, y, layer_exists("Effects") ? "Effects" : layer_get_name(0), oDeathWipe);
            wipe.originator = id;
        }
    }
}
