class Graph {
  
  ArrayList<Node> graph;
  int linkCount;
  
  public Graph() {
    graph = new ArrayList<Node>();
    linkCount = 0;
  }
  
  void setStart(int id, float x, float y) {
    graph.add(new Node(id, x, y));
    NODE_ID++;
  }
  
  void setGoal(int id, float x, float y) {
    graph.add(new Node(id, x, y));
    NODE_ID++;
  }
  
  void addNode(int i, float x, float y) {
    graph.add(new Node(i, x, y));
    NODE_ID++;
  }
  
  void link() {
     for (int i = 0; i < graph.size()-1; i++) {
       for (int j = i+1; j < graph.size(); j++) {
         Node base = graph.get(i);
         Node end = graph.get(j);
         
         for (Obstacle o: obstacles) {
           KVector d = new KVector(end.xPos - base.xPos, end.yPos - base.yPos);
           KVector f = new KVector(end.xPos - o.xPos, end.yPos - o.yPos);
           
           float a = d.dot(d);
           float b = 2*f.dot(d);
           float c = f.dot(f) - (o.radius*o.radius);
           
           float disc = b*b - (4*a*c);
           
           if (disc < 0) {
             base.connect(end.xPos, end.yPos);
             println("added link!");
             linkCount++;
           } else {
             disc = sqrt(disc);
             float t1 = ((b*-1) - disc)/(2*a);
             float t2 = ((b*-1) + disc)/(2*a);
             
             if (t1 >= 0 && t1 <= 1) {
               base.connect(end.xPos, end.yPos);
               println("added link!");
               linkCount++;
             } if (t2 >= 0 && t2 <= 1) {
               base.connect(end.xPos, end.yPos);
               println("added link!");
               linkCount++;
             }
           }
         }
         graph.set(i, base);
       }
     }
     println("links created: " + linkCount);
  }
  
  void render() {
    for (int i = 0; i < graph.size(); i++) {
      Node n = graph.get(i);
      n.render();
      for(int j = 0; j < n.links.size(); j++) {
        n.links.get(j).render();
      }
    }
  }
  
  void listNodes() {
    for (int i = 0; i < graph.size(); i++) {
      Node n = graph.get(i);
      n.printNode();
    }
  }
}
