// holes are 75 x 97 mm offset
// M3 holes so 2.7mm for 

module hole() {
    m3_tap_diameter = 2.7;
    m3_tap_length = 8;
    wall_thickness=2;
    difference() {
        cylinder(r=m3_tap_diameter/2+wall_thickness,h=m3_tap_length);
        cylinder(r=m3_tap_diameter/2,h=m3_tap_length);
    }
}
hole();
translate([75,0,0]) hole();
translate([75,97,0]) hole();
translate([0,97,0]) hole();