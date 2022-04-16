use <motor.scad>
use <battery_case.scad>
use <battery_lr54.scad>

debug = ["SphereLowPart"];

$fn=100;
wall = 9;
sphere_d = get_motor_property("FullLength");

eps_motor_d = 0.4;
eps_motor_l = 0.8;
eps_excentric_d = 1;
eps_excentric_l = 1;

module HalfSphere(down = true) {
    difference() {
        sphere(d=sphere_d+wall);
        translate([0,0,(down ? 1 : -1)*(sphere_d+wall)/2])
            cube([sphere_d+wall, sphere_d+wall, sphere_d+wall],center=true);
    }
}

module Motor_Placed() {
    translate([-sphere_d/2,0,0])
        rotate([0,90,0])
        motor_asm();
}

module InsideHoles() {
    battery_case_part = GetBatteryCaseProperty("Box");
    translate([-sphere_d/2.5-(eps_motor_l)/2,0,0])
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

module SphereLowPart() {
    difference() {
        HalfSphere();
        InsideHoles();
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
