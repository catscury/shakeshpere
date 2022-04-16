use <motor.scad>
use <battery_case.scad>
use <battery_lr54.scad>

debug = ["SphereLowPart"];

$fn=100;
wall = 11;
sphere_d = get_motor_property("FullLength");
motor_length = get_motor_property("MotorL");

eps_motor_d = 0.4;
eps_motor_l = 0.8;
eps_excentric_d = 1;
eps_excentric_l = 1;
wire_d = 1.6;
small_wire_d = 0.8;

motor_offset = -motor_length/2;

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
    battery_case_part = GetBatteryCaseProperty("Box");
    translate([motor_offset-(eps_motor_l)/2,0,0])
        rotate([0,90,0])
        motor_asm([eps_motor_d, eps_motor_l],
                  [eps_excentric_d, eps_excentric_l], true);
    translate([0,sphere_d/4+2,0]) {
        rotate([90,90,0])
            battery_case();
        translate([0,0,1])
            rotate([90,0,0]) {
            battery_lr54();
        }
    }
    rotate([0,0,180])
    translate([0,sphere_d/4+2,0]) {
        rotate([90,90,0])
            battery_case();
        translate([0,0,1])
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

    add_eps = 0.8;
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

module SphereLowPart() {
    difference() {
        HalfSphere();
        InsideHoles();
        Wires();
    }
}

module Sphere() {

}



for(val = debug) {
    if(val == "Sphere")
        Sphere();
    if(val == "SphereLowPart")
        SphereLowPart();
    if(val == "Motor")
        Motor_Placed();
}
