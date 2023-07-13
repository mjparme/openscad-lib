module hexes(diameter = 10, lengthOfArea = 100, widthOfArea = 50, height = 10, spaceBetween = 3, rotationAngle = 90) {
    //Edge to edge of the hexagon is double the apothem, the apothem of a hexgon can be gotten by pythagorean theorem because 
    //it is just 6 equilateral right triangles. We need edgeToEdge because we are going to rotate the hexagons so vertex-to-vertex is up/down
    //so to calculate how many will fit in a row we need its edge to edge distance 
    hexRadius = diameter  / 2;
    apothem = sqrt(pow(hexRadius, 2) - pow(hexRadius / 2, 2)); //written in the form a^2 = c^2 - b^2 because we know c and b 
    edgeToEdge = 2 * apothem;

    ySpacing = diameter * 0.75 + spaceBetween;
    numberOfEvenRowHexes = floor(lengthOfArea / (edgeToEdge + spaceBetween));
    numberOfOddRowHexes = numberOfEvenRowHexes - 1;
    numberOfRows = floor(widthOfArea / ySpacing);
    longestRow = (numberOfEvenRowHexes * (edgeToEdge + spaceBetween)) - spaceBetween;
    //columnHeight only echo'd as output so callers now how high the pattern is so they can center or something like that
    //This calculation still isn't right, but it is very close...can't quite figure out the verticl distance between
    //rows, it isn't just "spaceBetween" because the in between space is at an angle, forming a right triangle, so should
    //be able to use py. theorem, but still slightly off, the a/b legs of the triangle must not be the same length like my
    //calculation is assuming
    columnHeight = (numberOfRows * .75 * diameter) + ((numberOfRows - 1) * (sqrt(pow(spaceBetween, 2) + pow(spaceBetween, 2)))); 

    echo("****Hexes Module*****")
    echo("LengthOfArea: ", lengthOfArea);
    echo("WidthOfArea: ", widthOfArea);
    echo("Diameter: ", diameter);
    echo("Radius: ", hexRadius);
    echo("Apothem: ", apothem);
    echo("EdgeToEdge: ", edgeToEdge);
    echo("SpaceBetween: ", spaceBetween);
    echo("YSpacing: ", ySpacing);
    echo("NumberOfEvenRowHexes: ", numberOfEvenRowHexes);
    echo("NumberOfOddRowHexes: ", numberOfOddRowHexes);
    echo("LongestRow: ", longestRow);
    echo("ColumnHeight: ", columnHeight);
    echo("NumberOfRows: ", numberOfRows);
    echo("****End Hexes Module*****");

    //Will put the rows and colums so left most edge is at x=0 and bottom vertex is at y=0, after that it is up to the callers
    //of this module to move it where they want it
    xPosition = edgeToEdge / 2;
    zPosition = diameter / 2;
    translate([xPosition, 0, zPosition]) rotate([rotationAngle, 0, 0]) union() {
        for (row = [0:numberOfRows - 1]) {
            oddRow = row % 2 != 0;
            y = row * ySpacing;
            if (oddRow) {
                x = (edgeToEdge + spaceBetween) / 2;
                translate([x, y, 0]) rowOfHexes(numberOfOddRowHexes);
            } else {
                translate([0, y, 0]) rowOfHexes(numberOfEvenRowHexes);
            }
        }
    }

    module rowOfHexes(count) {
        for (i = [0:count - 1]) {
            x = i * (edgeToEdge + spaceBetween);
            translate([x, 0, 0]) rotate([0, 0, 90]) cylinder(d = diameter, h = height, center = false, $fn = 6);
        }
    }
}

module hexagonPatternFixedSize(length = 50, width = 60, diameter = 14, height = 4, spaceBetween = 3) {
    hexRadius = diameter  / 2;
    apothem = sqrt(pow(hexRadius, 2) - pow(hexRadius / 2, 2)); //written in the form a^2 = c^2 - b^2 because we know c and b 
    edgeToEdge = 2 * apothem;
    ySpacing = diameter * 0.75 + spaceBetween;

