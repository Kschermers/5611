class Link {
  
  KVector basePos;
  KVector endPos;
  
  public Link(float bxp, float byp, float exp, float eyp) {
    basePos = new KVector(bxp, byp);
    endPos = new KVector(exp, eyp);
  }
  
  void render() {
    stroke(255,0,0);
    strokeWeight(.5);
    line(basePos.x,basePos.y,endPos.x,endPos.y);
    stroke(255,255,255);
  }
}
