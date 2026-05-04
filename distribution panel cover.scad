/* [Dimension] */
// Height
outer_height = 279;
// Width
outer_width = 247;
// Depth
outer_depth = 58;
// Wall thickness
wall = 2.5; // 0.1

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
lock_type = 1975; // [1975, 1982]
four_lock = true;

/* [Stabilizers] */
stabilize_x_pos = [0, 0]; // 0.1
stabilize_z_pos = [0, 0]; // 0.1
stabilize_width = 1.5;
stabilize_height = 2.5;
stabilize_fix_width = 3;
stabilize_fix_depth = 4;
stabilize_z_fix_t = false;
stabilize_z_fix_b = false;

/* [Print] */
print_stabilize_x = 1.5; // 0.1

/* [Hidden] */
$fn=90;

union() {
    difference() {
        box();
        translate([rows_pos_x, 0, row1_pos_z]) row();
        if(row2_pos_z) translate([rows_pos_x, 0, row2_pos_z]) row();
        // Cable cut
        if(cut_height) {
            translate([0, 11, cut_pos_z]) cable_cut(cut_height);
            translate([outer_width - wall, 11, cut_pos_z]) cable_cut(cut_height);
        }
        // Locks
        translate([lock_pos_l, 0, lock_pos_b]) rotate([-90, 0, 0]) cylinder(h = 5, r = lock_hole());
        if(four_lock) translate([outer_width - lock_pos_r, 0, lock_pos_b]) rotate([-90, 0, 0]) cylinder(h = 5, r = lock_hole());
        translate([outer_width - lock_pos_r, 0, outer_height - lock_pos_t]) rotate([-90, 0, 0]) cylinder(h = 5, r = lock_hole());
        if(four_lock) translate([lock_pos_l, 0, outer_height - lock_pos_t]) rotate([-90, 0, 0]) cylinder(h = 5, r = lock_hole());
    }
    // Cable cut
    if(cut_height) {
        translate([cut_pos_x, 0, cut_pos_z]) cable_holder(cut_height);
        translate([outer_width - cut_pos_x - 1.5, 0, cut_pos_z]) cable_holder(cut_height);
    }
    // Locks
    translate([lock_pos_l, 0, lock_pos_b]) rotate([-90, -90, 0]) lock();
    if(four_lock) translate([outer_width - lock_pos_r, 0, lock_pos_b]) rotate([-90, 180, 0]) lock();
    translate([outer_width - lock_pos_r, 0, outer_height - lock_pos_t]) rotate([-90,  90, 0]) lock();
    if(four_lock) translate([lock_pos_l, 0, outer_height - lock_pos_t]) rotate([-90,   0, 0]) lock();
    // Stabilizer
    for (i = [0 : len(stabilize_x_pos) - 1]) if(stabilize_x_pos[i]) translate([0, wall, stabilize_x_pos[i]]) cube([outer_width, stabilize_height, stabilize_width]);
    // Print stabilizer
    if(row2_pos_z && print_stabilize_x) {
        translate([wall, 0, row1_pos_z + 46 + 20]) cube([outer_width - 2*wall, 10, print_stabilize_x]);
        translate([wall, 0, row2_pos_z - 38 - print_stabilize_x]) cube([outer_width - 2*wall, 10, print_stabilize_x]);
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

function lock_hole() = (lock_type == 1982) ? lock1982_hole() : lock1975_hole();
module lock() {
    if (lock_type == 1982) lock1982();
    else lock1975();
}

function lock1975_hole() = 14/2;
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

function lock1982_hole() = 15.3/2;
module lock1982() {
    o1 = 19/2;
    i1 = 15.3/2;
    h1 = 6;
    o2 = 17/2;
    i2 = 12.4/2;
    h2 = 11;
    difference() {
        union() {
            cylinder(h = h1, r = o1);
            translate([0, 0, h1]) cylinder(h2, o1, o2);
        }
        cylinder(h = h1, r = i1);
        translate([0, 0, h1]) cylinder(h = h2, r = i2);
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