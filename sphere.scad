use <motor.scad>

debug = ["SphereLowPart", "Motor"];

$fn=100;
wall = 4;
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

module SphereLowPart() {
    difference() {
        HalfSphere();
        translate([-sphere_d/2-(eps_motor_l)/2,0,0])
            rotate([0,90,0])
            motor_asm([eps_motor_d, eps_motor_l],
                      [eps_excentric_d, eps_excentric_l], true);
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
