alpha -= fade_speed;

if (alpha <= 0) {
    alpha = 0;
    global.freeze_player = false;
    instance_destroy();
}
