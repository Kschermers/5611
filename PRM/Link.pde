class Link {
  
  int baseID;
  int endID;
  KVector basePos;
  KVector endPos;
  float weight;
  boolean hasAgent = false;
  
  public Link(int bid, float bxp, float byp, int eid, float exp, float eyp) {
    baseID = bid;
    endID = eid;
    basePos = new KVector(bxp, byp);
    endPos = new KVector(exp, eyp);
    setWeight();
  }
  
  void setWeight() {
    float x = endPos.x - basePos.x;
    float y = endPos.y - basePos.y;
    weight = sqrt(x*x + y*y);
  }
  
  void render() {
    
    pushMatrix();
    if (hasAgent) {
      stroke(0,0,200);
      strokeWeight(1);
    } else {
      stroke(200,200,200);
      strokeWeight(.5);
    }
    
    line(basePos.x,basePos.y,endPos.x,endPos.y);
    popMatrix();
  }
  
  void print() {
    println("baseX: " + basePos.x +
            " | baseY: " + basePos.y +
            " | endX: " + endPos.x +
            " | endY: " + endPos.y);
  }
}
