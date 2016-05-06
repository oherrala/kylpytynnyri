

// http://www.asete.fi/index1.html

// CONSTANTS:
plank = [42,95]; // X, Y eli seinän paksuus kertaa leveys
planks = 50;      // Lautojen määrä

// CONSTANTS:
// plank = [42,140]; // X, Y eli seinän paksuus kertaa leveys
// planks = 42;      // Lautojen määrä

// Fix manifold by adding a bit overlap to model
manifold_fix = 0.1; 

perimeter = planks*plank[1];
angle = 360/planks;
apothema = plank[1] / (2 * tan(180/planks));

echo("Angle between planks: ", angle, " degrees");
echo("Apothema: ", apothema, " mm");

cut = plank[1]/2 - (1-plank[0]/apothema)*(plank[1]/2);

echo("Inside plank width: ", plank[0]-2*cut, " mm");

polygon = [ [ 0, -plank[1]/2 ],
            [ 0, plank[1]/2 ],
            [ -plank[0], plank[1]/2-cut+manifold_fix ],
            [ -plank[0], -plank[1]/2+cut ]
          ];
echo("Plank is: ", polygon);

for (item = [0:planks-1]) {
    x = apothema * cos(item * angle);
    y = apothema * sin(item * angle);
    
    translate([x,y,0]) {
        rotate(item*angle) {
            linear_extrude(height = 1000) {
                polygon(polygon);
            }
        }
    }    
}
