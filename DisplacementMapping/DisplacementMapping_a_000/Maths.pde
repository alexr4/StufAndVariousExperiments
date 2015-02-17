PVector findGravityPoint(PVector a, PVector b, PVector c)
{
  PVector gravityCenter = new PVector();
  gravityCenter.add(a);
  gravityCenter.add(b);
  gravityCenter.add(c);
  gravityCenter.div(3);

  return gravityCenter;
}

float findHypotenus(float a, float b)
{
  float h = sqrt(a*a + b*b);
  
  return h;
}

