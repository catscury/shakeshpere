use <excentric.scad>

debug = ["asm"];

$fn=100;
motor_l = 11.8;
motor_d = 4;
front_circle_h = 0.7;
front_circle_d = 1.5;
axle_d = 0.4;
axle_h = 2.5;

excentric_eps_h = 0.4;

wire_h = 0.7;

function get_motor_property(which) =
    which == "MotorL" ? motor_l :
    which == "MotorD" ? motor_d :
    which == "FrontCircleH" ? front_circle_h :
    which == "FrontCircleD" ? front_circle_d :
    which == "AxleD" ? axle_d :
    which == "AxleH" ? axle_h :
    which == "ExcentricEpsH" ? excentric_eps_h :
    which == "FullLength" ? motor_l+front_circle_h+excentric_eps_h+axle_h:
    which == "WireH" ? wire_h :
    assert(false, str("motor haven't property ", which));


module motor(eps) {
    cylinder(d = motor_d+eps[1], h = motor_l+eps[0]);
    translate([0,0,motor_l+eps[0]]) {
        cylinder(d = front_circle_d+eps[1], h = front_circle_h);
        translate([0,0,front_circle_h])
            cylinder(d = axle_d+eps[1], h = axle_h+eps[0]/2);

    }
}

module motor_asm(eps_motor = [0,0], eps_exc = [0,0], solid = false ) {
    motor(eps_motor);
    translate([0,0,motor_l+front_circle_h+excentric_eps_h])
        excentric(eps_exc, solid);

}


for(val = debug) {
    if(val == "motor")
        motor();
    if(val == "asm")
        motor_asm();
}
