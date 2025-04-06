include <./bosl2/std.scad>
include <paths.scad>

//sizeConstant -- Used in the forumla that makes the 2d rope cross section, controls the diameter, small increases
// make fairly large increases in diameter.
// -- 1.9 is a diameter of about 10.6 mm
// -- 2 is a diameter of about 11 mm
// -- 3 is a diameter of about 16 mm
module ropeCircle(ropeRadius = 100, sizeConstant = 1.9) {
    echo("***** ropeCircle() *****");
    echo("ropeRadius: ", ropeRadius);
    echo("sizeConstant: ", sizeConstant);

    path = getCirclePoints(radius = ropeRadius, numOfPoints = 360, degreesOfRotation = 360, direction = "cw", calculateLastPoint = true, startAngle = 0);

    //As radius decreases twist needs to decrease too I found a twist of 12 * 360 for 100 radius was good, so I just maintain that ratio
    twistConstant = (12 * ropeRadius / 100);
    echo("twistConstant: ", twistConstant);
    rope2d = ropeSection(sizeConstant);
    path_sweep(rope2d, path, twist = twistConstant * 360);
}

//sizeConstant -- Used in the forumla that makes the 2d rope cross section, controls the diameter, small increases
// make fairly large increases in diameter.
// -- 1.9 is a diameter of about 10.6 mm
// -- 2 is a diameter of about 11 mm
// -- 3 is a diameter of about 16 mm
function ropeSection(sizeConstant = 1.9) = [
    for (a = [0 : 5 : 360]) sizeConstant * polar_to_xy([1.8 + abs(cos(2.5 * a)), a])
    ];

ropeCircle(50);