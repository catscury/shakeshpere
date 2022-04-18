debug = ["battery_case"];

$fn=100;

left_box = [8.9,9.9,1.1];
left_pin = [4,2.5,0.2];

right_box = [8.9,9.9,1];
right_pin = [4,2.5,0.2];
right_button_d = 6.2;
right_button_h = 1.5;

battery_h = 3;

function GetBatteryCaseProperty(which) =
    which == "Box" ? left_box :
    which == "Width" ? left_box[2]+right_button_h+battery_h:
    assert(false, str("BatteryCase haven't property ", which));

module left_connector() {
    cube(left_box);
    translate([left_box[0],(left_box[1]-left_pin[1])/2,0])
        cube(left_pin);
}

module right_connector() {
    cube(right_box);
    translate([right_box[0],(right_box[1]-right_pin[1])/2,0])
        cube(right_pin);
    translate([right_box[0]/2,right_box[1]/2,0])
        cylinder(d=right_button_d, h=right_button_h);
}

module battery_case(battery_h = 3) {
    offset_y = (right_button_h-left_box[2])/2;
    translate([0,0,offset_y]) {
    translate([-left_box[0]/2,-left_box[1]/2,
               -right_button_h-battery_h/2]) {
        right_connector();
        translate([0,0,right_button_h+battery_h])
            left_connector();
    }
    }

}

for(val = debug) {
    if(val == "left_connector") {
        left_connector();
    }
    if(val == "right_connector") {
        right_connector();
    }
    if(val == "battery_case") {
        battery_case();
    }
}
