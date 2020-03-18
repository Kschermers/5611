class Node {
  
  int id;
  float xPos;
  float yPos;
  ArrayList<Link> links;
  
  
  public Node(int i, float x, float y) {
    
    id = i;
    xPos = x;
    yPos = y;
    links = new ArrayList<Link>();
  }
  
  void connect(float a, float b) {
    links.add(new Link(xPos, yPos, a, b));
  }
  
  void render() {
    circle(xPos,yPos,2);
  }
  
  void printNode() {
    println("id: " + id +
            " | xPos: " + xPos +
            " | yPos: " + yPos);
    //links.forEach(l -> l.
  }
}
