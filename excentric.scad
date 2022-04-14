use <motor.scad>

debug = ["excentric"];
$fn=100;

eps_h = get_motor_property("ExcentricEpsH");
r = 4;
h = get_motor_property("AxleH")-eps_h;
hole_d = 0.8;

module connector() {
    difference() {
        cylinder(d=4*hole_d, h=h, center=true);
        cylinder(d=hole_d, h=h, center=true);
    }
}

module excentric() {
    translate([0,0,h/2]) {
        difference() {
            cylinder(r=r, h=h, center=true);
            translate([r,0,0])
                cube([2*r,2*r,h],center=true);
            cylinder(d=hole_d, h=h, center=true);
        }
        connector();
    }
}


for(val = debug) {
    if(val == "excentric")
        excentric();
}
