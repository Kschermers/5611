import java.util.*;

class Graph {
  
  ArrayList<Node> graph;
  int linkCount;
  
  public Graph() {
    graph = new ArrayList<Node>();
    linkCount = 0;
  }
  
  void addAgentStart(int id, float x, float y) {
    graph.add(new Node(id, x, y));
    NODE_ID++;
  }
  
  void addAgentGoal(int id, float x, float y) {
    graph.add(new Node(id, x, y));
    NODE_ID++;
  }
  
  void addNode(int i, float x, float y) {
    graph.add(new Node(i, x, y));
    NODE_ID++;
  }
  
  void link() {
     for (int i = 0; i < graph.size(); i++) {
       for (int j = i+1; j < graph.size(); j++) {
         Node base = graph.get(i);
         Node end = graph.get(j);       
        
         if (!checkIntersect(base,end)) {
           base.connect(end.id, end.xPos, end.yPos);
         }
         graph.set(i, base);
       }
     }
  }
  
  boolean checkIntersect(Node base, Node end) {
    
    for (Obstacle o: obstacles) {
     KVector d = new KVector(end.xPos - base.xPos, end.yPos - base.yPos);
     KVector f = new KVector(base.xPos - o.xPos, base.yPos - o.yPos);
     
     float a = d.dot(d);
     float b = 2*f.dot(d);
     float c = f.dot(f) - pow(o.radius+AGENT_RAD,2);
     
     float disc = b*b - (4*a*c);
     
     if (disc >= 0) {
       
       disc = sqrt(disc);
       float t1 = ((b*-1) - disc)/(2*a);
       float t2 = ((b*-1) + disc)/(2*a);
       
       if (t1 >= 0 && t1 <= 1) {
         return true;
       } else if (t2 >= 0 && t2 <= 1) {
         return true;
       }      }
    }
   return false;
  }
  
  void findPath(Agent a) {
    
    boolean[] visited = new boolean[graph.size()];
    PriorityQueue<Integer> pq = new PriorityQueue<Integer>(
      new Comparator<Integer>() {
        
        public int compare(Integer i, Integer j) {
          if (graph.get(i).pathCost > graph.get(j).pathCost) {
            return 1;
          } else if (graph.get(i).pathCost < graph.get(j).pathCost) {
            return -1;
          } else {
            return 0;
          }
        }
      });    
    
    Node n = graph.get(a.startID);
  
    visited[n.id] = true;
    pq.add(n.id);
    
    while(pq.size() != 0) {
      int id = pq.poll();
      n = graph.get(id);
       
      if (n.id == a.goalID) {
         return;
      }
      for (Link l : n.links) {
        
        Node m = graph.get(l.endID);
        m.pathCost = n.pathCost + l.weight;
        graph.set(m.id,m);
        
        if (!visited[l.endID] && !pq.contains(m)) {
          
          visited[m.id] = true;
          m.setParent(n.id); 
          graph.set(m.id,m);
          pq.add(m.id);
          
        } else if (pq.contains(m.id) && m.pathCost < n.pathCost) {         
          
          m.setParent(n.id); 
          graph.set(m.id,m);
          pq.remove(m.id);
          pq.add(m.id);}      
        }
    }
  }
  
  ArrayList<Integer> buildPath(Agent a) {
    ArrayList<Integer> path = new ArrayList<Integer>();
    path.add(a.goalID);
    
    int parent = graph.get(a.goalID).pathParent;
    while (parent != a.startID && parent > 0) {
      path.add(parent);
      parent = graph.get(parent).pathParent;
    }
    path.add(parent);
    Collections.reverse(path);
    return path;
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
      for(int j = 0; j < n.links.size(); j++) {
        //n.links.get(j).print();
      }
    }
  }
}
