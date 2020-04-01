class Boids {
  
 public Boids() {}
 
 void boids(Agent a) {
   seperation(a);
   alignment(a);
   cohesion(a);
 }
 
 void seperation(Agent a) {
   for (Agent b: agents) {
     if (!(a.startID == b.startID)) {
       float dX = b.xPos - a.xPos;
       float dY = b.yPos - a.yPos;
       float dist = sqrt(dX*dX+dY*dY);
       
       if (dist <= BOIDS_RAD) {
         a.xVel += (b.xVel/2);
         a.yVel += (b.yVel/2);
       }
     }
   }
 }
 
 void alignment(Agent a) {
   
 }
 
 void cohesion(Agent a) {
   
 }
}
