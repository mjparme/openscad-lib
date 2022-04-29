module plotCircle(radius = 10, numOfPoints = 16, rotatePerpendicularToCenter = false) {
    //Simple division to know how often to plot a point based on the number requested
    degreesPerPoint = 360 / numOfPoints;

    for(point = [0 : numOfPoints - 1]) {
        angle = degreesPerPoint * point;
        plottedPoint = circlePoint(radius, angle);

        //echo("Point: ", point);
        //echo("Angle: ", angle);
        //echo("PlottedPoint: ", plottedPoint);

        if (rotatePerpendicularToCenter == true) {
            translate([plottedPoint[0], plottedPoint[1], 0]) rotate([0, 0, -angle]) children();
        } else {
            translate([plottedPoint[0], plottedPoint[1], 0]) children();
        }
    }
}

//Usage: rotateAboutPoint([0, 0, 45], [5,5,0]) cube(10);
module rotateAboutPoint(rotation, point) {
    translate(point) rotate(rotation) translate(-point) children();
} 

//Displays a vector of 2d vectors so the shape can be visualized
//Example: points = [[0, 0], [20, 0], [10, -20]];
module showShape(points, diameter = 1, debug = false) {
    for ( i = points) {
        if (debug) {
            echo("ShapePoint: ", i);
        }
        translate([i[0], i[1], 0]) sphere(d=diameter);
    } 
}

//Displays a vector of 3d vectors so the path can be visualized
//Example: path = [[0, 0, 0], [0, 10, 10], [0, 30, 20]];
module showPath(points, diameter = 1) {
    for ( i = points) {
        echo("PathPoint: ", i);
        translate([i[0], i[1], i[2]]) sphere(d = diameter);
    } 
}

/**
* Draws lines connecting all the passed in points. The ends of the lines are circles by default but spheres can be used instead . Set $fn to control the
* quality of those shapes.
*
* points - vector of 2d points, each point is one end of a line, points are connected until there are no more points
* thickness - how thick the drawn line is
* connectLastToFirst - true to connect the last point to the first point, false otherwise. Can be used to close in a shape.
* pointShape - which shape to draw at each point. One of "circle" or "sphere", default is circle
*/
module polyline(points, thickness = 2, connectLastToFirst = false, pointShape = "circle") {
    vectorLength = len(points);
    echo("PolyLine Points: ", points);
    echo("VectorLength: ", vectorLength); 
    for (i = [0 : vectorLength - 1]) {
        //We don't draw a point again if there isn't a point after it, but do need to check if we need to 
        //connect the last point to the first point
        if (points[i + 1] != undef) {
            drawLine(points[i], points[i + 1], thickness);
        } else {
            if (connectLastToFirst) {
                drawLine(points[0], points[len(points) - 1], thickness);
            }
        }
    }

    module drawLine(point1, point2, thickness) {
        hull() {
            radius = thickness / 2;
            if (pointShape == "circle") {
                translate(point1) circle(radius);
                translate(point2) circle(radius);
            } else {
                translate(point1) sphere(radius);
                translate(point2) sphere(radius);
            }
        }
    }
}

//Draws a child the provided numbers of times in the provided length of area. The length of area is inclusive so there will be a
//child drawn at the end. For example, for the default values of 3 and 100 there will be a child drawn at 0, 50, and 100.
module repeatObjectInArea(numOfObjects = 3, lengthOfArea = 100) {
    distanceBetweenObjects = lengthOfArea / (numOfObjects - 1);
    for (i = [0 : numOfObjects - 1]) {
        x = i * distanceBetweenObjects;
        echo("ObjectX: ", x);
        translate([x, 0, 0]) children();
    } 
}

//returns [x,y] position of point given radius and angle
function circlePoint(radius, angle) =
        [radius * sin(angle), radius * cos(angle)];

//returns [x,y] position of point given radius and angle
function ovalPoint(angle, width, height) =
        [height * sin(angle), width * cos(angle)];

//returns [x,y] position of point given radius and angle, the provided Z is added as the 3rd element in the returned vectors
function ovalPointWithZ(angle, width, height, z) =
        [height * sin(angle), width * cos(angle), z];

//Returns the x, y of the circle point as well as the angle associated with the point
//The angle is so you now how far to rotate an object to be perpendicular to the center of the
//circle for that point
function circlePointWithAngle(radius, angle) =
        //returns [x,y] position of point given radius and angle
        [radius * sin(angle), radius * cos(angle), angle];

