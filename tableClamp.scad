use <cubes.scad>
use <./bosl/constants.scad>
include <./bosl/threading.scad>
use <./knurled/knurledFinishLib-v2.scad>


$fn = 30;

//Clamp
//The length of the clamp is based off the needed clamping area, the actualy length will be clampInnerLength + clampThickness
clampInnerLength = 26;
clampWidth = 21;
clampInnerHeight = 50;
clampThickness = 10.5;
innerRoundedRadius = 5;
outerRoundedRadius = 1;
screwHoleMargin = (clampInnerLength - clampThickness) / 2;

//Screw
screwDiameter = 10;
screwHoleHeight = clampThickness * 2; 
screwThreadPitch = 2;
threadHoleAdjustment = 0.7; //0.5 when hole printed facing up , 0.7 when hole printed laying on its side

screwBaseHeight = 20;
screwLength = clampInnerHeight;

screwBaseDiameter = screwDiameter + 2;
clampOuterHeight = clampInnerHeight + 2 * clampThickness;
hollowAreaHeight = clampOuterHeight - 2 * clampThickness;
clampOuterLength = clampInnerLength + clampThickness;

PART = "clamp";

if (PART == "clamp") {
    clamp();
} else {
    knurledScrew();
}

module clamp() {
    difference() {
        roundedCube(length = clampOuterLength, width = clampWidth, height = clampOuterHeight, radius = outerRoundedRadius, center = false, roundingShape = "sphere", topRoundingShape = "sphere");

        diffWidth = clampWidth + 2 * innerRoundedRadius;
        diffY = diffWidth / 2 - clampWidth / 2;
        translate([-clampThickness, -diffY, clampThickness]) roundedCube(length = clampOuterLength, width = diffWidth, height = hollowAreaHeight, radius = innerRoundedRadius, center = false, roundingShape = "sphere", topRoundingShape = "sphere");

        screwX = screwDiameter / 2 + screwHoleMargin;
        screwY = clampWidth / 2;
        translate([screwX, screwY, -1]) threads(internal = true); 
    }
}

module knurledScrew() {
    knurl(k_cyl_hg	= screwBaseHeight, k_cyl_od	= screwBaseDiameter, knurl_dp =  1);
    translate([0, 0, screwBaseHeight]) threaded_rod(d = screwDiameter, l = screwLength, pitch = screwThreadPitch, internal = false, slop = 0, orient=ORIENT_Z, align=V_UP);
}
module threads(internal = false) {
    threaded_rod(d = screwDiameter, l = screwHoleHeight, pitch = screwThreadPitch, internal = internal, slop = threadHoleAdjustment, orient=ORIENT_Z, align=V_UP);
}