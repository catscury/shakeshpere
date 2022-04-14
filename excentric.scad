use <motor.scad>

debug = ["excentric"];
$fn=100;

eps_h = get_motor_property("ExcentricEpsH");
r = 4;
h = get_motor_property("AxleH")-eps_h;
hole_d = 0.8;

module connector(eps) {
    difference() {
        cylinder(d=4*hole_d, h=h+eps[1], center=true);
        cylinder(d=hole_d, h=h+eps[1], center=true);
    }
}

module excentric(eps, solid) {
    patch_r = r + eps[0];
    patch_h = h + eps[1];
    translate([0,0,patch_h/2]) {
        difference() {
            cylinder(r=patch_r, h=patch_h, center=true);
            if(!solid) {
                translate([r,0,0])
                    cube([2*patch_r,2*patch_r,patch_h],center=true);
                cylinder(d=hole_d, h=patch_h, center=true);
            }
        }
        connector(eps);
    }
}


for(val = debug) {
    if(val == "excentric")
        excentric();
}
