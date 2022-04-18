debug = ["Asm"];

default_gaps=[0.4,0.4,0.4];

module snap_fit_connector(snap_box = [5,5,5], edge_offset=2, surface_height=7,
                          foot_height=10, angle=45,
                          draw_foot=true, draw_surface=true, 
                          gaps=[undef, undef, undef], foot_length=undef) {

    foot_length = foot_length == undef ? edge_offset : foot_length;
    gaps = [for(i=[0:(len(default_gaps)-1)]) gaps[i] == undef ?
                                                 default_gaps[i] : gaps[i]];
    side1_low = snap_box[0]-edge_offset;
    side1_up = snap_box[0]-foot_length;
    snap_head_up = (side1_low-side1_up)*tan(angle);
    foot_height = foot_height;
    side2 = tan(angle)*side1_low;
    assert(side1_low >= 0);
    assert(side2 <= snap_box[1]);

    module snap_fit_head() {
        snap_box = [snap_box[0], snap_box[2], snap_box[1]];
        render()
            rotate([-90, 0, 180]) {
            difference() {
                cube(snap_box, center=true);
                translate([-snap_box[0]/2,snap_box[1]/2-side2,-snap_box[2]/2])
                    linear_extrude(snap_box[2])
                    polygon(points=[[0,0],
                                    [0,side2+0.001],
                                    [side1_low,side2]]);
            }
        }
    }
    module snap_fit_foot() {
        translate([0,0,snap_box[2]+foot_height/2]) {
            cube([foot_length, snap_box[1], foot_height], center=true);
            translate([(snap_box[0]-foot_length)/2,
                       0,
                       -(foot_height+snap_box[2])/2])
                snap_fit_head();
        }
    }

    hole_clap_l = side1_up;
    head_offset = (snap_box[0]+foot_length)/2+gaps[0];

    surface_size = [snap_box[0]+foot_length+hole_clap_l+gaps[0],
                    snap_box[1]+2*gaps[1],
                    surface_height];

    module snap_surface_solid() {
        translate([(surface_size[0]-foot_length)/2-hole_clap_l,
                   0,
                   surface_height/2])
            cube(surface_size, center=true);
    }

    foot_z_offset = surface_height-snap_box[2]-gaps[2]-snap_box[2]+snap_head_up;

    module snap_surface() {
        module snap_head_place() {
            translate([head_offset,
                       0,
                       snap_head_up+surface_height-snap_box[2]/2])
                rotate([0,180,0])
                snap_fit_head();
        }

        difference() {
            snap_surface_solid();
            for(i = [0, gaps[0], -hole_clap_l], j = [-gaps[0], gaps[0]])
                translate([i,j,0])
                    linear_extrude(surface_height)
                    projection()
                    snap_fit_foot();
            translate([0,0,-foot_z_offset])
                snap_head_place();
        }
        module snap_head_up_cutted() {
            difference() {
                for(j = [-gaps[1], gaps[1]])
                    translate([0,j,-foot_z_offset ])
                        snap_head_place();
                difference() {
                    for(j = [-gaps[1], gaps[1]])
                        translate([0,j,-foot_z_offset ])
                            snap_head_place();
                    snap_surface_solid();
                }
            }
        }
        snap_head_up_cutted();
    }

    if(draw_foot)
        snap_fit_foot();
    if(draw_surface)
        snap_surface();
    if(!draw_surface && !draw_foot)
        snap_surface_solid();
}


for(val = debug){
    front_foot_width = 1.5;
    snapfit_box = [1.7*front_foot_width,
                   5,
                   front_foot_width];
    snapfit_edge_offset = front_foot_width*0.8;
    //snapfit_gaps = [3*0.1, 3*0.1, 3*0.1];
    snapfit_gaps = [0,0,0];
    snapfit_angle=35;
    snapfit_foot_height = 5;

    if(val == "Asm")
        snap_fit_connector(snapfit_box, snapfit_edge_offset, 3,
                           snapfit_foot_height,snapfit_angle,
                           gaps=snapfit_gaps,
                           foot_length=front_foot_width);
    if(val == "Connector")
        snap_fit_connector(draw_surface=false);
    if(val == "Socket")
        snap_fit_connector(draw_foot=false);
}
