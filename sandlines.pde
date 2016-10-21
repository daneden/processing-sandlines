import java.util.UUID;
// uuid is going to be the randomly-generated filename if we want to save the output
String uuid = UUID.randomUUID().toString().substring(0, 16);

float granularity = random(300, 500); // this controls the number of points per line
float layers = 80; // the number of times each line is drawn

// noise offsets
float yoff = 0;
float xoff = 1000;

// use a different color each render
float h = random(255);

void setup() {
  noLoop();
  background(255);
  size(1000, 1000);
  smooth(2);
  pixelDensity(displayDensity());
  colorMode(HSB);
  
  // Slightly inset the drawing
  translate(width*0.1, height*0.1);
  
  // set an initial volatility
  float vol = random(0.6);
  
  // set the increment - this changes how many lines are drawn 
  float inc = u(4);
  
  for (int i = 0; i < height*0.8; i+=inc) {
    pushMatrix();
    translate(0, i);
    for (int j = 0; j < layers; j++) {
      float t = map(j, 0, layers, 4, 80);
      stroke(h, 200, 220, t);
      drawLine(0, width*0.8, vol);
    }
    popMatrix();
    vol += 0.15;
  }
}

float u(float p) {
  return (width/100)*p;
}

void drawLine(float x1, float x2, float volatility) {
  float w = x2 - x1;
  noFill();
  blendMode(MULTIPLY);
  beginShape();
  curveVertex(0, x1);
  for (int i = 1; i < granularity; i++) {
    float y = map(noise(yoff), 0, 1, -u(20), u(20)) * (volatility*noise(i/100));
    float x = (w/granularity)*i;
    x += map(noise(xoff), 0, 1, -u(10), u(10));
    y *= exp(i*0.01)*0.005;
    curveVertex(x, y);
    yoff += 0.1;
    xoff += 0.01;
  }
  endShape();
}

void mousePressed() {
  String name = "sandlines-" + uuid + ".png";
  saveFrame(name);
}