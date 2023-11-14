//pegType -- one of "hooked" or "straight", 
//horizontalLength - the length of the horizontal component of the peg
//verticalLength - the length of the vertical component of the peg
//hookAngle - the angle the vertical component is angled from the horizontal component
module hookedPegs(numOfPegs = 2, pegDiameter = 5, pegDistance = 25.4, horizontalLength = 9, verticalLength = 8, hookAngle = 45, pegsToSpanY = 2, 
    includeBottomPeg = true, pegsToSpanZ = 2) {
    echo("***** hookedPegs() *****");
    echo("NumOfPegs: ", numOfPegs);
    echo("IncludeBottomPeg: ", includeBottomPeg);
    echo("PegsToSpanY: ", pegsToSpanY);
    echo("PegsToSpanZ: ", pegsToSpanZ);

    pegSpacingY = pegDistance * pegsToSpanY;
    pegSpacingZ = pegDistance * pegsToSpanZ; 
    echo("PegSpacingY: ", pegSpacingY);
    echo("PegSpacingZ: ", pegSpacingZ);

    for (i = [0 : numOfPegs - 1]) {
        topZ = includeBottomPeg ? pegSpacingZ : 0;
        translate([0, (i * pegSpacingY), topZ]) topPeg();

        if (includeBottomPeg) {
            echo("includeBottomPeg in if");
            translate([0, (i * pegSpacingY), 0]) bottomPeg();
        }
    }

    module topPeg() {
        rotate([0, 0, 180]) pegboardHookedPeg(diameter = pegDiameter, horizontalLength = horizontalLength, verticalLength = verticalLength, hookAngle = hookAngle);
    }

    module bottomPeg() {
        echo("in bottomPeg(): ");
        rotate([0, 0, 180]) pegboardPeg(diameter = pegDiameter, length = horizontalLength); 
    }
}

module straightPegs(pegDistance = 25.4, pegsToSpanY = 2, pegsToSpanZ = 2, includeBottomPeg = true, numOfPegs = 2, pegBigDiameter = 9, 
    pegBigHeight = 3, pegSmallDiameter = 5, pegSmallheight = 5.5) {

    echo("***** straightPegs() *****");
    echo("NumOfPegs: ", numOfPegs);
    echo("IncludeBottomPeg: ", includeBottomPeg);
    echo("PegsToSpanY: ", pegsToSpanY);
    echo("PegsToSpanZ: ", pegsToSpanZ);

    pegSpacingY = pegDistance * pegsToSpanY;
    pegSpacingZ = pegDistance * pegsToSpanZ; 
    echo("PegSpacingY: ", pegSpacingY);
    echo("PegSpacingZ: ", pegSpacingZ);

    for (i = [0 : numOfPegs - 1]) {
        topZ = includeBottomPeg ? pegSpacingZ : 0;
        translate([0, (i * pegSpacingY), topZ]) topPeg();

        if (includeBottomPeg) {
            echo("includeBottomPeg in if");
            translate([0, (i * pegSpacingY), 0]) bottomPeg();
        }
    }

    echo("PegSpacingY: ", pegSpacingY);
    echo("PegSpacingZ: ", pegSpacingZ);

    module topPeg() {
        rotate([0, 0, 180]) straightPeg(pegBigDiameter, pegBigHeight, pegSmallDiameter, pegSmallheight);
    }

    module bottomPeg() {
        rotate([0, 0, 180]) straightPeg(pegBigDiameter, pegBigHeight, pegSmallDiameter, pegSmallheight);
    }
}

//A pegboard peg that has a horizontal component and then a vertical component that is angled the provided
//amount from the horizontal. Set the $fn variable to control the quality
// -- 3/16" hole diameter pegboard is 4.7 mm diameter in metric
// -- 1/4" hole diameter pegboard is 6.4 mm diameter in metric
// -- 9/32" hole diameter pegboard is 7.1 mm diameter in metric
module pegboardHookedPeg(diameter = 5.0, horizontalLength = 9, verticalLength = 8, hookAngle = 45) {
    //The horizontal component of the peg
    translate([0, 0, 0]) pegboardPeg(diameter, horizontalLength);

    //The vertical component of the peg
    translate([horizontalLength - diameter / 2, 0, 0]) rotate([0, -hookAngle, 0]) pegboardPeg(diameter, verticalLength);
}

//A straight pegboard peg to be used as the bottom peg when a hooked peg is used
// -- 3/16" hole diameter pegboard is 4.7 mm diameter in metric
// -- 1/4" hole diameter pegboard is 6.4 mm diameter in metric
// -- 9/32" hole diameter pegboard is 7.1 mm diameter in metric
module pegboardPeg(diameter = 5.0, length = 8) {
    rotate([0, 90, 0]) hull() {
        linear_extrude(1) circle(d = diameter);
        translate([0, 0, length - (diameter / 2)]) sphere(d = diameter);
    }
}

module straightPeg(pegBigDiameter = 9, pegBigHeight = 3, pegSmallDiameter = 5, pegSmallheight = 5.5) {
    x = pegSmallheight / 2;
    translate([x, 0, 0]) rotate([0, 90, 0]) union() {
        cylinder(d = pegSmallDiameter, h = pegSmallheight, center = true);
        z = pegSmallheight / 2 + pegBigHeight / 2 - 0.01;
        translate([0, 0, z]) cylinder(d = pegBigDiameter, h = pegBigHeight, center = true);
    }
} 


//Returns [length, height] from the first peg to the last peg, can be used to center the pegs in an area
function calculatePegAreaDimensions(numOfPegs, pegDistance, pegsToSpanY, pegsToSpanZ) = [
    (numOfPegs - 1) * pegDistance * pegsToSpanY,
    pegDistance * pegsToSpanZ
    ];

// ***** Test *****

//$fn = 60;
//hookedPegs(pegDiameter = 5, pegDistance = 25.4, pegsToSpanY = 2, pegsToSpanZ = 2, includeBottomPeg = true, horizontalLength = 7, verticalLength = 7, hookAngle = 45, numOfPegs = 2);
//straightPegs(pegDistance = 25.4, pegsToSpanY = 2, pegsToSpanZ = 2, includeBottomPeg = true, numOfPegs = 2, pegBigDiameter = 9, pegBigHeight = 3, pegSmallDiameter = 5, pegSmallheight = 5.5);
//pegArea = calculatePegAreaDimensions(numOfPegs = 2, pegDistance = 25.4, pegsToSpanY = 2, pegsToSpanZ = 2);
//echo("pegArea: ", pegArea);