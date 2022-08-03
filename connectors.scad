include <shapes.scad>

/**
    Used to create 4 holes seperated by the passed in dimensions. Can be used to create holes in stand offs when
    used as part of a union or can be difference out of another part. To create standoffs use a outer and inner diameter.
    To create just holes use 0 for inner diameter.

    x -- x location of the center of the first hole, generally pass 0 and translate the entire module when it is used
    x -- y location of the center of first hole, generally pass 0 and then translate the entire module when it is used
    xDistance -- distance between holes in the X direction 
    yDistance -- distance between holes in the Y direction 
    holeOuterDiameter -- the outer diameter of the hole
    holeInnerDiameter -- the inner diameter of the hole, this is generaly the size of the screw you want to use and is generally
    the same size as the PCB hole (or slightly smaller, but never bigger)
   mountingHoleHeight -- the height of the mounting hole 
*/
module mountingHoles(xDistance, yDistance, holeOuterDiameter, holeInnerDiameter, mountingHoleHeight, fillet = true, filletSize = 2) {
    x = 0;
    y = 0;
    z = 0;
    translate([x, y , z]) mountingHole(holeOuterDiameter, holeInnerDiameter, mountingHoleHeight, fillet, filletSize);
    translate([x + xDistance, y, z]) mountingHole(holeOuterDiameter, holeInnerDiameter, mountingHoleHeight, fillet, filletSize);
    translate([x + xDistance, y + yDistance, z]) mountingHole(holeOuterDiameter, holeInnerDiameter, mountingHoleHeight, fillet, filletSize);
    translate([x , y + yDistance, z]) mountingHole(holeOuterDiameter, holeInnerDiameter, mountingHoleHeight, fillet, filletSize);

    module mountingHole(outerDiameter, innerDiameter, mountingHoleHeight, fillet = true, filletSize = 2) {
        difference() {
            cylinder(d=outerDiameter, h=mountingHoleHeight);
            translate([0, 0, -.01]) cylinder(d=innerDiameter, h=mountingHoleHeight + 1);
        }

        //A fillet around the bottom of the mounting hole 
        //Making the fillet by making a 2d triangle then rotating it around the bottom of the mounting hole
        //Making the triangle by make a 2d square than differencing it with a bigger square at a 45 degree angle
        if (fillet == true) {
            rotate_extrude() {
                translate([outerDiameter / 2, 0, 0]) 
                difference() {
                    square(filletSize);
                    translate([filletSize, 0, 0]) rotate([0, 0, 45]) square(filletSize * 2);
                }
            }
        }
    }
}

/*
 Creates a object that can be difference out of another object to create elongated screw holes
 holeLength - how long to make the elongation
 diameter - The diameter of the screw you are wanting to use
 thickness - How thick you want the hole to be, usually a little thicker than the object you want to make a hole in
 
 $fn should be set in the design using this library

*/
module elongatedScrewHole(holeLength, diameter, thickness, debug = false) {
    adjustedLength = holeLength - diameter;
    if (debug) {
        echo("Elongated Hole Desired Length: ", holeLength);
        echo("Elongated Hole Diameter: ", diameter);
        echo("Elongated Hole Adjusted Length (to get desired): ", adjustedLength);
    }

    //Translate the radius of the hole so it is at the origin
    translate([diameter / 2, 0, 0]) hull() {
        cylinder(d = diameter, h = thickness);
        translate([adjustedLength, 0, 0]) cylinder(d = diameter, h = thickness);
    }
}

/*
    Makes a rounded connector, has a flat side and a round side, the screw hole is put through the middle
    of the round side. The height refers to both the height of the connector along the Z axis and the screw
    hole is put at height / 2 along the X axis

    height - height along the Z axis, height / 2 is the position of the screw hole along the X axis
    screwHoleDiameter - the diameter of the screw hole
    width - the thickness of the connector
    taperValue - How much smaller than height the rounded side is. The diameter of the rounded side is height / taperValue
*/
module roundedConnector(height = 30, screwHoleDiameter = 5, width = 4, taperValue = 1.5) {
    position = height / 2;

    difference() {
        connector();
        translate([position, -1, position]) rotate([-90, 0, 0]) cylinder(d=screwHoleDiameter, h=width + 2, center=false);
    }

    module connector() {
        hull() {
            cube([0.1, width, height]);
            translate([position, 0, position]) rotate([-90, 0, 0]) cylinder(d=height / taperValue, h=width, center=false);
        }
    }
}

/*
    Same thing as a roundedConnector except there are two of them, meant to go on both sides of something

    distanceBetweenConnectors - the distance between the two connectors
*/
module roundedConnectorPair(height = 30, screwHoleDiameter = 5, width = 4, taperValue = 1.5, distanceBetweenConnectors = 31) {
    roundedConnector(height, screwHoleDiameter, width, taperValue);
    translate([0, distanceBetweenConnectors + width, 0]) roundedConnector(height, screwHoleDiameter, width, taperValue);

}

