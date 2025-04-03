

function controlsSetup()
{

}

function getControls()
{
	// Directional Inputs
	rightKey = keyboard_check(ord("D")) + keyboard_check(vk_right) + gamepad_button_check(0, gp_padr);
	rightKey = clamp(rightKey, 0, 1);
	
	leftKey = keyboard_check(ord("A")) + keyboard_check(vk_left) + gamepad_button_check(0, gp_padl);
	leftKey = clamp(leftKey, 0, 1);
	
	upKey = keyboard_check(ord("W")) + keyboard_check(vk_up) + gamepad_button_check(0, gp_padu);
	upKey = clamp(upKey, 0, 1);
	
	downKey = keyboard_check(ord("S")) + keyboard_check(vk_down) + gamepad_button_check(0, gp_padd);
	downKey = clamp(downKey, 0, 1);
	
	aKey = keyboard_check(vk_space) + gamepad_button_check(0, gp_face1);
	aKey = clamp(aKey, 0, 1);
	
	bKey = keyboard_check(ord("C")) + keyboard_check(vk_shift) + gamepad_button_check(0, gp_face3);
	bKey = clamp(bKey, 0, 1);
	
	debugKey = keyboard_check_pressed(vk_lcontrol);
}

// Collisions
function can_move_to(_x, _y) {
    var tile_check = instance_place(_x, _y, oWall);
    if (tile_check != noone) return false;

    var gate_check = instance_place(_x, _y, oGate);
    if (gate_check != noone && gate_check.active) return false;
	
    var gate_check2 = instance_place(_x, _y, oGate2);
    if (gate_check2 != noone && gate_check2.active) return false;
	
    var gate_check3 = instance_place(_x, _y, oGate3);
    if (gate_check3 != noone && gate_check3.active) return false;
	
    var toggle_check = instance_place(_x, _y, oToggleWall);
    if (toggle_check != noone && toggle_check.active) return false;

    return true;
}

function enemy_in_front(_x, _y) {
    var enemy_types = [oEnemy, oMirCreeper, oMirGuardLoop];
    
    for (var i = 0; i < array_length(enemy_types); i++) {
        if (instance_place(_x, _y, enemy_types[i]) != noone) {
            return true;
        }
    }
    return false;
}



/// Big Thanks to The Creators of Celeste for these Godlike Helper functions of approach and lerp
/// and for inspiration in the use of easeing functions for smooth movement! vvv

/// @function approach(current, target, step)
/// @desc Moves the current value towards the target by the specified step size.
/// @param {real} current - The current value to move.
/// @param {real} target - The target value.
/// @param {real} step - The maximum amount to move towards the target in one step.

function approach(current, target, step) {
    if (current < target) {
        return min(current + step, target); // Move up to the target, but don't overshoot
    } else if (current > target) {
        return max(current - step, target); // Move down to the target, but don't overshoot
    }
    return current; // If current equals target, just return the current value
}

/// @function lerp(a, b, t)
/// @desc Linearly interpolates between two values based on a fraction t.
/// @param {real} a - The starting value.
/// @param {real} b - The target value.
/// @param {real} t - The interpolation factor (between 0 and 1).

function lerp(a, b, t) {
    return a + (b - a) * t;
}

/// @description Ease in-out quadratic function
function ease_in_out_quad(t, b, c, d)
{
    t /= d / 2;
    if (t < 1) return c / 2 * t * t + b;
    t--;
    return -c / 2 * (t * (t - 2) - 1) + b;
}

// @description Ease in-out cubic function
function ease_in_out_cubic(t, b, c, d) {
    t /= d / 2;
    if (t < 1) return c / 2 * t * t * t + b;
    t -= 2;
    return c / 2 * (t * t * t + 2) + b;
}

// @description Ease in-out linear function
function ease_in_out_linear(t, b, c, d) {
    return c * t / d + b;
}

