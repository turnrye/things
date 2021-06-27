/* [View configuration] */
display="all"; //[all:whole assembly, bottom_end_piece:bottom end piece, center_piece: center piece, top_end_piece:top end piece, top_cap:top cap]

/* [Your hardware] */

// Outside diameter of the pipe you will use for the main vertical piece; defaults to 1" PVC; 1.315*2.54*10
center_pipe_diameter = 33.401;


// Outside diameter of the pipe you will use for the arms; defaults to 3/4" PVC; 1.050*2.54*10
arm_pipe_diameter = 26.67; 

// Pick a variant: contunous center pipe, or where it is split into two sections (upper and lower)
continuous_center_pipe = true;

// Outside diameter of your coax, used to create channels for it to pass through
coax_diameter = 10.0; 


// This is for the QFH calculator taken from http://www.jcoppens.com/ant/qfh/calc.en.php; bitly URL provided just to make it easier to read in the customizer UI
/* [Outputs of the QFH calculator https://bit.ly/3djaY04] */
H1 = 711.3;
Di1 = 305.9;
D1 = 312.9;
Dc1 = 282.9;

H2 = 676.3;
Di2 = 290.6;
D2 = 297.6;
Dc2 = 267.6;

// These values are user-configurable, though the defaults should be OK
min_printed_wall_thickness = 4*0.4;
printed_wall_thickness = min_printed_wall_thickness+Dc1/40;
end_piece_collar_height = 1*25.4;
side_piece_collar_height = 1*25.4;
coax_channel_radius = coax_diameter/2*1.2+2;

module __Customizer_Limit__ () {}

// DONT EDIT BELOW THIS LINE

arm_length = center_pipe_diameter+printed_wall_thickness*2+side_piece_collar_height*2;
arm_radius = arm_pipe_diameter/2+printed_wall_thickness;

// Components
module center_column(h) {
    difference() {
        cylinder(h=h, r=center_pipe_diameter/2+printed_wall_thickness);
        cylinder(h=h, r=center_pipe_diameter/2);  
    }
}

module side_arm_support(width) { // Width would be Dc or D depending on end vs middle
    h = center_pipe_diameter + 2*(printed_wall_thickness + end_piece_collar_height);
    difference() {
        cylinder(h=width, r=arm_radius);
        cylinder(h=width, r=arm_radius-printed_wall_thickness);  
    }    
}

// Pieces
/* 
The top end piece is where the electrical connection takes place. There is a plug that goes over the top once it is assembled.
*/
// TODO: I don't knkow that the distance between the two pipes is necessarily right. Today it's configured at the minimum possible, but this is probably not a safe assumption; it needs to account for the differences between H1 and H2.
module top_end_piece() {
    end_piece_height = H1 - H2 + end_piece_collar_height+arm_pipe_diameter + printed_wall_thickness;
    difference() {
        union () { 
            center_column(end_piece_height);
            
            translate([0, arm_length/2, arm_radius]) rotate([90,0,0]) side_arm_support(arm_length);
            translate([-arm_length/2,0, arm_radius+arm_pipe_diameter]) rotate([90,0,90]) side_arm_support(arm_length);
        }
         translate([0, arm_length/2, arm_radius]) rotate([90,0,0]) cylinder(r=coax_channel_radius, h=arm_length);
         translate([-arm_length/2,0, arm_radius+arm_pipe_diameter]) rotate([90,0,90]) cylinder(r=coax_channel_radius, h=arm_length);
         cylinder(r=coax_channel_radius*1.5
        , h=end_piece_height);
    }
}
/*
The bottom end piece is where the antenna ends; coax passes through its z axis into the arm of the antenna mast; it is literally a copy of the top but has an additional collar added on the bottom since there is a pipe section below for mounting
*/
module bottom_end_piece() {
    end_piece_height = H1 - H2 + end_piece_collar_height+arm_pipe_diameter + printed_wall_thickness+end_piece_collar_height;
    difference() {
        union () {
            translate([0,0,-end_piece_collar_height]) center_column(end_piece_collar_height);
            
            top_end_piece();
        }
         cylinder(r=coax_channel_radius*1.5
        , h=end_piece_height);
    }
}

module center_piece() {
    end_piece_height = continuous_center_pipe ? arm_radius*2 : arm_radius*2+end_piece_collar_height*2;
    end_piece_offset = continuous_center_pipe ? [0,0,0] : [0,0,-end_piece_collar_height];
    difference() {
        union () { 
            translate(end_piece_offset) center_column(end_piece_height);
            
            translate([0, arm_length/2, arm_radius]) rotate([90,0,0]) side_arm_support(arm_length);
            translate([-arm_length/2,0, arm_radius]) rotate([90,0,90]) side_arm_support(arm_length);
        }
         translate([0, arm_length/2, arm_radius]) rotate([90,0,0]) cylinder(r=coax_channel_radius, h=arm_length);
         translate([-arm_length/2,0, arm_radius]) rotate([90,0,90]) cylinder(r=coax_channel_radius, h=arm_length);
         cylinder(r=coax_channel_radius*1.5
        , h=end_piece_height);
        if(continuous_center_pipe) {
            cylinder(h=end_piece_height, r=center_pipe_diameter/2);
        }
    }
}
/*
This is a rain cover for the top of the assembly; it should be printed with the large cylinder on the print bed to try to get the best seal possible; 
paint might be advised as well to try to close any pores or seams
*/
module top_cap() {
    union() {
        cylinder(r=center_pipe_diameter/2+printed_wall_thickness+1, h=4);
        translate([0,0,-4]) difference() {
            cylinder(r=center_pipe_diameter/2, h=4);
            cylinder(r=center_pipe_diameter/2-printed_wall_thickness, h=4);
        }
    }
}

/*
The entire assembly
*/
module antenna() {
    bottom_end_piece();
    // TODO: put this in the right place Z-wise
    translate([0,0,H1/2]) translate([0,0,arm_pipe_diameter + printed_wall_thickness*2]) center_piece();
    translate([0,0,H1]) translate([0,0,arm_pipe_diameter + printed_wall_thickness*2]) rotate([180,0,0]) top_end_piece();
    translate([0,0,H1]) translate([0,0,arm_pipe_diameter + printed_wall_thickness*2]) top_cap();
    // TODO: display the PVC pipes in a different color
}
if(display == "all") {
    antenna();
} else if(display == "top_cap") {
    top_cap();
} else if(display == "top_end_piece") {
    top_end_piece();
} else if(display == "bottom_end_piece") {
    bottom_end_piece();
} else if(display == "center_piece") {
    center_piece();
}