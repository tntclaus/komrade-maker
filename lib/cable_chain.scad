include <NopSCADlib/core.scad>

/**
* STL helper
*/
module cable_chain_section_body_and_cap(l, w, h) {
    $fn = 90;
    translate([0,0,h/2]) {
            translate([0, - l, -h+1.5])
            rotate([0, 0, 0])
                cable_chain_section_cap(l, w, h);

        cable_chain_section_body(l, w, h);
    }
}

module cable_chain_section(l, w, h, color = "yellow") {
    name = str("ABS_cable_chain_section_body_and_cap_",
    "l", l, "w", w, "h", h
    );
    stl(name);

    color("blue")
    render()
    cable_chain_section_cap(l, w, h);

    color(color)
    render()
    cable_chain_section_body(l, w, h);
}

module cable_chain_section_cap(l, w, h, expansion = 0) {
    translate([0,l/12,h/2-1/2-.25]) {
            cube([w-6, l / 3, 1.5+expansion], center = true);
            cube([w-3+expansion*10, l / 3 / 2, 1.5+expansion], center = true);
    }
}

module cable_chain_section_body(
    l, w, h,
    d_cooler = 24.5,
    d_blower1 = 4.5
) {
    module ear_mount() {
        translate_z(h/2)
        cube([3.2, h/2, h/2], center = true);
        translate_z(-h/2)
        cube([3.2, h/2, h/2], center = true);
        rotate([0, 90, 0])
            difference() {
                cylinder(d = h+.2, h = 3.2, center = true);
                cylinder(d = 3, h = 4, center = true);
            }
    }
    difference() {
        union() {
            hull() {
                cube([w, l, h], center = true);

                translate([0, l / 2, 0])
                    rotate([0, 90, 0])
                        cylinder(d = h, h = w, center = true);

                translate([0, - l / 2 + h / 4, 0])
                    rotate([0, 90, 0])
                        cylinder(d = h, h = w, center = true);
            }
            translate([0, -l / 2, 0])
            rotate([0, 90, 0])
            cylinder(d = 3, h = w+1, center = true);
        }

        translate([0, l / 2, 0])
            rotate([0, 90, 0])
                cylinder(d = 3.5, h = w*2, center = true);

//        translate([0, l / 3, 1])
//            cube([w - 4, l, h], center = true);


        translate([0, l * 0.8, 0])
            cube([w - 3.1, l, h*2], center = true);

        translate([0, 0, 2])
            cube([w - 6, l*2, h], center = true);

        translate([-w/2, -l / 2, 0])
            ear_mount();
        translate([w/2, -l / 2, 0])
            ear_mount();

        translate_z(-1.5)
        cable_chain_section_cap(l, w, h, expansion = 1);
    }

    module attach_coil(d) {
        difference() {
            hull() {
                cylinder(d = d + 4, h = 2, center = true);
                translate([0,-d/2-2,-1])
                    cube([d/2,d/2, 2]);
            }
            cylinder(d = d, h = 5, center = true);
            translate([-d/4,-d/6,-d/2])
                cube([d,d*2,d]);
        }
    }

    if(d_cooler > 0) {
        translate([-d_cooler/2-w/2,0,d_cooler/2+2-h/2])
        rotate([90,0,0])
            attach_coil(d = d_cooler);
    }

    if(d_blower1 > 0) {
        translate([d_blower1/2+w/2,0,d_blower1/2+2-h/2])
            mirror([1,0,0])
            rotate([90,0,0])
                attach_coil(d = d_blower1);
    }

}

module cable_chain(type) {
    l = 30;
    w = 30;
    h = 16;

    module rotated_section(angle = 0, color = "yellow") {
        rotate([angle,0,0])
            translate([0, l/2,0])
            cable_chain_section(l = l, w = w, h = h, color = color);

        rotate([angle,0,0])
        translate([0,l,l*sin(angle)])
                children();
    }

        rotated_section(color = "green")
        rotated_section(angle=0)
        rotated_section(angle=0, color = "blue");
}

//cable_chain([]);

//color("blue")
//render()
//cable_chain_section_body_and_cap(l = 30, w = 30, h = 16);
cable_chain_section_body(l = 30, w = 30, h = 16);


//cube([10,10,10]);
