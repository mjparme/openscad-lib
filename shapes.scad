module torus(radiusOfTorus = 10, diameterOfCircle = 5, dimensionType = "inner", center = true) {
    z = center ? 0 : diameterOfCircle / 2;
    radiusOfCircle = diameterOfCircle / 2;
    adjustedTorusRadius = dimensionType == "inner" ? radiusOfTorus + radiusOfCircle : radiusOfTorus - radiusOfCircle;
    echo("AdjustedTorusRadius: ", adjustedTorusRadius);
    translate([0, 0, z]) rotate_extrude() translate([adjustedTorusRadius, 0, 0]) circle(d = diameterOfCircle);
}

/**
	Allows you to create a dome
	
    * d -- Diamater of the dome. Default: 5
    * h -- Height of the dome. Default: 2
    * hollow -- Whether or not you want the dome to be hollow. Default: false
    * wallWidth -- If the dome is hollow, how wide should the walls be. Default: 0.5
    * $fn = How smooth you want the dome rounding to be. Default: 60
*/
module dome(d = 5, h = 2, hollow = false, wallWidth = 0.5, $fn = 60) {
	sphereRadius = (pow(h, 2) + pow((d/2), 2) ) / (2*h);

	translate([0, 0, (sphereRadius-h)*-1]) {
		difference() {
			sphere(sphereRadius);
			translate([0, 0, -h]) {
				cube([2*sphereRadius, 2*sphereRadius, 2*sphereRadius], center=true);
			}

			if (hollow) {
				sphere(sphereRadius-wallWidth);
			}
		}
	}
}

//This isn't really a fillet, thought that is what it was called
//but this isn't a fillet, don't really know what to call it
module fillet(diameter = 10, filletSize = 2) {
  rotate_extrude() {
        translate([diameter / 2, 0, 0]) 
        difference() {
            square(filletSize);
            translate([filletSize, 0, 0]) rotate([0, 0, 45]) square(filletSize * 2);
        }
    }
}

 module halfCircle(diameter) {
    difference() {
        circle(d = diameter);
        squareSize = diameter * 2;
        translate([0, -squareSize / 2, 0]) square(squareSize, center = true);
    }
}

 module roundedLine(thickness = 10, length = 20, orientation = "x", rounded = "left") {
    echo("**** roundedLine() *****");

    squareDimension = orientation == "x" ? [0.01, thickness] : [thickness, 0.01];
    //Used if rounding is wanted on the left/bottom side of the line
    circleLocation1 = [thickness / 2, thickness / 2]; //left or bottom
    circleLocation2 = orientation == "x" ? [length - thickness / 2, thickness / 2] : [thickness / 2, length - thickness / 2]; //right or top
    squareLocation = orientation == "x" ? [length, 0] : [0, length];
    echo("squareDimension: ", squareDimension);
    echo("circleLocation1: ", circleLocation1);
    echo("circleLocation2: ", circleLocation2);

    if (rounded == "right" || rounded == "top") {
        hull() {
            square(squareDimension);
            translate(circleLocation2) circle(d = thickness);
        }
    } else if (rounded == "left" ||  rounded == "bottom") {
        hull() {
            translate(circleLocation1) circle(d = thickness);
            translate(squareLocation) square(squareDimension);
        }
    } else if (rounded == "both") {
        hull() {
            translate(circleLocation1) circle(d = thickness);
            translate(circleLocation2) circle(d = thickness);
        }
    }
}

//*************Test****************
//points = [[0, 0], [42.5, 37], [-3.7, 80], [43, 111.1]];
//rotate_extrude() 
  //translate([10, 0, 5]) 
  //polyline(points, 3);
//torus(radiusOfTorus = 20, dimensionType = "outer", center = true);
//torus(dimensionType = "inner");