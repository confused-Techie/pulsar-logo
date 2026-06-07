
boolean SHOW_CUTOUTS = boolean("false"); // If the dev 'cutout' elements should be shown in red

// Animations (0 = false)
boolean enableAnimBeamRotation = boolean(0);
boolean enableAnimLeanRotation = boolean(0);
boolean enableAnimLeanRotationCos = boolean(0);

// Colours
color pulsarPurp = #662d91; // Purple hex value for logo
color white = color(255); // White colour of details on logo

// Values & Sizing
int leftLeanWidth = 750; // Width of the left leaning oval
int leftLeanHeight = 490; // Height of the left leaning oval
int leftLeanThickness = 32; // Thickness of the left leaning oval
float leftLeanAngle = PI/3.0; // Angle of the left leaning oval

int rightLeanWidth = leftLeanHeight; // Width of the right leaning oval
int rightLeanHeight = leftLeanWidth; // Height of the right leaning oval
int rightLeanThickness = leftLeanThickness; // Thickness of the right leaning oval
float rightLeanAngle = PI/3.0; // Angle of the right leaning oval

int outterCircleSize = 1024; // Circular size of the primary outter circle

int innerCircleSize = 350; // Circular size of the inner circle
int innerCircleThickness = 40; // Thickness of the inner circle's 'cutout'

int centerCircleSize = 167; // Circular size of center-most circle

int beamOffsetCenterX = 130; // Beam starting offset away from the center circle
int beamOffsetCenterY = 0; // Beam starting offset away from the center circle
int beamStubWidth = 45; // Beam stub (first jut from the start) largest width
int beamStubLength = 54; // Beam stub length
int beamLongLength = 300; // Beam Long (second jut away from start, connected to stub) total length
int beamEndcapSize = 30; // Beam Endcap square size (endcap cutout used to cutoff the triangle beam long to a flat end)
int startBeamSize = 43; // Circular size of starting circle for the beam
int startBeamCutoutSize = 21; // The 'cutout' (border) of the start beam circle
float beamCutoutScaleFactor = 2.0f; // The 'cutout' (border) scale factor for both the stub and long portion of the beam
float rightBeamAngle = -PI/4.0; // Angle of the right beam
float leftBeamAngle = -PI/-1.33; // Angle of the left beam

// Internal Logic
float animLeanRotationCosRightValue = rightLeanAngle;
float animLeanRotationCosLeftValue = leftLeanAngle;

// Internal Values
float originX;
float originY;

void setup() {
  size(1024, 1024);
  smooth(); // draw nicely
  noStroke(); // no shape outlines
}

void draw() {
  originX = width/2;
  originY = height/2;
  
  drawOutterCircle();
  drawLeftLean();
  drawRightLean();
  drawInnerCircle();
  drawCenterCircle();
  drawBeam(rightBeamAngle);
  drawBeam(leftBeamAngle);
  
  // Animation Options
  if (enableAnimBeamRotation) {
    animBeamRotation();
  }
  if (enableAnimLeanRotation) {
    animLeanRotation();
  }
  if (enableAnimLeanRotationCos) {
    animLeanRotationCos();
  }
}

// === Animations
void animBeamRotation() {
  float animBeamRotationValue = 0.01;
  
  rightBeamAngle = rightBeamAngle + animBeamRotationValue;
  leftBeamAngle = leftBeamAngle + animBeamRotationValue;
}

void animLeanRotation() {
  float animLeanRotationValue = 0.01;
  
  rightLeanAngle = rightLeanAngle + animLeanRotationValue;
  leftLeanAngle = leftLeanAngle + animLeanRotationValue;
}

void animLeanRotationCos() {
  
  rightLeanAngle = cos(rightLeanAngle + animLeanRotationCosRightValue);
  leftLeanAngle = cos(leftLeanAngle + animLeanRotationCosLeftValue);
  
  animLeanRotationCosRightValue += 0.02;
  animLeanRotationCosLeftValue -= 0.02;
}

// === Drawing 
void drawOutterCircle() {
  fill(pulsarPurp);
  ellipse(originX, originY, outterCircleSize, outterCircleSize);
}

void drawLeftLean() {
  pushMatrix();
  translate(originX, originY);
  rotate(leftLeanAngle);
  strokeWeight(leftLeanThickness);
  stroke(white);
  fill(0, 0, 0, 0);
  ellipse(0, 0, leftLeanWidth, leftLeanHeight);
  noStroke();
  popMatrix();
}

void drawRightLean() {
  pushMatrix();
  translate(originX, originY);
  rotate(rightLeanAngle);
  strokeWeight(rightLeanThickness);
  stroke(white);
  fill(0, 0, 0, 0);
  ellipse(0, 0, rightLeanWidth, rightLeanHeight);
  noStroke();
  popMatrix();
}

