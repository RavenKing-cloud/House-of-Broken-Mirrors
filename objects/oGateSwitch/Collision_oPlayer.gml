var player_cambox = noone;
with (oCamBox) {
    if (oPlayer.x >= bbox_left && oPlayer.x <= bbox_right &&
        oPlayer.y >= bbox_top && oPlayer.y <= bbox_bottom) {
        player_cambox = id;
        break;
    }
}

if (player_cambox != noone) {
    with (oGate) {
        if (x >= player_cambox.bbox_left && x <= player_cambox.bbox_right &&
            y >= player_cambox.bbox_top && y <= player_cambox.bbox_bottom) {
            
            if (active) { // only if it was active before
                active = false;
                audio_play_sound(sfxGateBreak, 0, false); // play your SFX
            }
        }
    }
}
