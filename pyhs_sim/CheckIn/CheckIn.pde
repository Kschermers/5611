int NUMW = 30;
int NUMH = 30;
float FLOOR = 500;
float GRAV = 5;
float MASS = .5;
int RAD = 1;
float RESTLEN = 3;
float KS = 70;
float KV = 25;
float dragp = 1.225;
float dragcd = 2;

Particle[][] p = new Particle[NUMH][NUMW];
Spring[] sVert = new Spring[NUMW*(NUMH-1)];
Spring[] sHorz = new Spring[NUMH*(NUMW-1)];
KVector spherePos = new KVector(500,100,-15);
float sphereR = 20;
Camera camera;
//Create Window
void setup() {
  noStroke();
  size(1000, 1000, P3D);
  camera = new Camera();
  surface.setTitle("Ball on Spring!");
  for (int i = 0; i < NUMH; i++) {
    for (int j = 0; j < NUMW; j++) {
      p[i][j] = new Particle(MASS, RAD, GRAV);
      p[i][j].setPos(600+(i*2),50+(j*2),-30+(i*2));
      //p[i].print(i);
     p[i][j].vel = new KVector(-2,0,0);
      if(j==0){
        p[i][j].lock();
      }
   }
  }
 for (int i = 0; i < sHorz.length; i ++) {
        sHorz[i] = new Spring(RESTLEN,KS,KV);
      }
 for (int j = 0; j < sVert.length; j++) {
        sVert[j] = new Spring(RESTLEN,KS,KV);
      }
     
  //p[0][0].lock();
  //p[NUMH-1][0].lock();
}

