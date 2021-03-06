int _numChildren = 3;  // 子の数
int _maxLevels = 10;    // 深さ

int frameCount = 0;

Branch _trunk;         // 木オブジェクト

void setup() {
  size(700, 500);
  background(255);
  noFill();
  smooth();
  newTree();
  frameRate(3);
}

void draw() {
  background(255);
  _trunk.updateMe(width/2, height/2);
  _trunk.drawMe();
  if (frameCount <= 1000) {
  //saveFrame("frames/######.tif");
    frameCount++;
  }
}

void newTree() {
  _trunk = new Branch(1, 0, width/2, 50);
  _trunk.drawMe();
}

class Branch {
  float level, index;
  float x, y;
  float endx, endy;
  Branch[] children = new Branch[0];

  float strokeW, alph;
  float len, lenChange;
  float rot, rotChange;
  
  Branch(float lev, float ind, float ex, float why) {
    level = lev;
    index = ind;
    
    strokeW = (1/level) * 10;
    alph = 255 / level;
    len = (1/level) * random(200);
    rot = random(360);
    lenChange = random(-5, 5);
    rotChange = random(-5, 5);
    
    updateMe(ex, why);
    
    if (level < _maxLevels) {
      children = new Branch[_numChildren];
      for (int x = 0; x < _numChildren; x++) {
        children[x] = new Branch(level+1, x, endx, endy);
      }
    }
  }
  
  void updateMe(float ex, float why) {
    x = ex;
    y = why;
    
    rot += rotChange;
    if (rot > 360) {
      rot = 0;
    } else if (rot < 0) {
      rot = 360;
    }
    len -= lenChange;
    if (len < 0) {
      lenChange *= -1;
    } else if (len > 200) {
      lenChange *= -1;
    }
    float radian = radians(rot);
    
    endx = x + (len * cos(radian));
    endy = y + (len * sin(radian));
    
    for (int i = 0; i < children.length; i++) {
      children[i].updateMe(endx, endy);
    }
  }
  
  void drawMe() {
    if (level > 1) {
      strokeWeight(strokeW);
      stroke(0, alph);
      fill(255, alph);
      line(x, y, endx, endy);
      ellipse(x, y, 5, 5);
    }
    for (int i = 0; i < children.length; i++) {
      children[i].drawMe();
    } 
  }
}