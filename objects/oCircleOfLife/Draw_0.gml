draw_set_color(c_red); // Outline color

var cx = center_x -1;
var cy = center_y;
var size = radius; // You can tweak this if needed

// === Upward-pointing triangle ===
var angle_offset = -90; // point tip up
var up_pts = [];

for (var i = 0; i < 3; i++) {
    var angle = angle_offset + i * 120;
    var px = cx + lengthdir_x(size, angle);
    var py = cy + lengthdir_y(size, angle);
    array_push(up_pts, [px, py]);
}

draw_line(up_pts[0][0], up_pts[0][1], up_pts[1][0], up_pts[1][1]);
draw_line(up_pts[1][0], up_pts[1][1], up_pts[2][0], up_pts[2][1]);
draw_line(up_pts[2][0], up_pts[2][1], up_pts[0][0], up_pts[0][1]);

// === Downward-pointing triangle ===
angle_offset = 30; // point tip down
var down_pts = [];

for (var i = 0; i < 3; i++) {
    var angle = angle_offset + i * 120;
    var px = cx + lengthdir_x(size, angle);
    var py = cy + lengthdir_y(size, angle);
    array_push(down_pts, [px, py]);
}

draw_line(down_pts[0][0], down_pts[0][1], down_pts[1][0], down_pts[1][1]);
draw_line(down_pts[1][0], down_pts[1][1], down_pts[2][0], down_pts[2][1]);
draw_line(down_pts[2][0], down_pts[2][1], down_pts[0][0], down_pts[0][1]);
