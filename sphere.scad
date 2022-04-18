use <motor.scad>
use <battery_case.scad>
use <battery_lr54.scad>
use <snapfit.scad>

debug = ["SphereLowPart"];

$fn=100;
wall = 12.8;
sphere_d = get_motor_property("FullLength");
motor_length = get_motor_property("MotorL");
motor_d = get_motor_property("MotorD");

eps_motor_d = 0.4;
eps_motor_l = 0.8;
eps_excentric_d = 1;
eps_excentric_l = 1;
wire_d = 1.6;
small_wire_d = 0.8;
add_eps = 0.8;

motor_offset = -motor_length/2;

foot_length = 1.5;
foot_width = 2;
snap_shelf = 1;
sf_gaps = 0.4;
deep = 5;

offset_all_holes = [0,0,0];

battery_case_offset = (motor_d+eps_motor_d+GetBatteryCaseProperty("Width"))/2++add_eps;

module HalfSphere(down = true) {
    difference() {
        sphere(d=sphere_d+wall);
        translate([0,0,(down ? 1 : -1)*(sphere_d+wall)/2])
            cube([sphere_d+wall, sphere_d+wall, sphere_d+wall],center=true);
    }
}

module Motor_Placed() {
    translate([motor_offset+eps_motor_l/2,0,0])
        rotate([0,90,0])
        motor_asm();
}

module InsideHoles() {
    offset_y = 2;
    battery_case_part = GetBatteryCaseProperty("Box");
    translate([motor_offset-(eps_motor_l)/2,0,0])
        rotate([0,90,0])
        motor_asm([eps_motor_d, eps_motor_l],
                  [eps_excentric_d, eps_excentric_l], true);
    translate([0,battery_case_offset,0]) {
        rotate([90,90,0])
            battery_case();
        translate([0,0,0])
            rotate([90,0,0]) {
            battery_lr54();
        }
    }
    rotate([0,0,180])
        translate([0,battery_case_offset,0]) {
        rotate([90,90,0])
            battery_case();
        translate([0,0,0])
            rotate([90,0,0]) {
            battery_lr54();
        }
    }
}

module Wires() {
    trace_bus_l = 16;
    trace_motor_battery_l = 4;
    motor_battery_offset = -3.4;

    trace_motor_wire_l = 2.4;
    motor_r = get_motor_property("MotorD")/2;

    trace_battery_wire_l = 3.5;

    translate([motor_offset-wire_d-add_eps,-trace_bus_l/2,-wire_d])
        cube([wire_d,trace_bus_l,wire_d]);


    translate([motor_offset-wire_d-add_eps,
               motor_battery_offset-small_wire_d/2,
               -wire_d])
        cube([trace_motor_battery_l,small_wire_d,wire_d]);
    translate([motor_offset-wire_d-add_eps,
               -motor_battery_offset-small_wire_d/2,
               -wire_d])
        cube([trace_motor_battery_l,small_wire_d,wire_d]);

    translate([motor_offset-wire_d-add_eps,
               motor_r-small_wire_d/2,
               -wire_d])
        cube([trace_motor_wire_l,small_wire_d,wire_d]);
    translate([motor_offset-wire_d-add_eps,
               -motor_r-small_wire_d/2,
               -wire_d])
        cube([trace_motor_wire_l,small_wire_d,wire_d]);

    
    translate([motor_offset-wire_d-add_eps,
               -trace_bus_l/2-wire_d/2,
               -wire_d])
        cube([trace_battery_wire_l,wire_d/2,wire_d]);
    translate([motor_offset-wire_d-add_eps,
                trace_bus_l/2,
                -wire_d])
        cube([trace_battery_wire_l,wire_d/2,wire_d]);


}

module SnapFitPlaced1(surf = true, foot = false) {

    translate([motor_offset-foot_width/2-eps_motor_l/2
                -add_eps-wire_d,
               -(foot_length+sf_gaps)/2,-deep])
    rotate([0,0,90])
    snap_fit_connector(snap_box = [foot_length+snap_shelf,
                                   foot_width,
                                   foot_length],
                       edge_offset=foot_length,
                       surface_height=deep,
                       draw_foot=foot,
                       foot_height=deep-foot_length,
                       draw_surface=surf,
                       gaps=[sf_gaps,sf_gaps,sf_gaps]);
}


module SnapFitPlaced2(surf = true, foot = false) {
    translate([-(foot_length+sf_gaps)/2,
               foot_width/2+sf_gaps
               +battery_case_offset
               +GetBatteryCaseProperty("Width")/2,
               -deep])
        snap_fit_connector(snap_box = [foot_length+snap_shelf,
                                       foot_width,
                                       foot_length],
                           edge_offset=foot_length,
                           surface_height=deep,
                           foot_height=deep-foot_length,
                           draw_foot=foot,
                           draw_surface=surf);
}

module SnapfitPlacedAll(surf = true, foot = false) {
    SnapFitPlaced1(surf,foot);
    SnapFitPlaced2(surf,foot);
    mirror([90,0,0])
        mirror([0,90,0])
        SnapFitPlaced2(surf,foot);
}

module SphereLowPart() {
    difference() {
        HalfSphere();
        translate(offset_all_holes) {
            InsideHoles();
            Wires();
            SnapfitPlacedAll(false, false);
        }
    }
    translate(offset_all_holes)
        SnapfitPlacedAll();
}

module SphereHighPart() {
    difference() {
        HalfSphere(false);
        InsideHoles();
        mirror([0,90,0])
        mirror([0,0,90])
            SnapfitPlacedAll(false, false);
    }
    mirror([0,90,0])
    mirror([0,0,90])
        SnapfitPlacedAll();
}

module Sphere() {

}



for(val = debug) {
    if(val == "Sphere")
        Sphere();
    if(val == "SphereLowPart")
        SphereLowPart();
    translate([0,0,10])
    if(val == "SphereHighPart")
        SphereHighPart();
    if(val == "Motor")
        Motor_Placed();
}
