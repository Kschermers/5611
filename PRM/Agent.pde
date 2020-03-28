class Agent {
  
  float xPos;
  float yPos;
  int radius;
  boolean atGoal = false;
  
  public Agent(float x, float y, int rad) {
    
    xPos = x;
    yPos = y;
    radius = rad;
  }
  
  void render() {
    pushMatrix();
    noStroke();
    fill(200,0,0);
    circle(xPos,yPos,radius);
    popMatrix();
  }
  
  void move(float x, float y) {
    if (!atGoal) {
      xPos += x;
      yPos += y;
    }
  }
  
  void set(float x, float y) {
    xPos = x;
    yPos = y;
  }
  
  boolean atMS(float x, float y) {
    if (x - xPos < .25 && y - yPos < .25) return true;
    return false;
  }
}
   
