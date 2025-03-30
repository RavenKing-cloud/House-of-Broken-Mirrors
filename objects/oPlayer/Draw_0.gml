// Draw event (or Draw GUI if you prefer HUD overlay)
draw_self(); // Keep drawing the player sprite

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


// Debug - Show the collision mask outline
if (global.debug_mode) {
    draw_set_color(c_lime);   // Set color for the debug outline
    draw_set_alpha(0.5);     // Make it slightly transparent for clarity

    // Draw the bounding box of the current collision mask
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);

    draw_set_alpha(1);       // Reset alpha after drawing
}
