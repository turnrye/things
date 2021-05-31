base=25;
hole=29;
depth=25;
wall_thickness=4;
base_thickness=10;
hold_diameter=6;

screw_head_diameter=9.2;
screw_head_height=5.2;

difference() {
union() {
translate([(0)/2,base/2,hole/2+base_thickness])
rotate([0,90,0]) 
difference() {
    cylinder(r=hole/2+wall_thickness,h=depth);
    cylinder(r=hole/2,h=depth);
    translate([-(hole)/2-wall_thickness,0,depth/2]) 
    rotate([0,90,0]) 
    cylinder(r=hold_diameter/2,h=hole+(wall_thickness*2));
    translate([0,hole/2+wall_thickness,depth/2]) 
    rotate([90,90,0]) 
    cylinder(r=hold_diameter/2,h=hole+(wall_thickness*2));
};

difference() {
    cube([base,base,base_thickness]);
    translate([base/2,base/2,0]) cylinder(r=5.4/2,h=base_thickness);
}
}
translate([base/2,base/2,base_thickness-screw_head_height]) cylinder(r=screw_head_diameter/2,h=screw_head_height+hole/2);
}