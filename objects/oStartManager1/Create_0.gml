// Stop the previous song
if (audio_is_playing(sfxLimbo)) {
    audio_stop_sound(sfxLimbo);
}

// Start the new song
if (!audio_is_playing(sfxMirrorWar)) {
    audio_play_sound(sfxMirrorWar, 10, true); // or any priority you prefer
}
