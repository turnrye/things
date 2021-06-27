/*
Use demo(); to see the full part

To print: 
- export one STL of mounting_blank() and print 2x
- export one STL of mounting_plate() and print 1x
*/

$fn=70;
front_panel_thickness = 3;
part_width = 23.2 + 50;
part_height = 50;

tabs_height = 15; //how tall are they when oriented in the car
tabs_depth = 15; // how far do they stick out into the car; z axis
space_between_tabs = 33+front_panel_thickness;

screw_hole_diameter = 4.2;

hole_tap_size=4.8;
hole_clearance_size=5.2;
hole_shell=3;
screw_depth=8;

gap_between_blanks = 50;

the_x_factor=33;

module mounting_blank() {
    difference() {
        union() {
            translate([15.1,8.5,0]) import("2nd_Gen_Tacoma_Switch_Blank_Center_Console.stl");
            translate([11.6,8.95,3.9]) cylinder(r=hole_tap_size/2+hole_shell,h=screw_depth);
            translate([11.6,25.05,3.9]) cylinder(r=hole_tap_size/2+hole_shell,h=screw_depth);
        }
        translate([11.6,8.95,0]) cylinder(r=hole_tap_size/2,h=screw_depth+front_panel_thickness+5);
        translate([11.6,25.05,0]) cylinder(r=hole_tap_size/2,h=screw_depth+front_panel_thickness+5);
    }
}

module mounting_blank_cutout() {
    translate([11.6,8.95,0]) cylinder(r=hole_clearance_size/2,h=screw_depth+front_panel_thickness+5);
    translate([11.6,25.05,0]) cylinder(r=hole_clearance_size/2,h=screw_depth+front_panel_thickness+5);
}

module mounting_plate() {
    tab_edge_x = (part_width-space_between_tabs-front_panel_thickness)/2;
    tab_edge_y = part_height-tabs_height;
    difference() {
        union() {
            cube([part_width,part_height,front_panel_thickness]);
        
            translate([tab_edge_x,tab_edge_y,-tabs_depth]) difference() { 
                    union() {
                    translate([0,0,0]) cube([front_panel_thickness,tabs_height,tabs_depth]);
                    translate([space_between_tabs,0,0]) cube([front_panel_thickness,tabs_height,tabs_depth]);
                }
                translate([0,tabs_height/2,screw_hole_diameter]) rotate([0,90,0]) cylinder(r=screw_hole_diameter/2,h=space_between_tabs+2*front_panel_thickness);
            }
        }
            mounting_blank_cutout();
            translate([gap_between_blanks,0,0]) mounting_blank_cutout();
    }
    // Left tab triangle
    translate([tab_edge_x,tab_edge_y-tabs_depth,0]) rotate([0,90,0]) linear_extrude(height=front_panel_thickness) polygon(points=[[0,0],[0,tabs_depth],[tabs_depth,tabs_depth]]);
    translate([tab_edge_x-tabs_depth,tab_edge_y+front_panel_thickness,0]) rotate([90,90,0]) linear_extrude(height=front_panel_thickness) polygon(points=[[0,0],[0,tabs_depth],[tabs_depth,tabs_depth]]);
    translate([tab_edge_x-tabs_depth,part_height,0]) rotate([90,90,0]) linear_extrude(height=front_panel_thickness) polygon(points=[[0,0],[0,tabs_depth],[tabs_depth,tabs_depth]]);
    
    // Right tab triangle
    translate([tab_edge_x + space_between_tabs,tab_edge_y-tabs_depth,0]) rotate([0,90,0]) linear_extrude(height=front_panel_thickness) polygon(points=[[0,0],[0,tabs_depth],[tabs_depth,tabs_depth]]);
    translate([tabs_depth+tab_edge_x+front_panel_thickness+space_between_tabs,tab_edge_y,0]) rotate([-90,90,0]) linear_extrude(height=front_panel_thickness) polygon(points=[[0,0],[0,tabs_depth],[tabs_depth,tabs_depth]]);
    translate([tabs_depth+tab_edge_x+front_panel_thickness+space_between_tabs,part_height-front_panel_thickness,0]) rotate([-90,90,0]) linear_extrude(height=front_panel_thickness) polygon(points=[[0,0],[0,tabs_depth],[tabs_depth,tabs_depth]]);
}

module demo() {
    translate([0,0,front_panel_thickness]) union() {
        mounting_blank();
        translate([gap_between_blanks,0,0]) mounting_blank();
    }
    mounting_plate();
}

//demo();
//mounting_blank();
mounting_plate();