//A pegboard peg that has a horizontal component and then a vertical component that is angled the provided
//amount from the vertical. Set the $fn variable to control the quality
// -- 3/16" hole diameter pegboard is 4.7 mm diameter in metric
// -- 1/4" hole diameter pegboard is 6.4 mm diameter in metric
// -- 9/32" hole diameter pegboard is 7.1 mm diameter in metric
module pegboardHookedPeg(diameter = 5.0, horizontalLength = 9, verticalLength = 8, hookAngle = 45) {
    //The horizontal component of the peg
    translate([0, 0, 0]) pegboardPeg(diameter, horizontalLength);

    //The vertical component of the peg
    translate([horizontalLength - diameter / 2, 0, 0]) rotate([0, -hookAngle, 0]) pegboardPeg(diameter, verticalLength);
}

//A straight pegboard peg, this is in the vertical orientation, rotate as necessary
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
    //filletZ = -pegSmallheight / 2;
    //translate([0, 0, filletZ]) fillet(diameter = pegSmallDiameter, filletSize = 2);
} 

//pegType -- one of "hooked" or "straight", 
//pegBigDiameter, pegBigHeight, pegSmallDiameter, pegSmallheight only apply to the straight type peg
module pegboardPlate(holeDiameter = 5, thickness = 3, yLength = 100, height = 75, pegDistance = 25.4, pegsToSpanY = 2, pegsToSpanZ = 2, 
    includeBottomPeg = true, numOfPegs = 2, pegType = "hooked", pegBigDiameter = 9, pegBigHeight = 3, pegSmallDiameter = 5, 
    pegSmallheight = 5.5) {

    echo("***** Pegboard Plate *****");
    echo("yLength: ", yLength);
    echo("NumOfPegs: ", numOfPegs);
    echo("IncludeBottomPeg: ", includeBottomPeg);
    echo("PegstoSpanY: ", pegsToSpanY);
    echo("PegstoSpanZ: ", pegsToSpanZ);

    pegSpacingY = pegDistance * pegsToSpanY;
    pegSpacingZ = pegDistance * pegsToSpanZ; 
    totalPegLength = pegSpacingY * (numOfPegs - 1);
    echo("TotalPegLength: ", totalPegLength);

    //Want the top pegs to be close to the top so they can be put in the pegboard
    firstPegY = yLength - (yLength / 2 - totalPegLength / 2);
    //TODO: this holeDiameter is the diameter of the hooked peg, the diameter of the straight peg comes from pegSmallDiameter
    //TODO: use the correct one based on peg type
    firstPegZ = height - (holeDiameter / 2);

    cube([thickness, yLength, height]);
    for (i = [0:numOfPegs - 1]) {
        translate([0, firstPegY - (i * pegSpacingY), firstPegZ]) topPeg();
        if (includeBottomPeg) {
            translate([0, firstPegY - (i * pegSpacingY), firstPegZ - pegSpacingZ]) bottomPeg();
        }
    }

    echo("FirstPegY: ", firstPegY);
    echo("FirstPegZ: ", firstPegZ);
    echo("PegSpacingY: ", pegSpacingY);
    echo("PegSpacingZ: ", pegSpacingZ);

    module topPeg() {
        //This translate gets the center of the peg at the origin so we can not worry about it in the parent module
        rotate([0, 0, 180]) 
        if (pegType == "hooked") {
            pegboardHookedPeg(diameter = holeDiameter);
        } else if (pegType == "straight") {
            straightPeg(pegBigDiameter, pegBigHeight, pegSmallDiameter, pegSmallheight);
        }
    }

    module bottomPeg() {
        rotate([0, 0, 180]) 
        if (pegType == "hooked") {
            pegboardPeg(diameter = holeDiameter);
        } else if (pegType == "straight") {
            straightPeg(pegBigDiameter, pegBigHeight, pegSmallDiameter, pegSmallheight);
        }
    }
}

//A cylinder with a difference top and bottom diameter, handy for counter sinking or heat-set inserts 
module taperedHole(bottomDiameter = 4, topDiameter = 6, height = 10, center = false) {
    cylinder(d1 = bottomDiameter, d2 = topDiameter, h = height, center = center);
}

module doveTail(narrowLength = 10, wideLength = 20, height = 10, narrowLocation = "top") {
    topX = "top" == narrowLocation ?  wideLength / 2 - narrowLength / 2 : narrowLength / 2 - wideLength / 2 ;
    square1 = "top" == narrowLocation ? [narrowLength, 0.01] : [wideLength, 0.01];
    square2 = "top" == narrowLocation ? [wideLength, 0.01] : [narrowLength, 0.01];
    hull() {
        translate([topX, height]) square(square1);
        square(square2);
    }
}

//Test
//$fn = 60;
//elongatedScrewHole(20, 6, 10);
//roundedConnector(taperValue = 1.5);
//roundedConnectorPair(distanceBetweenConnectors = 31);
//a diameter of 5.1 fits well in both 3/16" and 9/32" pegboard
//pegboardHookedPeg(5.2, 8, 7);
//pegboardHookedPeg(6.3, 9, 10);
//pegboardPlate(thickness = 3, yLength = 100, height = 100, pegDistance = 25.4, pegsToSpanY = 2, pegsToSpanZ = 2);
//taperedHole(bottomDiameter = 10, topDiameter = 12, height = 20, center = false);
pegboardPlate(pegType = "straight",  includeBottomPeg = true);
//straightPeg();
//pegboardHookedPeg();
//pegboardPeg();