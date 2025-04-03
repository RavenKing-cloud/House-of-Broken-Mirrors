var player_cambox = noone;
with (oCamBox) {
    if (oPlayer.x >= bbox_left && oPlayer.x <= bbox_right &&
        oPlayer.y >= bbox_top && oPlayer.y <= bbox_bottom) {
        player_cambox = id;
        break;
    }
}

if (turn != global.turn_count) {
    turn = global.turn_count;
    image_index++;
}

if (player_cambox != noone &&
    x >= player_cambox.bbox_left && x <= player_cambox.bbox_right &&
    y >= player_cambox.bbox_top && y <= player_cambox.bbox_bottom) {

    if (image_index == 0) {
        instance_deactivate_object(killbox);
    }
    else if (!place_meeting(x, y, oPlayer) && !place_meeting(x, y, oEnemy)) {
        instance_activate_object(killbox);
    }
    else {
        alarm[0] = 1;
    }
}
