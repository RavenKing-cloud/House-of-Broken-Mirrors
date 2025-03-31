var player_on = place_meeting(x, y, oPlayer);

if (player_on && !player_was_on) {
    // Player just stepped on → toggle gate
    with (oToggleWall) {
        active = !active;
    }
}

// Update state for next frame
player_was_on = player_on;
