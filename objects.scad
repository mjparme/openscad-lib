use <cubes.scad>

//stairHeight should be a multiple of totalHeight
//Rounded stairs with a bottom DO NOT touch because of the rounded edge, could move things over so they do touch but that
//would make them not the requested height. So just living with this. 
//TODO: this module reaches a total height, instead we should change it so you reach a certain height in a certain distance...for example I want to rise 100 mm over the course of 150mm
module stairs(length = 10, width = 20, stairHeight = 5, totalHeight = 100, hasBottom = false, rounded = false, roundedRadius = 1) {
    echo("**********Stairs*****************");
    echo("TotalHeight: ", totalHeight);
    echo("StairHeight: ", stairHeight);
    numberOfStairs = totalHeight / stairHeight;
    echo("NumberOfStairs: ", numberOfStairs);
    for (i = [0:numberOfStairs - 1]) {
        x = length * i;
        z = hasBottom ? 0 : stairHeight * i;
        adjustedStairHeight = hasBottom ? (i * stairHeight) + stairHeight : stairHeight;
        echo("AdjustedStairHeight: ", adjustedStairHeight);
        if (rounded) {
            translate([x, 0, z]) roundedCube(length, width, adjustedStairHeight, radius = roundedRadius, center = false);
        } else {
            translate([x, 0, z]) cube([length, width, adjustedStairHeight], center = false);
        }
    }
}

//This is number of stairs for a certain stair case height
function numberOfStairs(stairCaseHeight, stepRise, stepDepth) = 
    let (numberOfStairs = floor(stairCaseHeight / stepRise), exactRise = stairCaseHeight / numberOfStairs, stairCaseRunDistance = numberOfStairs * stepDepth) 
        [
            numberOfStairs, exactRise, stairCaseRunDistance
        ];

//This is the number of stairs for a certain stair case run distance

module ramp(length = 100, width = 20, startingHeight = 5, endingHeight = 10) {
    hull() {
        cube([0.01, width, startingHeight]);
        translate([length, 0, 0]) cube([0.01, width, endingHeight]);
    } 
}

module arch(length = 10, width = 20, height = 30) {
    rotate([90, 0, 90]) linear_extrude(length) {
        adjustedHeight = height - (width / 2); 
        echo("Height: ", height);
        echo("Width: ", width);
        echo("Half Width: ", width / 2);
        echo("AdjustedHeight: ", adjustedHeight);
        assert(adjustedHeight >= 0, "Height minus half the width must be great or equal than 0");
        square([width, adjustedHeight]);
        translate([width / 2, adjustedHeight, 0]) halfCircle(width);
    }

    module halfCircle(width) {
        difference() {
            circle(d = width);
            squareSize = width * 2;
            translate([0, -squareSize / 2, 0]) square(squareSize, center = true);
        }
    }
}

//Test
//stairs(length = 5, stairHeight = 5, totalHeight = 10, hasBottom = true, rounded = false);
//ramp(startingHeight = 0.01, endingHeight = 1);
//arch(length = 290, width = 30, height = 60);