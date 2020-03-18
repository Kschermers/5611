class Agent {
  
  float xPos;
  float yPos;
  int radius;
  
  public Agent(float x, float y, int rad) {
    
    xPos = x;
    yPos = y;
    radius = rad;
  }
  
  void render() {
    circle(xPos,yPos,radius*2);
  }
  
  void move() {
    
  }
}
   
