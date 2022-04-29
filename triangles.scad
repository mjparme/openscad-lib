
/**
    Makes a right triangle with the desired side lengths and thickness (z)
*/
module rightTriangle(horizontalLength, verticalLength, thickness) {
    hull() {
        cube([horizontalLength, thickness, 0.01]);
        cube([0.01, thickness, verticalLength]);
    }
}

// ======================== Functions ================

//Calculates the hyponetuse of a right triangle given the two sides a and b
function c(a, b) = sqrt(pow(a, 2) + pow(b, 2)); 