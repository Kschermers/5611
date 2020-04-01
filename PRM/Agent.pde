class Agent {
  
  float xPos;
  float yPos;
  float xVel;
  float yVel;
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
  
  void setGoalID(int g) {
   goalID = g; 
  }
  
  void updatePos() {
    if (!atGoal) {
      xPos += xVel;
      yPos += yVel;
    }
  }
   
  void setPos(float x, float y) {
    xPos = x;
    yPos = y;
  }
  
  void updateVel(float x, float y) {
    xVel = x;
    yVel = y;
  }
  
    void render() {
    pushMatrix();
    noStroke();
    fill(200,0,0);
    circle(xPos,yPos,radius);
    popMatrix();
  }
  
  boolean atMS(float x, float y) {
    
    if (x - xPos < 1 && x - xPos > -1) {
      if (y - yPos < 1 && y - yPos > -1) {
        setPos(x,y);
        return true;
       } else {
         return false;
       } 
    } else {
       return false;
    }
  }
  
  void print() {
   println("Agent xPos: " + xPos +
           " | yPos: " + yPos +
           " | sID: " + startID +
           " | gID: " + goalID);
  }
}