    hexagonRows = ceil(width / diameter + 1);
    hexagonCols = ceil(length / diameter + 1);
    echo("Hexagon Rows: ", hexagonRows);
    echo("Hexagon Cols: ", hexagonCols);

    intersection() {
        hexagons();
        if ($children == 0) {
            cube([length, width, height]);
        } else {
            children();
        }
    }

    module hexagons() {
        for (row = [0:hexagonRows - 1]) {
            oddRow = row % 2 != 0;
            y = row * ySpacing;
            if (oddRow) {
                x = (edgeToEdge + spaceBetween) / 2;
                translate([x, y, 0]) rowOfHexes();
            } else {
                translate([0, y, 0]) rowOfHexes();
            }
        }
    }

    module rowOfHexes() {
         for (i = [0:hexagonCols - 1]) {
            x = i * (edgeToEdge + spaceBetween);
            translate([x, 0, 0]) hexagon();
        }
    }

    module hexagon() {
        rotate([0, 0, 90]) cylinder(d = diameter, h = height, $fn = 6);
    }
}

module cubes(size = 10, lengthOfArea = 100, widthOfArea = 50, height = 10, spaceBetween = 3) {
    cubePatternValues = getCubePatternValues(size, lengthOfArea, widthOfArea, spaceBetween);
    spacing = cubePatternValues[0];
    numberOfColumns = cubePatternValues[1];
    numberOfRows = cubePatternValues[2];
    rowLength = cubePatternValues[3];
    columnWidth = cubePatternValues[4];

    echo("****Cubes Module*****")
    echo("Cube Pattern values: ", cubePatternValues);
    echo("LengthOfArea: ", lengthOfArea);
    echo("WidthOfArea: ", widthOfArea);
    echo("Size: ", size);
    echo("Spacing: ", spacing);
    echo("NumberOfColumns: ", numberOfColumns);
    echo("NumberOfRows: ", numberOfRows);
    echo("RowLength: ", rowLength);
    echo("ColumnWidth: ", columnWidth);
    echo("****End Cubes Module*****");

    translate([0, height, 0]) rotate([90, 0, 0]) 
    for (row = [0:numberOfRows - 1]) {
        y = row * spacing;
        translate([0, y, 0]) rowOfCubes(numberOfColumns);
    }

    module rowOfCubes(count) {
        for (i = [0:count - 1]) {
            x = i * spacing;
            translate([x, 0, 0]) cube([size, size, height], center = false);
        }
    }
} 

/*
* Gives information about how many cubes of a certain size fit in an area of arbitrary length and width
* as well as the total length and width of the pattern of cubes. The number of cubes used will always be an integer
*
* This function can be used by users of the cubes() pattern module to get the length and width to
* center the cube pattern in whatever space they are putting it in
* 
* The returned "spacing" value is the length from the start of one cube, to the start of the next (includes the space between)
* the rest should be self-explanatory
* 
* Returns vector of: [spacing, numberOfColumns, numberOfRows, rowLength, columnWidth]
*/
function getCubePatternValues(size, lengthOfArea, widthOfArea, spaceBetween) = 
    let (spacing = size + spaceBetween, numberOfColumns = floor(lengthOfArea / spacing), numberOfRows = floor(widthOfArea / spacing))
        [
            spacing, 
            numberOfColumns, 
            numberOfRows,
            numberOfColumns * spacing - spaceBetween, 
            numberOfRows * spacing - spaceBetween 
        ];

//*************Test******************
//hexes(lengthOfArea = 194, widthOfArea = 95, diameter = 17, spaceBetween = 3.5);
//cubes(size = 15, lengthOfArea = 150, widthOfArea = 70, height = 300);
//hexagonPatternFixedSize(length = 60, width = 50, diameter = 6, height = 4, spaceBetween = 2) {
//    translate([60 / 2, 50 / 2]) circle(d = 50, $fn = 100);
//}