function getCirclePoints(radius = 10, numOfPoints = 16) = [
    let(degreesPerPoint = 360 / numOfPoints) 
    for (point = [0 : numOfPoints - 1]) 
        let(angle = degreesPerPoint * point)
        circlePoint(radius, angle)
];

function getCirclePointsWithAngle(radius = 10, numOfPoints = 16) = [
    let(degreesPerPoint = 360 / numOfPoints) 
    for (point = [0 : numOfPoints - 1]) 
        let(angle = degreesPerPoint * point)
        circlePointWithAngle(radius, angle)
];

//Z is an extra point that gets added to each vector, hardcode a z value if needed, otherwise it defaults to 0
function getOvalPointsWithZ(numOfPoints = 16, width = 4, height = 1, z = 0) = [
    let(degreesPerPoint = 360 / numOfPoints) 
    for (point = [0 : numOfPoints - 1]) 
        let(angle = degreesPerPoint * point)
        ovalPointWithZ(angle, width, height, z)
];

function getOvalPoints(numOfPoints = 16, width = 4, height = 1, degreesAround = 360) = [
    let(degreesPerPoint = degreesAround / numOfPoints) 
    for (point = [0 : numOfPoints - 1]) 
        let(angle = degreesPerPoint * point)
        ovalPoint(angle, width, height)
];

//Gets the points for an archimedes spiral
//Use a constant >1 to make the lines closer together
function getSpiralPoints(step = 5, rotations = 2, constant = 1) = [
    for (r = [0:step:rotations * 360]) getSpiralPoint(r, constant)
];

function getSpiralPoint(r, constant) = [r / constant * cos(r), r / constant * sin(r)];

function distanceBetweenPoints(point1, point2) = sqrt(pow(point2[0] - point1[0], 2) + pow(point2[1] - point1[1], 2));

//Testing
//path = [[0, 0, 0], [0, 10, 10], [0, 30, 20]];
//shape = [[0, 0], [20, 0], [10, -20]];
//shape = [[0, 0], [20, 0], [20, -20], [0, -20]];
//showShape(shape);
//showPath(path);
//hull() { showShape(shape); }
//width = 1400;
//height = width / 1.2;
//vector = getOvalPointsWithZ(numOfPoints = 500, width = width, height = height , z = 0);
//echo("Vector: ", vector);
//showShape(vector);
//points = getSpiralPoints(5, 10, 12);
//echo("Points: ", points);
//showShape(points, 8);

//linear_extrude(5) showShape(points = [ 
//    [-1.975908,-0.75],[-1.975908,0],[-1.797959,0.03212],[-1.646634,0.121224],[-1.534534,0.256431],[-1.474258,0.426861],[-1.446911,0.570808],[-1.411774,0.712722],[-1.368964,0.852287],[-1.318597,0.989189],[-1.260788,1.123115],[-1.195654,1.25375],[-1.12331,1.380781],[-1.043869,1.503892],[-0.935264,1.612278],[-0.817959,1.706414],[-0.693181,1.786237],[-0.562151,1.851687],[-0.426095,1.9027],[-0.286235,1.939214],[-0.143795,1.961168],[0,1.9685],[0.143796,1.961168],[0.286235,1.939214],[0.426095,1.9027],[0.562151,1.851687],[0.693181,1.786237],[0.817959,1.706414],[0.935263,1.612278],[1.043869,1.503892],[1.123207,1.380781],[1.195509,1.25375],[1.26065,1.123115],[1.318507,0.989189],[1.368956,0.852287],[1.411872,0.712722],[1.447132,0.570808],[1.474611,0.426861],[1.534583,0.256431],[1.646678,0.121223],[1.798064,0.03212],[1.975908,0],[1.975908,-0.75]
//], diameter = 3, debug = true);

//plotCircle(radius = 100, numOfPoints = 16, rotatePerpendicularToCenter = true) {
//    cube([3, 8, 3], center = true); 
//}
$fn = 60;
//polyline(getOvalPoints(numOfPoints = 64, width = 100, height = 50), connectLastToFirst = true, pointShape = "sphere");
//repeatObjectInArea(numOfObjects = 3, lengthOfArea = 100) {
//    sphere(3);
//}