void drawInnerCircle() {
  // Inner circle (white)
  fill(white);
  ellipse(originX, originY, innerCircleSize, innerCircleSize);
  // Inner circle (purple) -- Used to make it an empty circle
  fill(pulsarPurp);
  ellipse(originX, originY, innerCircleSize-innerCircleThickness*2, innerCircleSize-innerCircleThickness*2);
}

void drawCenterCircle() {
  fill(white);
  ellipse(originX, originY, centerCircleSize, centerCircleSize);
}

void drawBeam(float rot) {
 drawBeamStartCutout(rot);
 drawBeamStubCutout(rot);
 drawBeamLongCutout(rot);
 drawBeamStart(rot);
 drawBeamStub(rot);
 drawBeamLong(rot);
 drawBeamEndCap(rot);
}

void drawBeamStartCutout(float rot) {
 pushMatrix();
 translate(originX, originY);
 rotate(rot);
 fill(pulsarPurp);
 ellipse(beamOffsetCenterX, beamOffsetCenterY, startBeamSize+(startBeamCutoutSize*2), startBeamSize+(startBeamCutoutSize*2));
 popMatrix();
}

void drawBeamStubCutout(float rot) {
  pushMatrix();
  translate(originX, originY);
  rotate(rot);
  fill(pulsarPurp);
  
  if (SHOW_CUTOUTS) { fill(255,0,0); }
  
  /*
    The `scale` function doesn't play nicely with retaining the origin point with triangles. So we will do this with just math.
    To 'scale' a triangle, the triangle's certices must move outward from it's center point (centroid) along their respective diagonal paths.
    Meaning:
    Vertex (X, Y); Center Point (Cx, Cy) by a scale factor:
    New X = Cx + (X - Cx) * Scale
    New Y = Cy + (Y - Cy) * Scale
  */
  
  // Define Centroids
  float beamStubX1 = beamOffsetCenterX;
  float beamStubX2 = beamOffsetCenterX+beamStubWidth+(startBeamSize/2);
  float beamStubX3 = beamOffsetCenterX+beamStubWidth+(startBeamSize/2);
  float beamStubY1 = beamOffsetCenterY;
  float beamStubY2 = beamOffsetCenterY+(beamStubLength/2);
  float beamStubY3 = -(beamOffsetCenterY+(beamStubLength/2));
  
  float beamStubCx = (beamStubX1 + beamStubX2 + beamStubX3) / 3.0f;
  float beamStubCy = (beamStubY1 + beamStubY2 + beamStubY3) / 3.0f;
  
  // But like the long portion, scaling up to 2.0f now means it overlaps where it shouldn't, so we will need to calculate all vertices
  
  // First caculate scaled coordinates
  float beamStubSX1 = beamStubCx + (beamStubX1 - beamStubCx) * beamCutoutScaleFactor;
  float beamStubSX2 = beamStubCx + (beamStubX2 - beamStubCx) * beamCutoutScaleFactor;
  float beamStubSX3 = beamStubCx + (beamStubX3 - beamStubCx) * beamCutoutScaleFactor;
  float beamStubSY1 = beamStubCy + (beamStubY1 - beamStubCy) * beamCutoutScaleFactor;
  float beamStubSY2 = beamStubCy + (beamStubY2 - beamStubCy) * beamCutoutScaleFactor;
  float beamStubSY3 = beamStubCy + (beamStubY3 - beamStubCy) * beamCutoutScaleFactor;
  
  float beamStubTrimEnd = 30.0f;
  float beamStubTotalX = beamStubSX2 - beamStubSX1;
  float beamStubTrimEndPerc = beamStubTrimEnd / beamStubTotalX;
  
  float beamStubTrimX2 = beamStubSX2 - beamStubTrimEnd;
  float beamStubTrimY2 = lerp(beamStubSY2, beamStubSY1, beamStubTrimEndPerc);
  float beamStubTrimX3 = beamStubSX3 - beamStubTrimEnd;
  float beamStubTrimY3 = lerp(beamStubSY3, beamStubSY1, beamStubTrimEndPerc);
  
  beginShape();
  vertex(beamStubSX1, beamStubSY1);
  vertex(beamStubTrimX2, beamStubTrimY2);
  vertex(beamStubTrimX3, beamStubTrimY3);
  vertex(beamStubSX1, beamStubSY1);
  endShape(CLOSE);

  popMatrix();
}

