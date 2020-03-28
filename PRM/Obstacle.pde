class Obstacle {
  
  float xPos;
  float yPos;
  int radius;
  
  public Obstacle(float x, float y, int rad) {
    
    xPos = x;
    yPos = y;
    radius = rad;
  }
  
  void render() {
    pushMatrix();
    noStroke();
    fill(0,200,0);
    //noFill();
    circle(xPos,yPos,radius*2);
    popMatrix();
  }
}
