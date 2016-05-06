/*
 * Generate sides of barrel
 *
 *   planks_num: Number of planks to use
 *   plank_size: Dimensions of plank as vector of two values
 *               [thickness of wall, the other side]
 *   height:     Height of barrel
 *
 *   All values should be given in mm.
 */
module barrel_sides(planks_num, plank_size, height) {
    perimeter = planks_num * plank_size[1];
    angle = 360 / planks_num;
    apothema = plank_size[1] / (2 * tan(180/planks_num));
    cut = plank_size[1]/2 - (1-plank_size[0]/apothema)*(plank_size[1]/2);

    // Fix manifold by adding a bit overlap to model
    manifold_fix = 0.001;

    polygon = [ [ 0, -plank_size[1]/2 ],
                [ 0, plank_size[1]/2 ],
                [ -plank_size[0], plank_size[1]/2-cut+manifold_fix ],
                [ -plank_size[0], -plank_size[1]/2+cut ]
              ];

    echo("SIDES OF BARREL:");
    echo("  Angle between planks: ", angle, " degrees");
    echo("  Apothema: ", apothema, " mm");
    echo("  Inside plank width: ", plank_size[0]-2*cut, " mm");
    echo("  One plank is: ", polygon);

    for (item = [0:planks_num-1]) {
        x = apothema * cos(item * angle);
        y = apothema * sin(item * angle);

        translate([x,y,0]) {
            rotate(item*angle) {
                linear_extrude(height = height) {
                    polygon(polygon);
                }
            }
        }
    }
}
