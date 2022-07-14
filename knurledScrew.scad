use <./bosl/constants.scad>
include <./bosl/threading.scad>
use <./knurled/knurledFinishLib-v2.scad>

module knurledScrew(screwDiameter = 10, screwBaseDiameter = 12, screwBaseHeight = 20, screwLength = 25, screwThreadPitch = 2) {
    knurl(k_cyl_hg	= screwBaseHeight, k_cyl_od	= screwBaseDiameter, knurl_dp =  1);
    translate([0, 0, screwBaseHeight]) threaded_rod(d = screwDiameter, l = screwLength, pitch = screwThreadPitch, internal = false, slop = 0, orient=ORIENT_Z, align=V_UP);
}

module knurledNut(nutDiameter = 20, nutThickness = 10, threadDiameter = 10, threadHeight = 20, threadPitch = 2, threadHoleSlop = 0.7) {
    difference() {
        knurl(k_cyl_hg = nutThickness, k_cyl_od = nutDiameter, knurl_dp =  1);
        translate([0, 0, -0.01]) threaded_rod(d = threadDiameter, l = threadHeight, pitch = threadPitch, internal = true, slop = threadHoleSlop, orient=ORIENT_Z, align=V_UP);
    }
}

//Test
//knurledScrew();
//knurledNut(nutDiameter = 10, threadDiameter = 5);