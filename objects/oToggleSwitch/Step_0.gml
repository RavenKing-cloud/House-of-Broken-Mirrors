var player_on = place_meeting(x, y, oPlayer) || place_meeting(x, y, oEnemy) || 
                place_meeting(x, y, oMirShadow) || place_meeting(x, y, oMirCreeper);

var player_cambox = noone;
with (oCamBox) {
    if (oPlayer.x >= bbox_left && oPlayer.x <= bbox_right &&
        oPlayer.y >= bbox_top && oPlayer.y <= bbox_bottom) {
        player_cambox = id;
        break;
    }
}

if (player_on && !player_was_on && player_cambox != noone) {
    with (oToggleWall) {
        // Make sure toggle wall is in camera bounds
        if (x >= player_cambox.bbox_left && x <= player_cambox.bbox_right &&
            y >= player_cambox.bbox_top && y <= player_cambox.bbox_bottom) {

            // Safe toggle check: make sure no one is intersecting the wall
            if (!place_meeting(x, y, oPlayer) && !place_meeting(x, y, oEnemy) && !place_meeting(x, y, oMirShadow) && !place_meeting(x, y, oMirCreeper)) {
                active = !active;
            }
        }
    }
}

player_was_on = player_on;
