import java.util.*;

class Node {
  
  int id;
  float xPos;
  float yPos;
  ArrayList<Link> links;
  int pathParent = -1;
  float pathCost;
  
  
  public Node(int i, float x, float y) {
    
    id = i;
    xPos = x;
    yPos = y;
    links = new ArrayList<Link>();
  }
  
  void connect(int eid, float a, float b) {
    links.add(new Link(id, xPos, yPos, eid, a, b));
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
            " | parentID: " + pathParent);
  }
}
