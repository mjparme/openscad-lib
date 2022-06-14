use <cubes.scad>
use <./bosl/constants.scad>
include <./bosl/threading.scad>
use <./knurled/knurledFinishLib-v2.scad>

//The length of the clamp is based off the needed clamping area, the actual length will be clampInnerLength + clampThickness
module clamp(clampInnerLength = 26, clampWidth = 21, clampInnerHeight = 50, clampThickness = 10.5, innerRoundedRadius = 5, outerRoundedRadius = 1,
    screwDiameter = 10, screwThreadPitch = 2, threadHoleAdjustment = 0.7) {

    screwHoleMargin = (clampInnerLength - clampThickness) / 2;
    screwHoleHeight = clampThickness * 2; 
    clampOuterHeight = clampInnerHeight + 2 * clampThickness;
    hollowAreaHeight = clampOuterHeight - 2 * clampThickness;
    clampOuterLength = clampInnerLength + clampThickness;

    difference() {
        roundedCube(length = clampOuterLength, width = clampWidth, height = clampOuterHeight, radius = outerRoundedRadius, center = false, roundingShape = "sphere", topRoundingShape = "sphere");

        diffWidth = clampWidth + 2 * innerRoundedRadius;
        diffY = diffWidth / 2 - clampWidth / 2;
        translate([-clampThickness, -diffY, clampThickness]) roundedCube(length = clampOuterLength, width = diffWidth, height = hollowAreaHeight, radius = innerRoundedRadius, center = false, roundingShape = "sphere", topRoundingShape = "sphere");

        screwX = screwDiameter / 2 + screwHoleMargin;
        screwY = clampWidth / 2;
        translate([screwX, screwY, -1]) threads();
    }

    module threads(internal = true) {
        threaded_rod(d = screwDiameter, l = screwHoleHeight, pitch = screwThreadPitch, internal = internal, slop = threadHoleAdjustment, orient = ORIENT_Z, align = V_UP);
    }
}

//ClampInnerHeight used for the clamp part works well as the screwLength
module knurledScrew(screwDiameter = 10, screwBaseDiameter = 12, screwBaseHeight = 20, screwLength = 50, screwThreadPitch = 2) {
    knurl(k_cyl_hg	= screwBaseHeight, k_cyl_od	= screwBaseDiameter, knurl_dp =  1);
    translate([0, 0, screwBaseHeight]) threaded_rod(d = screwDiameter, l = screwLength, pitch = screwThreadPitch, internal = false, slop = 0, orient=ORIENT_Z, align=V_UP);
}

//$fn = 30;
clamp(outerRoundedRadius = 2);
//knurledScrew();