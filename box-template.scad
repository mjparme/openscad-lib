use <cubes.scad>

module boxWithLid(length = 10, width = 10, height = 10, roundedRadius = 1, roundingShape = "sphere", lidHeight = 5, lidOffsetWidth = 1.5, 
    lidOffsetHeight = 5, lidSlop = 0.5, lidTopThickness = 2, hollow = false, wallThickness = 3, includeLid = true, roundedInterior = false, 
    roundedLidOffset = false, debug = false) {

    difference() {
        mainBoxShape();
        lidOffset();
    }

    echo("LidHeight: ", lidHeight);
    if (includeLid) {
        translate([0, width + 10, 0]) lid(length, width, lidHeight, roundedRadius, wallThickness, lidTopThickness, roundingShape, roundedLidOffset);
    }

    module mainBoxShape() {
        echo("RoundedRadius: ", roundedRadius);
        difference() {
            roundedCube(length = length, width = width, height = height, radius = roundedRadius, center = false, roundingShape = roundingShape);
            if (hollow) {
                hollowInterior();
            }
        }

        module hollowInterior() {
            hollowAreaLength = length - (2 * wallThickness);
            hollowAreaWidth = width - (2 * wallThickness);
            translate([wallThickness, wallThickness, wallThickness]) 
            if (roundedInterior) {
                roundedCube(length = hollowAreaLength, width = hollowAreaWidth, height = height, radius = roundedRadius, center = false, roundingShape = roundingShape);
            } else {
                cube([hollowAreaLength, hollowAreaWidth, height]);
            }
        }
    }

    module lidOffset() {
        //The lidOffset is a lip the lid can sit on, it is differenced from the main box shape
        echo("*********LidOffset**********")
        translate([-0.01, -0.01, height - lidOffsetHeight + 0.01]) hollowRoundedCube(length = length + 0.02, width = width + 0.02, height = lidOffsetHeight, radius = roundedRadius, wallThickness = lidOffsetWidth, hasFloor = false, 
            roundingShape = "circle", dimensionType = "outer", center = false, roundedInterior = roundedLidOffset);

    }
}

module lid(length = 10, width = 10, height = 10, roundedRadius = 1, lidOffsetWidth = 1.5, lidSlop = 0.5, lidTopThickness = 2, roundingShape = "sphere", roundedLidOffset = false) {
    echo("**********Lid**********");
    wallThickness = lidOffsetWidth - lidSlop;
    hollowRoundedCube(length = length, width = width, height = height, radius = roundedRadius, wallThickness = wallThickness, hasFloor = true, 
        floorThickness = lidTopThickness, roundingShape = roundingShape, topRoundingShape = "circle", dimensionType = "outer", center = false, 
        roundedInterior = roundedLidOffset);
}

//test
$fn = 100;
length = 120;
width = 80;
height = 10;
wallThickness = 3;

boxWithLid(length = 120, width = 80, height = 10, roundedRadius = 2, roundingShape = "sphere", lidHeight = 5 + 5, lidOffsetWidth = 1.5, 
    lidOffsetHeight = 5, lidSlop = 0.7, lidTopThickness = 2, hollow = true, wallThickness = wallThickness, includeLid = false, roundedInterior = false, roundedLidOffset = false);
translate([0, width + 10, 0])  lid(length = length, width = width, height = height, roundedRadius = 2, wallThickness = wallThickness, lidTopThickness = 2, roundingShape = "sphere", roundedLipOffset = false);