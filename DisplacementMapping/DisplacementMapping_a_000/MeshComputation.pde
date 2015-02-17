void initMesh()
{
  initTexVariables();
  initMaterial();
  initMeshVariables();
  computeMesh();
  computeMeshComponents();
  createMesh();
}

void initMaterial()
{
  material = loadShader("shader/sh04/displaceFrag.glsl", "shader/sh04/displaceVert.glsl");
  material.set("displacementMap", tex);
  material.set("displaceStrength", 50.0);
}

void initTexVariables()
{
  tex = loadImage("texture/depthmap.png");
  texRatio = 600.0/800.0;
}

void initMeshVariables()
{
  meshWidth = 600.0;
  meshHeight = meshWidth*texRatio;
  resolutionWidth = 2;
  resolutionHeight = 2;


  mesh = createShape();
  normalMesh = createShape();
  wireframeMesh = createShape();
  vertList = new ArrayList<PVector> ();
  uvList = new ArrayList<PVector> ();
  normalList = new ArrayList<PVector> ();
  tempMeshList = new PVector[round(meshWidth/resolutionWidth)][round(meshHeight/resolutionHeight)];
}

void computeMesh()
{
  //ComputeFirstTable
  for (int i=0; i<round (meshWidth/resolutionWidth); i++)
  {
    for (int j=0; j<round (meshHeight/resolutionHeight); j++)
    {
      tempMeshList[i][j] = new PVector(i*resolutionWidth, j*resolutionHeight, 0);
    }
  }
}

void computeMeshComponents()
{

  for (int i=0; i<round (meshWidth/resolutionWidth); i++)
  {
    int indexi0 = i;
    int indexi1 = i;

    if (i < round(meshWidth/resolutionWidth)-1)
    {
      indexi1 = i+1;
    }

    for (int j=0; j<round (meshHeight/resolutionHeight); j++)
    {
      int indexj0 = j;
      int indexj1 = j;

      if (j < round(meshHeight/resolutionHeight)-1)
      {
        indexj1 = j+1;
      }

      PVector v0 = tempMeshList[indexi0][indexj0];
      PVector v1 = tempMeshList[indexi1][indexj0];
      PVector v2 = tempMeshList[indexi0][indexj1];
      PVector v3 = tempMeshList[indexi1][indexj1];

      //vert
      vertList.add(v0);
      vertList.add(v1);
      vertList.add(v2);

      vertList.add(v2);
      vertList.add(v1);
      vertList.add(v3);

      //normal - À  
      normalList.add(new PVector(0, 0, 1));
      normalList.add(new PVector(0, 0, 1));
      normalList.add(new PVector(0, 0, 1));

      normalList.add(new PVector(0, 0, 1));
      normalList.add(new PVector(0, 0, 1));
      normalList.add(new PVector(0, 0, 1));


      //uv
      float coordu0 = map(indexi0, 0, round(meshWidth/resolutionWidth), 0, 1);
      float coordu1 = map(indexi1, 0, round(meshWidth/resolutionWidth), 0, 1);
      float coordv0 = map(indexj0, 0, round(meshHeight/resolutionHeight), 0, 1);
      float coordv1 = map(indexj1, 0, round(meshHeight/resolutionHeight), 0, 1);


      PVector uv0 = new PVector(coordu0, coordv0);
      PVector uv1 = new PVector(coordu1, coordv0);
      PVector uv2 = new PVector(coordu0, coordv1);
      PVector uv3 = new PVector(coordu1, coordv1);

      uvList.add(uv0);
      uvList.add(uv1);
      uvList.add(uv2);

      uvList.add(uv2);
      uvList.add(uv1);
      uvList.add(uv3);
    }
  }
}

void createMesh()
{
  //Mesh
  mesh.beginShape(TRIANGLES);
  mesh.textureMode(NORMAL);
  mesh.noFill();
  mesh.noStroke();
  mesh.texture(tex);
  for (int i=0; i<vertList.size (); i++)
  {
    PVector vert = vertList.get(i);
    PVector normal = normalList.get(i);
    PVector uv = uvList.get(i);
    mesh.normal(normal.x, normal.y, normal.z);
    mesh.vertex(vert.x, vert.y, vert.z, uv.x, uv.y);
  }
  mesh.endShape();
  
  //wireframe
  PVector center = new PVector(meshWidth/2, meshHeight/2, 0);
  wireframeMesh.beginShape(TRIANGLES);
  wireframeMesh.textureMode(NORMAL);
  wireframeMesh.noFill();
  for (int i=0; i<vertList.size (); i++)
  {
    PVector vert = vertList.get(i);
    PVector normal = normalList.get(i);
    PVector uv = uvList.get(i);
    
    PVector Nvert = vert.get();
    Nvert.normalize();
    float distToCenter = PVector.dist(center, vert);
    
    float r = map(Nvert.x, 0, 1, 0, 255);
    float v = map(Nvert.y, 0, 1, 0, 255);
    float b = map(distToCenter, 0, findHypotenus(meshWidth, meshHeight)/2, 0, 255);
    
    wireframeMesh.stroke(r, v, b);
    wireframeMesh.normal(normal.x, normal.y, normal.z);
    wireframeMesh.vertex(vert.x, vert.y, vert.z, uv.x, uv.y);
  }
  wireframeMesh.endShape();
  
  //normal
  normalMesh.beginShape(LINES);
  normalMesh.noFill();
  normalMesh.stroke(255, 0, 255);
  for (int i=0; i<normalList.size (); i++)
  {
    PVector vert = vertList.get(i);
    PVector normal0 = normalList.get(i);
    PVector normal1 = normal0.get();
    PVector normalSize = new PVector(0, 0, 10);
    
    normal0.add(vert);
    normal1 = PVector.add(normalSize, normal0);
 
    normalMesh.vertex(normal0.x, normal0.y, normal0.z);
    normalMesh.vertex(normal1.x, normal1.y, normal1.z);
  }
  normalMesh.endShape();
}

