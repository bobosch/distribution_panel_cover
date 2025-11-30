/* [Dimension] */
// Height
outer_height = 279;
// Width
outer_width = 247;
// Depth
outer_depth = 58;
// Wall thickness
wall = 3.0; // 0.1

/* [Cable cut] */
// Cable cut height
cut_height = 146;
// Cable guide x position
cut_pos_x = 2.5; // 0.1
// Cable guide z position
cut_pos_z = 115;

/* [Rows] */
// Number of units
units = 10;
// Left position
rows_pos_x = 11;
// Row 1 z position
row1_pos_z = 62;
// Row 2 z position
row2_pos_z = 172;

/* [Locks] */
lock_pos_l = 13;
lock_pos_r = 56;
lock_pos_t = 10;
lock_pos_b = 10;
four_lock = true;

/* [Print] */
stabilize_x = 1.5; // 0.1

/* [Hidden] */
$fn=30;

union() {
    difference() {
        box();
        translate([rows_pos_x, 0, row1_pos_z]) row();
        if(row2_pos_z) translate([rows_pos_x, 0, row2_pos_z]) row();
        translate([0, 11, cut_pos_z]) cable_cut(cut_height);
        translate([outer_width - wall, 11, cut_pos_z]) cable_cut(cut_height);
        // Locks
        translate([lock_pos_l, 0, lock_pos_b]) rotate([-90, 0, 0]) cylinder(5, 7, 7);
        if(four_lock) translate([outer_width - lock_pos_r, 0, lock_pos_b]) rotate([-90, 0, 0]) cylinder(5, 7, 7);
        translate([outer_width - lock_pos_r, 0, outer_height - lock_pos_t]) rotate([-90, 0, 0]) cylinder(5, 7, 7);
        if(four_lock) translate([lock_pos_l, 0, outer_height - lock_pos_t]) rotate([-90, 0, 0]) cylinder(5, 7, 7);
    }
    translate([cut_pos_x, 0, cut_pos_z]) cable_holder(cut_height);
    translate([outer_width - cut_pos_x - 1.5, 0, cut_pos_z]) cable_holder(cut_height);
    // Locks
    translate([lock_pos_l, 0, lock_pos_b]) rotate([-90, -90, 0]) lock();
    if(four_lock) translate([outer_width - lock_pos_r, 0, lock_pos_b]) rotate([-90, 180, 0]) lock();
    translate([outer_width - lock_pos_r, 0, outer_height - lock_pos_t]) rotate([-90,  90, 0]) lock();
    if(four_lock) translate([lock_pos_l, 0, outer_height - lock_pos_t]) rotate([-90,   0, 0]) lock();
    
    if(row2_pos_z && stabilize_x) {
        translate([wall, 0, row1_pos_z + 46 + 20]) cube([outer_width - 2*wall, 10, stabilize_x]);
        translate([wall, 0, row2_pos_z - 38 - stabilize_x]) cube([outer_width - 2*wall, 10, stabilize_x]);
    }
}

module box() {
    difference() {
//        cube([outer_width, outer_depth, outer_height]);
        roundedcube_simple(size = [outer_width, outer_depth, outer_height], radius = 1.5);
        translate([wall, wall, wall]) cube([outer_width - 2*wall, outer_depth, outer_height - 2*wall]);
    }
}

module row() {
    cube([units * 18, outer_depth, 46]);
}

module cable_cut(height) {
    cube([wall, 47, height]);
}

module cable_holder(height) {
    translate([0, 0, -3]) difference() {
        cube([1.5, outer_depth, height + 6]);
        translate([0, 15, 7]) cube([1.5, 43, height - 8]);
    }
}

module lock() {
    lock1975();
}

module lock1975() {
o1 = 8.9;
i1 = 7.0;
o2 = 4.9;
i2 = 2.9;
o3 = 4.7;
i3 = 2.9;
    difference() {
        union() {
            cylinder(5, o1, o1);
            translate([0, 0, 5]) cylinder(4, o1, o2);
            translate([0, 0, 9]) cylinder(17, o2, o3);
        }
        cylinder(5, i1, i1);
        translate([0, 0, 5]) cylinder(4, i1, i2);
        translate([0, 0, 9]) cylinder(17, i2, i3);

        translate([-2.8, 0, 0]) cube([5.6, 6.8, 22]);
        translate([-5, 2.1, 9]) cube([10, 4, 17]);
    }
}

module roundedcube_simple(size = [1, 1, 1], center = false, radius = 0.5) {
    // If single value, convert to [x, y, z] vector
    size = (size[0] == undef) ? [size, size, size] : size;

    translate = (center == false) ?
        [radius, radius, radius] :
        [
            radius - (size[0] / 2),
            radius - (size[1] / 2),
            radius - (size[2] / 2)
    ];

    translate(v = translate)
    minkowski() {
        cube(size = [
            size[0] - (radius * 2),
            size[1] - (radius * 2),
            size[2] - (radius * 2)
        ]);
        sphere(r = radius);
    }
}