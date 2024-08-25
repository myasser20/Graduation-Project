import 'dart:core';

/// ui standard
const standardWidth = 375.0;
const standardHeight = 815.0;

/// late init
double? screenWidth;
double? screenHeight;

/// scale [height] by [standardHeight]
double realH(double height) {
  assert(screenHeight != 0.0);
  return height / standardHeight * screenHeight!;
}

// scale [width] by [ standardWidth ]
double realW(double width) {
  assert(screenWidth != 0.0);
  return width / standardWidth * screenWidth!;
}
