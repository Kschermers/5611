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
    fill(0);
    circle(xPos,yPos,radius*2);
  }
}
