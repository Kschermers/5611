class Link {
  
  int baseID;
  int endID;
  KVector basePos;
  KVector endPos;
  
  public Link(int bid, float bxp, float byp, int eid, float exp, float eyp) {
    baseID = bid;
    endID = eid;
    basePos = new KVector(bxp, byp);
    endPos = new KVector(exp, eyp);
  }
  
  void render() {

    line(basePos.x,basePos.y,endPos.x,endPos.y);
  }
  
  void print() {
    println("baseX: " + basePos.x +
            " | baseY: " + basePos.y +
            " | endX: " + endPos.x +
            " | endY: " + endPos.y);
  }
}
