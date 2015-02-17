//UTIL MATH
float roots(float valueToRoots, int n ) {
  return pow(valueToRoots, 1.0/n) ;
}


// normal direction 0-360 to -1, 1 PVector
PVector normalDir(int direction) {
  int numPoints = 360;
  float angle = TWO_PI/(float)numPoints;
  direction = 360-direction;
  direction += 180;
  return new PVector(sin(angle*direction), cos(angle*direction));
}

// UTIL 
// GLOBAL CLASS
