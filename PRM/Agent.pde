class Agent {
  
  float xPos;
  float yPos;
  int radius;
  int startID;
  int goalID;
  boolean atGoal = false;
  ArrayList<Integer> path;
  int pc;
  
  public Agent(float x, float y, int rad, int s) {
    
    xPos = x;
    yPos = y;
    radius = rad;
    startID = s;
    path = new ArrayList<Integer>();
    pc = 0;
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
  
  void setGoalID(int g) {
   goalID = g; 
  }
  
  void setPos(float x, float y) {
    xPos = x;
    yPos = y;
  }
  
  boolean atMS(float x, float y) {
    if (x - xPos < 1 && y - yPos < 1) return true;
    return false;
  }
  
  void print() {
   println("Agent xPos: " + xPos +
           " | yPos: " + yPos +
           " | sID: " + startID +
           " | gID: " + goalID);
  }
}
