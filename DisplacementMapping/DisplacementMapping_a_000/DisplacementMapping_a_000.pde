/*Displacement mapping GLSL

 www.bonjour-lab.com
 contact@bonjour-lab.com
 
 Alpha 0.0.0 : 
 - Simple Displacement mapping
 
 */
import peasy.*;

//Sketch properties
int pWidth = 1280;
int pHeight = 720;
String appName = "Granit : Displacement Mapping Shader";
String version = "Alpha";
String subVersion = "0.0.8";
String frameName;
PeasyCam cam;

//Texture
PImage tex;
float texRatio;

//Mesh
PShader material;
PShape mesh;
PShape normalMesh;
PShape wireframeMesh;
PVector[][] tempMeshList;
ArrayList<PVector> vertList;
ArrayList<PVector> uvList;
ArrayList<PVector> normalList;
float meshWidth;
float meshHeight;
float resolutionWidth;
float resolutionHeight;

//Debug
boolean debug;

void setup()
{
  size(pWidth, pHeight, P3D);
  smooth(8);
  appParameter();
  cam = new PeasyCam(this, 0, 0, 0, 500);
  initMesh();
}

void draw()
{
  showFpsOnFrameTitle();
  background(200);
  lights();
  
  float res = map(mouseX, 0, width, 1, 500);
 material.set("displaceStrength", res);

  pushMatrix();
  translate((meshWidth/2)*-1, (meshHeight/2) *-1);
  shader(material);
  shape(mesh);
  popMatrix();

  if (debug)
  {
    showDebug();
  }
}

void keyPressed()
{
  if (key == 'd')
  {
    debug = !debug;
  }
}

void showDebug()
{
  pushMatrix();
  translate((meshWidth/2)*-1, (meshHeight/2) *-1);
  shape(normalMesh);
  shape(wireframeMesh);
  popMatrix();

  drawAxis(100, "RVB");
}

void appParameter()
{
  frameName = appName+"_"+version+"_"+subVersion;
  frame.setTitle(frameName);
}

void showFpsOnFrameTitle()
{
  frame.setTitle(frameName+"  -  FPS : "+int(frameRate));
}

void drawAxis(float l, String colorMode)
{
  color xAxis = color(255, 0, 0);
  color yAxis = color(0, 255, 0);
  color zAxis = color(0, 0, 255);

  if (colorMode == "rvb" || colorMode == "RVB")
  {
    xAxis = color(255, 0, 0);
    yAxis = color(0, 255, 0);
    zAxis = color(0, 0, 255);
  } else if (colorMode == "hsb" || colorMode == "HSB")
  {
    xAxis = color(0, 100, 100);
    yAxis = color(115, 100, 100);
    zAxis = color(215, 100, 100);
  }

  pushStyle();
  strokeWeight(1);
  //x-axis
  stroke(xAxis); 
  line(0, 0, 0, l, 0, 0);
  //y-axis
  stroke(yAxis); 
  line(0, 0, 0, 0, l, 0);
  //z-axis
  stroke(zAxis); 
  line(0, 0, 0, 0, 0, l);
  popStyle();
}