void update(float dt) {
  
  for (int i = 0; i < NUMH; i++) { //update all positions
    for (int j = 0; j < NUMW; j++) {
      p[i][j].update(dt);
    }
  }
  int vertInd = 0;
  for (int i = 0; i < NUMH-1; i++) { //calc vert springs
    for (int j = 0; j < NUMW; j++) {
      sVert[vertInd].calc(p[i][j],p[i+1][j]);
      vertInd++;
    }
  }
  int horizInd = 0;
  for (int i = 0; i < NUMW-1; i++) { //calc horz springs
    for (int j = 0; j < NUMH; j++) {
      sHorz[horizInd].calc(p[j][i],p[j][i+1]);
      horizInd++;
    }
  }
  KVector edge = new KVector();
  for (int i = 0; i < NUMH; i++) {
    for (int j = 0; j < NUMW; j ++) {
      if (i == NUMH-1 && j == NUMW-1) { //last row, last column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces, 
                          edge, //no bottom
                          sHorz[(NUMH*(j-1))+i].forces,
                          edge); //no right
      }
      else if (i == 0 && j == NUMW-1) { //first row, last column
        p[i][j].updateAcc(edge, //no top
                          sVert[(NUMW*i)+j].forces,
                          sHorz[(NUMH*(j-1))+i].forces,
                          edge); //no right
      }
      else if (j == NUMW-1) { //last column
      int vert1 =(NUMW*(i-1))+j;
      int vert2 = (NUMW*i)+j;
      int horz1 =(NUMH*(j-1))+i;
      if(vert1 < 0){
        print(i, ", ", j);
      }
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          sVert[(NUMW*i)+j].forces,
                          sHorz[(NUMH*(j-1))+i].forces,
                          edge); //no right
      }
      else if (i == NUMH-1 && j == 0) { //last row, first column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          edge, //no bottom
                          edge, //no left
                          sHorz[(NUMH*j)+i].forces);
      }
      else if (i == NUMH-1) { //bottom row
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          edge, //no bottom
                          sHorz[(NUMH*(j-1))+i].forces,
                          sHorz[(NUMH*j)+i].forces);
      }

      else if (j > 0 && i > 0) { //middle
      int vert1 =(NUMW*(i-1))+j;
      int vert2 = (NUMW*i)+j;
      int horz1 =(NUMH*(j-1))+i;
      int horz2 = (NUMH*j)+i;
     
         p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          sVert[(NUMW*i)+j].forces,
                          sHorz[(NUMH*(j-1))+i].forces,
                          sHorz[(NUMH*j)+i].forces);
      }
       else if (i == 0 && j == 0) { //first row, first column
        p[i][j].updateAcc(edge, //no top
                          sVert[(NUMW*i)+j].forces, 
                          edge, //no left
                          sHorz[(NUMH*j)+i].forces);
      }   else if (j == 0) { //first column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          sVert[(NUMW*i)+j].forces,
                          edge, //no left
                          sHorz[(NUMH*j)+i].forces);
      } else if (i == 0) { //first row
        p[i][j].updateAcc(edge, //no top
                          sVert[(NUMW*i)+j].forces,
                          sHorz[(NUMH*(j-1))+i].forces,
                          sHorz[(NUMH*j)+i].forces);
      }
    }
  }
  //not sure on order of drag and collision detection
  
  //drag
  //some way to apply the forces to particles?? since we've already updated acceleration
  //but drag needs to be calculated triangle by triangle so can't be done in same loop 
  //triangles are t1 and t2 
  //math from Guy's slides
  /*for(int i = 0; i < NUMH -1; i ++){
    for(int j = 0; j < NUMW -1; j++){
      KVector[] t1 = new KVector[3];
      t1[0] = p[i][j].pos;
      t1[1] = p[i][j+1].pos;
      t1[2] = p[i+1][j].pos;
      KVector v1 = p[i][j].vel.add(p[i][j+1].vel).add(p[i+1][j].vel).div(3);
      KVector nstar1 =  t1[1].subtract(t1[0]).cross(t1[2].subtract(t1[0]));
      KVector v2an1 = nstar1.scalar((v1.mag() * v1.dot(nstar1)) / (2*nstar1.mag()));
      KVector faero1 = v2an1.scalar(-.5 * dragp * dragcd).div(3);
      
      
      KVector[] t2 = new KVector[3];
      t2[0] = p[i][j+1].pos;
      t2[1] = p[i+1][j+1].pos;
      t2[2] = p[i+1][j].pos;
      KVector v2 = p[i][j+1].vel.add(p[i+1][j+1].vel).add(p[i+1][j].vel).div(3);
      KVector nstar2 = t2[1].subtract(t2[0]).cross(t2[2].subtract(t2[0]));
      KVector v2an2 = nstar2.scalar((v2.mag() * v2.dot(nstar2)) / (2*nstar2.mag()));
      KVector faero2 = v2an2.scalar(-.5 * dragp * dragcd).div(3);
        
        for (int k = i; k <= i + 1; k++) {
           for (int l = j; l <= j + 1; l++) {
             if (k != i + 1 && l != j + 1) { //not [i+1][j+1]
               p[k][l].addDrag(faero1);
             }
             if (k != i && l != j) { //not[i][j]
               p[k][l].addDrag(faero2);
             }
           }
        }
    }
  }*/
  
  //collision detection
  //doesn't work
  //trying to use Guy's slides
  for(int i = 0; i < NUMH; i++){
    for(int j = 0; j < NUMW; j++){
      float d = (sqrt(squared(spherePos.x - p[i][j].pos.x) + squared(spherePos.y - p[i][j].pos.y) + squared(spherePos.z - p[i][j].pos.z)));
      if (abs(d) < sphereR + .09){
        KVector n = spherePos.subtract(p[i][j].pos).scalar(-1);
        n.normalize();
        KVector bounce = n.scalar(p[i][j].vel.dot(n));
        p[i][j].vel = p[i][j].vel.subtract(bounce.scalar(1.5));
        p[i][j].pos = p[i][j].pos.add(n.scalar(.15 + sphereR - d));
      
        
      }
    }
  }
}
  
float squared(float x){
  return x * x;
}
//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  for (int i = 0; i < 100; i++) {
    update(.0025);
  }
  pushMatrix();
  fill(255,0,0);
  translate(spherePos.x,spherePos.y,spherePos.z);
  sphere(sphereR);
  popMatrix();
  //fill(0,0,0);
  beginShape(TRIANGLES);
  for (int i = 0; i < NUMH-1; i++) { //update all positions
    for (int j = 0; j < NUMW-1; j++) {
      if(j%2==0 ){
        fill(0,255,0);
      } else {
        fill(128,0,128);
      }
      //triangle 1
      vertex(p[i][j].pos.x, p[i][j].pos.y, p[i][j].pos.z);
      vertex(p[i][j+1].pos.x, p[i][j+1].pos.y, p[i][j+1].pos.z);
      vertex(p[i+1][j].pos.x, p[i+1][j].pos.y, p[i+1][j].pos.z);
      
      //triangle 2
      vertex(p[i][j+1].pos.x, p[i][j+1].pos.y, p[i][j+1].pos.z);
      vertex(p[i+1][j+1].pos.x, p[i+1][j+1].pos.y, p[i+1][j+1].pos.z);
      vertex(p[i+1][j].pos.x, p[i+1][j].pos.y, p[i+1][j].pos.z);
    }
  }
  endShape();

  
  camera.Update( 1.0/frameRate );
    String runtimeReport = 

    " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle("Cloth "+ "  -  " +runtimeReport);
}
