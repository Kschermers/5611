import java.util.*;

class Node {
  
  int id;
  float xPos;
  float yPos;
  ArrayList<Link> links;
  boolean isGoal = false;
  int pathParent = -1;
  
  
  public Node(int i, float x, float y) {
    
    id = i;
    xPos = x;
    yPos = y;
    links = new ArrayList<Link>();
  }
  
  void connect(int eid, float a, float b) {
    links.add(new Link(id, xPos, yPos, eid, a, b));
  }
  
  void setGoal() {
    isGoal = true;
  }
  
  void setParent(int p) {
    pathParent = p;  
  }
  
  void render() {
    pushMatrix();
    circle(xPos,yPos,2);
    popMatrix();
  }
  
  void printNode() {
    println("id: " + id +
            " | xPos: " + xPos +
            " | yPos: " + yPos +
            " | parentID: " + pathParent +
            " | isGoal: " + isGoal);
  }
}