void drawBeamLongCutout(float rot) {
  pushMatrix();
  translate(originX, originY);
  rotate(rot);
  fill(pulsarPurp);
  if (SHOW_CUTOUTS) { fill(255,0,0); }
  // Define Centroids
  float beamLongX1 = beamOffsetCenterX+beamStubWidth+(startBeamSize/2);
  float beamLongX2 = beamOffsetCenterX+beamStubWidth+(startBeamSize/2);
  float beamLongX3 = beamOffsetCenterX+beamStubWidth+(startBeamSize/2)+beamLongLength;
  float beamLongY1 = beamOffsetCenterY+(beamStubLength/2);
  float beamLongY2 = -(beamOffsetCenterY+(beamStubLength/2));
  float beamLongY3 = 0;
  
  float beamLongCx = (beamLongX1 + beamLongX2 + beamLongX3) / 3.0f;
  float beamLongCy = (beamLongY1 + beamLongY2 + beamLongY3) / 3.0f;
  
  /*
    For the long portion, the scaled up triangle now extends past the edges of the main logo circle.
    Meaning we have to cut off a portion of it, to do so, we will need to trim the edge of the triangle, now drawing by vertices.
    And to keep the shape of the triangle on all sides we will need to use linear interpolation of it's coordinates.
    Additionally, the scaled up portion extends into the innter shapes we don't want to be excluded by the cutoff,
    so we will need to use the same logic to trim off the starting position.
  */
  
  // First lets calculate our scaled coordinates
  float beamLongSX1 = beamLongCx + (beamLongX1 - beamLongCx) * beamCutoutScaleFactor;
  float beamLongSX2 = beamLongCx + (beamLongX2 - beamLongCx) * beamCutoutScaleFactor;
  float beamLongSX3 = beamLongCx + (beamLongX3 - beamLongCx) * beamCutoutScaleFactor;
  float beamLongSY1 = beamLongCy + (beamLongY1 - beamLongCy) * beamCutoutScaleFactor;
  float beamLongSY2 = beamLongCy + (beamLongY2 - beamLongCy) * beamCutoutScaleFactor;
  float beamLongSY3 = beamLongCy + (beamLongY3 - beamLongCy) * beamCutoutScaleFactor;
  
  float beamLongTrimEnd = 200.0f; // Amount to trim off the end
  float beamLongTotalX = beamLongSX3 - beamLongSX1; // Distance from start to end
  float beamLongTrimEndPerc = beamLongTrimEnd / beamLongTotalX; // Percentage we are trimming from the end
   
  float beamLongTrimX3 = beamLongSX3 - beamLongTrimEnd;
  float beamLongTrimY3 = lerp(beamLongSY3, beamLongSY2, beamLongTrimEndPerc);
  float beamLongTrimX4 = beamLongSX3 - beamLongTrimEnd;
  float beamLongTrimY4 = lerp(beamLongSY3, beamLongSY1, beamLongTrimEndPerc);
  
  float beamLongTrimStart = 100.0f; 
  float beamLongTrimStartPerc = beamLongTrimStart / beamLongTotalX;
  
  float beamLongTrimX1 = beamLongSX1 + beamLongTrimStart;
  float beamLongTrimY1 = lerp(beamLongSY1, beamLongSY3, beamLongTrimStartPerc);
  float beamLongTrimX2 = beamLongSX2 + beamLongTrimStart;
  float beamLongTrimY2 = lerp(beamLongSY2, beamLongSY3, beamLongTrimStartPerc);
  
  beginShape();
  vertex(beamLongTrimX1, beamLongTrimY1);
  vertex(beamLongTrimX2, beamLongTrimY2);
  vertex(beamLongTrimX3, beamLongTrimY3);
  vertex(beamLongTrimX4, beamLongTrimY4);
  endShape(CLOSE);
  
  popMatrix();
}

void drawBeamStart(float rot) {
  pushMatrix();
  translate(originX, originY);
  rotate(rot);
  fill(white);
  ellipse(beamOffsetCenterX, beamOffsetCenterY, startBeamSize, startBeamSize);
  popMatrix();
}

void drawBeamStub(float rot) {
  pushMatrix();
  translate(originX, originY);
  rotate(rot);
  fill(white);
  triangle(
    beamOffsetCenterX, beamOffsetCenterY, 
    beamOffsetCenterX+beamStubWidth+(startBeamSize/2), beamOffsetCenterY+(beamStubLength/2), 
    beamOffsetCenterX+beamStubWidth+(startBeamSize/2), -(beamOffsetCenterY+(beamStubLength/2))
  );
  noStroke();
  popMatrix();
}

void drawBeamLong(float rot) {
 pushMatrix();
 translate(originX, originY);
 rotate(rot);
 fill(white);
 triangle(
    beamOffsetCenterX+beamStubWidth+(startBeamSize/2)-0.8, beamOffsetCenterY+(beamStubLength/2),
    beamOffsetCenterX+beamStubWidth+(startBeamSize/2)-0.8, -(beamOffsetCenterY+(beamStubLength/2)),
    beamOffsetCenterX+beamStubWidth+(startBeamSize/2)+beamLongLength, 0
  );
 popMatrix();
}

void drawBeamEndCap(float rot) {
  pushMatrix();
  translate(originX, originY);
  rotate(rot);
  fill(pulsarPurp);
  rect(
    (beamOffsetCenterX+beamStubWidth+(startBeamSize/2)+beamLongLength)-beamEndcapSize,
    -beamEndcapSize/2,
    beamEndcapSize,
    beamEndcapSize
  );
  noStroke();
  popMatrix();
}
