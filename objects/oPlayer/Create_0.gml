// Setup
controlsSetup()

global.player_just_moved = false;
global.tile_size = 16; // or whatever your tile size is
global.turn_count = 0;

facing_dir = "south"; // default direction
is_dead = false;

// Target position to move to
target_x = x;
target_y = y;
currently_on_one_way = noone;


// Snap to grid on start
tile_size = 16;
x = round(x / tile_size) * tile_size;
y = round(y / tile_size) * tile_size;

// Movement flag
can_move = true;

// Movement buffer (cooldown)
move_buffer = 0;
buffer_time = 6; // test value, in frames

// Input buffering
buffered_h = 0;
buffered_v = 0;
previousRight = false;
previousLeft  = false;
previousUp    = false;
previousDown  = false;

// Teleporters
teleporting = false;
teleport_target_x = 0;
teleport_target_y = 0;
teleport_speed = 2;
teleport_cooldown = 0;
teleport_safety_timer = 0;
last_teleport_id = noone;
teleport_movement_required = false; // ✅ New flag


// Camera
currentCamBox = noone;
inTransition = false;
freeze = false;
transitionTimer = 0;
last_cam_box = noone;
// In the Create event of an appropriate controller or player object:
global.last_cam_box = instance_find(oCamBox, 0); // Ensure this is set to a valid instance

// Debug Mode
global.debug_mode = false; // Initialize debug mode to be off by default

// default spawn
x+=8;
y+=8;
instance_create_layer(x,y,"instances",oRespawn);

