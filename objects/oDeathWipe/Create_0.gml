// === oDeathWipe: Create Event ===
state = "fade_in";
alpha = 0;
fade_speed = 0.02;
respawn_triggered = false;
originator = noone;
fade_only = false; // Set true for fade-from-black effect (no respawn)

// If fade_only is enabled from the outside, set these:
if (fade_only) {
    alpha = 1;
    state = "fade_out";
}
