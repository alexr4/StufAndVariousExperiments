

PImage img ;
PShape highPoly;
PShader polyShader;
float sinInc;

void setup() {
  size(800, 800, P3D) ;
  smooth(8);
  // frameRate(2) ;

  //setting grid
  int sizeTriangle = 10;
  PVector startingPosition = new PVector(0, 0) ; 
  /*
  PVector startingPosition give the starting position for the drawing grid, the value is -1 to 1
   if you start with (0,0) the canvas start from the center, if you use the extreme value, the draw start from corner.
   this value can be interesting for the rotation axes.
   */
  //img = loadImage("mire.jpg");
  img = loadImage("purosGirl.jpg");
  //img = loadImage("pirate.jpg");
  //img = loadImage("le coq de France.jpg");
  surfaceGridImg(sizeTriangle, startingPosition, img) ;

  println("compute high Poly");
  surfaceImgColor() ;
  surfaceImgSummit() ;


  println("\tCreate high Poly mesh");
  highPoly = createShape();
  highPoly.beginShape(TRIANGLES);
  for (Polygon t : gridTriangle) {
    t.drawPolygonIn(highPoly) ;
  }
  highPoly.endShape(CLOSE);
  println("\tHigh Poly mesh has been created with "+highPoly.getVertexCount()+" vertex");
  
  println("\tLoad high Poly shader");
  polyShader = loadShader("sh_04/displacementFrag.glsl", "sh_04/displacementVert.glsl");
  PVector colorVec = new PVector(1, 1, 1);

 //polyShader.set("alpha", 1.0);
 // polyShader.set("colorTint", colorVec);
  polyShader.set("Kd", 1.0);
  polyShader.set("Ld", 1.0);


  println("HeightPoly has been computed");
}

void draw() {
  background(255) ;
  lights();
  surface() ;
  bindSinValueToShader(1.5);
  
  frame.setTitle("FPS : "+round(frameRate));
}

void bindSinValueToShader(float amp)
{
  polyShader.set("mouseInc", sin(sinInc)*amp);
  sinInc += 0.01;
}


// SURFACE

void surface() {
  //moveAllTriangle() ; // maybe use translate for the polugon position is better to preserve the Z position for the specific point?

  // moveSpecificPoint() ;

  // ?????p-ê mettre cette partie ds le setup ????????


  // display pattern
  pushMatrix() ;
  translate(width/2, height/2, -img.height) ;
  rotateX(frameCount *.002) ;
  rotateZ(frameCount *.001) ;
  shader(polyShader);
  shape(highPoly);
  popMatrix() ;
}




// ANNEXE

// CHANGE PATTERN from IMAGE
PImage imgSurface ;

void surfaceGridImg(int sizePix, PVector startingPosition, PImage imgSurface) {
  // find info from image
  this.imgSurface = imgSurface ;


  //classic grid method
  PVector canvas = new PVector(imgSurface.width, imgSurface.height);
  surfaceGrid(sizePix, canvas, startingPosition) ;
}



void surfaceImgColor() {
  /* We calculated the value of first pixel in the pixel arraylist to remove or add this "firstValue" to the other the pixel, 
   because we need have count from zero to find give the good color to the good polygon. */
  Polygon ref = (Polygon) gridTriangle.get(0) ;
  int firstValue = int((ref.pos.y -1) *imgSurface.width +ref.pos.x) ;

  for (Polygon t : gridTriangle) {
    // find the pixel in the picture import with the triangle grid to return the color to polygon.
    int  rankPixel = int((t.pos.y) *imgSurface.width +t.pos.x) -firstValue ;

    //security for the array crash
    if (rankPixel < imgSurface.pixels.length) {
      int colorTriangle = imgSurface.pixels[rankPixel] ;
      t.fillPolygon = color(colorTriangle) ;
      noStroke() ;
    }
  }
}

void surfaceImgSummit() {
  /* We calculated the value of first pixel in the pixel arraylist to remove or add this "firstValue" to the other the pixel, 
   because we need have count from zero to find give the good color to the good polygon. */
  PVector posFirstValue = (PVector) listTrianglePoint.get(0) ;
  int firstValue = int((posFirstValue.y -1) *imgSurface.width +posFirstValue.x) ;

  for (PVector pos : listTrianglePoint) {
    int  rankPixel = int((pos.y) *imgSurface.width +pos.x) -firstValue ;
    //security for the array crash
    if (rankPixel < imgSurface.pixels.length) {
      float brightness = brightness(imgSurface.pixels[rankPixel]) ;
      // this value can change with you colorMode environement
      float maxValueBrightness = 255 ;
      pos.z = map(brightness, 0, maxValueBrightness, 0, 1) ;

      // update position

      int countTriangle = 0 ;
      for (Polygon t : gridTriangle) {
        t.update_SpecificPoint_Zpos_Polygon(pos, pos.z*300) ;
        if (t.check_SpecificPoint_Polygon(pos, pos.z*300)) countTriangle++ ;
      }
    }
  }
}










// MOVE A SPECIFIC POINT
void moveSpecificPoint() {

  //find the point to move
  //int whichPoint = int(map(mouseX,0,width,0,listTrianglePoint.size())) ;
  int whichPoint = int(frameCount%listTrianglePoint.size()) ;
  int amplitude = 50 ;
  //float amplitude = map(mouseY,0,height, 10,70) ;


  PVector positionOfThisPoint = new PVector() ;
  for (int i = 0; i < listTrianglePoint.size (); i++) {
    PVector ref = (PVector) listTrianglePoint.get(whichPoint) ;
    positionOfThisPoint =ref.get() ;
  }

  // move the point
  for (Polygon p : gridTriangle) {
    p.update_SpecificPoint_Zpos_Polygon(positionOfThisPoint, sin(frameCount *.01) *amplitude) ;
  }
}















// MOVE ALL THE TRIANGLE


// WAVE MOVE
int whichTriangleMove ;
//wave
float theta = 0 ;
float wavePosition ;
float step  = .01 ;
float amplitude = 100 ;


void moveAllTriangle() {
  // wave move for triangle
  theta += .2 ;
  wavePosition = theta ;
  step = map(noise(5), 0, 1, 0, 20) ; // break the linear mode of the wave
  whichTriangleMove++ ;
  if ( whichTriangleMove > gridTriangle.size() ) whichTriangleMove = 0 ;
  //update pattern
  for ( Polygon t : gridTriangle ) {
    t.update_AllPoints_Zpos_Polygon(sin(wavePosition)*amplitude) ;
    wavePosition += step ;
  }
}
// END WAVE MOVE
