
/**
    Makes a right triangle with the desired side lengths and thickness (z)
    **** Deprecated
*/
module rightTriangle(horizontalLength, verticalLength, thickness) {
    hull() {
        cube([horizontalLength, thickness, 0.01]);
        cube([0.01, thickness, verticalLength]);
    }
}
module rightTriangle3d(a = 10, b = 10, length = 5) {
    echo("***** RightTriangle3d *****");
    echo("Length: ", length);
    translate([0, length, 0])  rotate([90, 0, 0]) linear_extrude(length) rightTriangle2d(a = a, b = b);
}

module rightTriangle2d(a = 10, b = 20) {
    echo("***** RightTriangle2d *****");
    points = [[0, 0], [a, 0], [0, b]];
    echo(str("Points: ", points,  ", a: ", a, ", b: ", b, ", c (calculated): ", c(a, b)));
    polygon(points = points);
}

//Equilateral Triangle
//size = 10;
//points = [[0, 0], [size, 0], [size / 2, size]];

// ======================== Functions ================

//Calculates the hyponetuse of a right triangle given the two sides a and b
function c(a, b) = sqrt(pow(a, 2) + pow(b, 2)); 

//rightTriangle2d(a = 10, b = 10);
rightTriangle3d(a = 10, b = 10, length = 20);