class Boids {
  
 public Boids() {}
 
 float[] newXVels = new float[AGENT_COUNT];
 float[] newYVels = new float[AGENT_COUNT];
 
 void boids(Agent a) {
   seperation(a);
   alignment(a);
   cohesion(a);
   obstacles(a);
   //giveVels();
 }
 
 void seperation(Agent a) {
   for (Agent b: agents) {
     if (!(a.startID == b.startID)) {
       if (!b.atGoal) {
       float dX = b.xPos - a.xPos;
       float dY = b.yPos - a.yPos;
       float dist = sqrt(dX*dX+dY*dY);
       
       if (dist <= BOIDS_RAD) {
         //println("collison!");
         a.xVel += b.xVel/3;
         a.yVel += b.yVel/3;
       } else {
         newXVels[a.startID] = a.xVel;
         newYVels[a.startID] = a.yVel;
       }
       }
     }
   }
 }
 
 void alignment(Agent a) {
   
 }
 
 void cohesion(Agent a) {
   
 }
 
 
 void obstacles(Agent a) {
   for (Obstacle o: obstacles) {
     float dX = a.xPos - o.xPos;
     float dY = a.yPos - o.yPos;
     float dist = sqrt(dX*dX+dY*dY);
       
     if (dist <= o.radius+a.radius) {
       findLine(a);
     }
   }
 }
 
 void findLine(Agent a) {
  if (!a.giveBounce) {
    /*a.giveBounce = true;
    Node base = graph.graph.get(a.path.get(a.pc));
    Node end = graph.graph.get(a.path.get(a.pc+1));
    
    KVector aToB = new KVector(a.xPos - base.xPos, a.yPos - base.yPos);
    KVector eToB = new KVector(end.xPos - base.xPos, end.yPos - base.yPos);
  
    float atb2 = eToB.mag();
    float dot = aToB.dot(eToB);
    
    float t = dot / atb2;
    
    Node n = new Node(NODE_ID, a.xPos + eToB.x*t, a.yPos + eToB.y*t);
    n.printNode();
    println(a.path.toString());
    graph.graph.add(n);
    a.path.add(a.pc+1,n.id);
    println(a.path.toString());
    NODE_ID++;*/
    a.xVel *= -2;
    a.yVel *= -.5;
    }
 }
 
 void giveVels() {
   for(Agent a: agents) {
     a.xVel = newXVels[a.startID];
     a.yVel = newYVels[a.startID];
   }
 }
}
