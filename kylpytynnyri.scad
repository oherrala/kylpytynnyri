
use <barrel.scad>

// http://www.asete.fi/index1.html

// CONSTANTS:
plank = [42,95];  // X, Y eli seinän paksuus kertaa leveys
planks = 50;      // Lautojen määrä
height = 1000;    // Tynnyrin korkeus

// CONSTANTS:
// plank = [42,140]; // X, Y eli seinän paksuus kertaa leveys
// planks = 42;      // Lautojen määrä

barrel_sides(planks, plank, height);
