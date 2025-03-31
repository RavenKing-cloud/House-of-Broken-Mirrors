draw_self();

if (!is_inactive) {
    var length = 20;
    var x2 = x, y2 = y;

    switch (facing_dir) {
        case "north": y2 -= length; break;
        case "south": y2 += length; break;
        case "east":  x2 += length; break;
        case "west":  x2 -= length; break;
    }

    draw_set_color(c_red);
    draw_line(x, y, x2, y2);
}

// Debug mode collision mask
if (global.debug_mode) {
    draw_set_color(c_lime);
    draw_set_alpha(0.5);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1);
}
