// oMirCrumble Step Event
if (is_broken) {
    // Already crumbled, nothing to do
    exit;
}

var player_on_top = place_meeting(x, y, oPlayer); // Replace 'oPlayer' with your actual player object name

if (player_on_top) {
    has_been_stepped_on = true;
    player_last_step = true;
} else {
    if (player_last_step && has_been_stepped_on) {
        // Player stepped off — crumble now
        sprite_index = sCrumbleBroken;
        is_broken = true;
    }

    player_last_step = false;
}
