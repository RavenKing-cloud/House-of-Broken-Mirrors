draw_set_color(c_black); // Set color to black
draw_set_alpha(alpha);   // Apply transparency
draw_rectangle(0, 0, room_width, room_height, false); // Draw a filled rectangle
draw_set_alpha(1);       // Reset alpha
