/*
 * Calculate apothem of polygon
 *
 *   sides: Number of sides in polygon (the "n" in "n-gon")
 *   length: Length of one side in polygon
 *
 * See: https://en.wikipedia.org/wiki/Apothem
 */
function apothem(sides, length) = length / (2 * tan(180/sides));

/*
 * Calculate circumradius of polygon
 *
 *   sides: Number of sides in polygon (the "n" in "n-gon")
 *   length: Length of one side in polygon
 *
 * See: https://en.wikipedia.org/wiki/Regular_polygon#Circumradius
 */
function circumradius(sides, length) = length/ (2 * sin(180/sides));


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
    apothema = apothem(planks_num, plank_size[1]);
    angle = 360 / planks_num;
    cut = plank_size[1]/2 - (1-plank_size[0]/apothema)*(plank_size[1]/2);

    outside_perimeter = planks_num * plank_size[1];
    outside_area = 0.5 * apothema/1000 * outside_perimeter/1000; // Meters^2

    inside_perimeter = planks_num * (plank_size[1] - 2*cut);
    inside_area = 0.5 * apothema/1000 * inside_perimeter/1000; // Meters^2
    inside_volume = inside_area * height/1000; // Meters^3

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
    echo("  Inside area of barrel: ", inside_area, " m^2");
    echo("  Outside area of barrel: ", outside_area, " m^2");
    echo("  Inside volume of barrel: ", inside_volume, " m^3");

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


/*
 * Generate floor of barrel
 *
 *   planks_num: Number of planks used for barrel sides
 *   plank_size: Plank side used for barrel sides
 *
 *   All values should be given in mm.
 */

module barrel_floor(planks_num, plank_size) {
    width = plank_size[1];
    heigth = plank_size[0]; // Thickness of floor

    apothema = apothem(planks_num, width);
    circumradius = circumradius(planks_num, width);
    planks = ceil(circumradius / width);

    polygon = [ [ -width/2, -circumradius],
                [ width/2, -circumradius],
                [ width/2, circumradius],
                [ -width/2, circumradius] ];

    for (item = [-planks:planks]) {
        x = width*item;
        z = heigth/2;
        intersection() {
            translate([x,0,z]) {
                linear_extrude(height = heigth) {
                    polygon(polygon);
                }
            }
            cylinder(h=heigth+z, r=apothema, center=false);
        }
    }
}
