module plater(diameter = 100, angleOfLip = 60, lengthOfLip = 16, wallThickness = 3, lipWallThickness = 1.5) {
    radius = diameter / 2;
    rotate_extrude() mainPlaterShape(); 

    module mainPlaterShape() {
        square([radius, wallThickness], center = false);
        translate([radius, 0, 0]) rotate([0, 0, angleOfLip]) square([lengthOfLip, lipWallThickness], center = false);
    }
}