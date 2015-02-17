class Polygon {
  Vec4 [] points ;
  PVector pos ;
  float radius ;
  // put the alpha to zero by default in case there is polygon outside the array when you want change the color of polygone
  color fillPolygon = color(255, 0) ;
  color strokePolygon = color(0, 0) ;
  float strokeWeightPolygon = 0 ;
  int ID ;

  PShape poly;


  Polygon(PVector pos, float radius, float rotation, int num, int ID) {
    this.pos = pos.get() ;
    this.radius = radius ;
    this.ID = ID ;
    points = new Vec4 [num] ;
    float angle = TAU / num ;

    for (int i = 0; i < num; i++) {
      float newAngle = angle*i;
      float x = pos.x + cos(newAngle +rotation) *radius;
      float y = pos.y + sin(newAngle +rotation) *radius;
      float z = pos.z ;
      points[i] = new Vec4(x, y, z, ID) ;
    }

    poly = createShape();
    computePoly();
  }

  // DRAW
  void drawPolygon() {
    fill(fillPolygon) ;
    stroke(strokePolygon) ;
    strokeWeight(strokeWeightPolygon) ;
    beginShape();
    for (int i = 0; i < points.length; i++) {
      vertex(points[i].x, points[i].y, points[i].z);
    }
    endShape(CLOSE) ;
  }

void drawPolygonIn(PShape in) {
    in.fill(fillPolygon) ;
    in.stroke(strokePolygon) ;
    in.strokeWeight(strokeWeightPolygon) ;
    for (int i = 0; i < points.length; i++) {
      in.vertex(points[i].x, points[i].y, points[i].z);
    }
    
  }
  //

  void computePoly()
  {
    poly.beginShape();
    
    poly.fill(fillPolygon) ;
    poly.stroke(strokePolygon) ;
    poly.strokeWeight(strokeWeightPolygon) ;
    for (int i = 0; i < points.length; i++) {
      poly.vertex(points[i].x, points[i].y, points[i].z);
    }
    poly.endShape(CLOSE) ;
  }


  //UPDATE ALL THE POINT
  void update_AllPoints_Zpos_Polygon(float newPosZ) {
    for (int i = 0; i < points.length; i++) {
      points[i].z = newPosZ ;
    }
  }


  //UPDATE SPECIFIC POINT
  void update_SpecificPoint_Zpos_Polygon(PVector ref, float newPosZ) {
    for (int i = 0; i < points.length; i++) {
      float range = .1 ; // we use a range around the point to be sure to catch it.
      if ((ref.x <= points[i].x +range && ref.x >= points[i].x -range)  && (ref.y <= points[i].y +range && ref.y >= points[i].y -range) ) points[i].z = newPosZ ;
    }
  }


  boolean check_SpecificPoint_Polygon(PVector ref, float newPosZ) {
    boolean checked = false ;
    for (int i = 0; i < points.length; i++) {
      float range = .1 ; // we use a range around the point to be sure to catch it.
      if ((ref.x <= points[i].x +range && ref.x >= points[i].x -range)  && (ref.y <= points[i].y +range && ref.y >= points[i].y -range) ) checked = true ; 
      else checked = false ;
    }
    return checked ;
  }
}

