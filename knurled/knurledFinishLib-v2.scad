/*
 * knurledFinishLib_v2.scad
 * 
 * Written by aubenc @ Thingiverse
 *
 * This script is licensed under the Public Domain license.
 *
 * http://www.thingiverse.com/thing:31122
 *
 * Derived from knurledFinishLib.scad (also Public Domain license) available at
 *
 * http://www.thingiverse.com/thing:9095
 *
 * Usage:
 *
 *	 Drop this script somewhere where OpenSCAD can find it (your current project's
 *	 working directory/folder or your OpenSCAD libraries directory/folder).
 *
 *	 Add the line:
 *
 *		use <knurledFinishLib_v2.scad>
 *
 *	 in your OpenSCAD script and call either...
 *
 *    knurledCylinder(Knurled cylinder height,
 *                 Knurled cylinder outer diameter,
 *                 Knurl polyhedron width,
 *                 Knurl polyhedron height,
 *                 Knurl polyhedron depth,
 *                 Cylinder ends smoothed height,
 *                 Knurled surface smoothing amount );
 *
 *  Call the module ' help(); ' for a little bit more of detail
 *  and/or take a look to the PDF available at http://www.thingiverse.com/thing:9095
 *  for a in depth descrition of the knurl properties.
 */

module knurledCylinder(height = 12, outerDiameter = 25, knurlWidth = 3, knurlHeight = 4, knurlDepth = 1.5, bevelHeight = 2, surfaceSmoothing = 0) {
    cord = (outerDiameter + knurlDepth + knurlDepth * surfaceSmoothing / 100) / 2;
    cird = cord - knurlDepth;
    cfn = round(2 * cird * PI / knurlWidth);
    clf = 360 / cfn;
    crn = ceil(height / knurlHeight);

    echo("knurled cylinder max diameter: ", 2 * cord);
    echo("knurled cylinder min diameter: ", 2 * cird);

	 if(bevelHeight < 0) {
        union() {
            shape(bevelHeight, cird+knurlDepth*surfaceSmoothing/100, cord, cfn*4, height);
            translate([0,0,-(crn*knurlHeight-height)/2]) knurledFinish(cord, cird, clf, knurlHeight, cfn, crn);
        }
    } else if (bevelHeight == 0) {
        intersection() {
            cylinder(h=height, r=cord-knurlDepth*surfaceSmoothing/100, $fn=2*cfn, center=false);
            translate([0,0,-(crn*knurlHeight-height)/2]) knurledFinish(cord, cird, clf, knurlHeight, cfn, crn);
        }
    } else {
        intersection() {
            shape(bevelHeight, cird, cord-knurlDepth*surfaceSmoothing/100, cfn*4, height);
            translate([0,0,-(crn*knurlHeight-height)/2]) knurledFinish(cord, cird, clf, knurlHeight, cfn, crn);
        }
    }
}

module shape(hsh, ird, ord, fn4, hg) {
	x0 = 0;	
    x1 = hsh > 0 ? ird : ord;		
    x2 = hsh > 0 ? ord : ird;
	y0 = -0.1;	
    y1 = 0;	
    y2 = abs(hsh);	
    y3 = hg - abs(hsh);	
    y4 = hg;	
    y5 = hg + 0.1;

	if (hsh >= 0) {
		rotate_extrude(convexity=10, $fn=fn4)
		polygon(points=[ [x0,y1],[x1,y1],[x2,y2],[x2,y3],[x1,y4],[x0,y4]	],
					paths=[	[0,1,2,3,4,5]	]);
	} else {
		rotate_extrude(convexity=10, $fn=fn4)
		polygon(points=[ [x0,y0],[x1,y0],[x1,y1],[x2,y2], [x2,y3],[x1,y4],[x1,y5],[x0,y5] ],
					paths=[	[0,1,2,3,4,5,6,7] ]);
	}
}

module knurledFinish(ord, ird, lf, sh, fn, rn) {
    for(j = [ 0 : rn - 1 ]) {
        h0 = sh * j; 
        h1 = sh * (j + 1 / 2); 
        h2 = sh * (j + 1);
        for(i = [ 0 : fn - 1 ]) {
            lf0 = lf * i; 
            lf1 = lf * (i + 1 / 2); 
            lf2 = lf * (i + 1);
            polyhedron(
                points=[
                     [ 0,0,h0],
                     [ ord*cos(lf0), ord*sin(lf0), h0],
                     [ ird*cos(lf1), ird*sin(lf1), h0],
                     [ ord*cos(lf2), ord*sin(lf2), h0],

                     [ ird*cos(lf0), ird*sin(lf0), h1],
                     [ ord*cos(lf1), ord*sin(lf1), h1],
                     [ ird*cos(lf2), ird*sin(lf2), h1],

                     [ 0,0,h2],
                     [ ord*cos(lf0), ord*sin(lf0), h2],
                     [ ird*cos(lf1), ird*sin(lf1), h2],
                     [ ord*cos(lf2), ord*sin(lf2), h2]
                    ],
                faces=[
                     [0,1,2],[2,3,0],
                     [1,0,4],[4,0,7],[7,8,4],
                     [8,7,9],[10,9,7],
                     [10,7,6],[6,7,0],[3,6,0],
                     [2,1,4],[3,2,6],[10,6,9],[8,9,4],
                     [4,5,2],[2,5,6],[6,5,9],[9,5,4]
                    ],
                convexity=5);
         }
    }
}

module knurlHelp()
{
	echo();
	echo("    Knurled Surface Library  v2  ");
   echo("");
	echo("      Modules:    ");
	echo("");
	echo("        knurled_cyl(parameters... );    -    Requires a value for each an every expected parameter (see bellow)    ");
	echo("");
	echo("        knurl();    -    Call to the previous module with a set of default parameters,    ");
	echo("                                  values may be changed by adding 'parameter_name=value'        i.e.     knurl(s_smooth=40);    ");
	echo("");
	echo("      Parameters, all of them in mm but the last one.    ");
	echo("");
	echo("        k_cyl_hg       -   [ 12   ]  ,,  Height for the knurled cylinder    ");
	echo("        k_cyl_od      -   [ 25   ]  ,,  Cylinder's Outer Diameter before applying the knurled surfacefinishing.    ");
	echo("        knurl_wd     -   [   3   ]  ,,  Knurl's Width.    ");
	echo("        knurl_hg      -   [   4   ]  ,,  Knurl's Height.    ");
	echo("        knurl_dp     -   [  1.5 ]  ,,  Knurl's Depth.    ");
	echo("        e_smooth   -    [  2   ]  ,,  Bevel's Height at the bottom and the top of the cylinder    ");
	echo("        s_smooth   -    [  0   ]  ,,  Knurl's Surface Smoothing :  File donwn the top of the knurl this value, i.e. 40 will snooth it a 40%.    ");
	echo("");
}

knurledCylinder();