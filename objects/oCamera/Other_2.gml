/// Global Variables Initialization
// Camera transition control variables
global.camTransitionActive = false;    // Flag to indicate an active camera transition
global.camTransitionTimer  = 0;          // Timer to track transition progress
global.camTransitionDuration = 30;       // Duration of the transition in steps (adjust as necessary)
global.targetCamBox = noone;             // The target camBox for the upcoming transition
