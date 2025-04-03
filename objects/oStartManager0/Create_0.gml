// Stop the previous song
if (audio_is_playing(sfxStart)) {
    audio_stop_sound(sfxStart);
} else if (audio_is_playing(sfxMirrorWar)) {
    audio_stop_sound(sfxMirrorWar);
}

// Start the new song
if (!audio_is_playing(sfxLimbo)) {
    audio_play_sound(sfxLimbo, 10, true); // or any priority you prefer
}
