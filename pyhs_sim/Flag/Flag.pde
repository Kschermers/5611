int NUMW = 50;
int NUMH = 50;
float FLOOR = 500;
float GRAV = 2.5;
float MASS = .5;
int RAD = 1;
float RESTLEN = 3;
float KS = 150;
float KV = 30;
float dragp = 1.225;
float dragcd = .001;

Particle[][] p = new Particle[NUMH][NUMW];
Spring[] sVert = new Spring[NUMW*(NUMH-1)];
Spring[] sHorz = new Spring[NUMH*(NUMW-1)];

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
      p[i][j].setPos(300+(i*2), 0+(j*2), 0);
      //p[i].print(i);
      //p[i][j].vel = new KVector(-2, 0, 0);
      if (i==0) {
        p[i][j].lock();
      }
    }
  }
  for (int i = 0; i < sHorz.length; i ++) {
    sHorz[i] = new Spring(RESTLEN, KS, KV);
  }
  for (int j = 0; j < sVert.length; j++) {
    sVert[j] = new Spring(RESTLEN, KS, KV);
  }
}

void update(float dt) {

  for (int i = 0; i < NUMH; i++) { //update all positions
    for (int j = 0; j < NUMW; j++) {
      p[i][j].update(dt);
      if (i == 5 && j ==5) {
        p[i][j].print(5);
      }
    }
  }
  int vertInd = 0;
  for (int i = 0; i < NUMH-1; i++) { //calc vert springs
    for (int j = 0; j < NUMW; j++) {
      sVert[vertInd].calc(p[i][j], p[i+1][j]);
      vertInd++;
    }
  }
  int horizInd = 0;
  for (int i = 0; i < NUMW-1; i++) { //calc horz springs
    for (int j = 0; j < NUMH; j++) {
      sHorz[horizInd].calc(p[j][i], p[j][i+1]);
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
      } else if (i == 0 && j == NUMW-1) { //first row, last column
        p[i][j].updateAcc(edge, //no top
          sVert[(NUMW*i)+j].forces, 
          sHorz[(NUMH*(j-1))+i].forces, 
          edge); //no right
      } else if (j == NUMW-1) { //last column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces, 
          sVert[(NUMW*i)+j].forces, 
          sHorz[(NUMH*(j-1))+i].forces, 
          edge); //no right
      } else if (i == NUMH-1 && j == 0) { //last row, first column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces, 
          edge, //no bottom
          edge, //no left
          sHorz[(NUMH*j)+i].forces);
      } else if (i == NUMH-1) { //bottom row
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces, 
          edge, //no bottom
          sHorz[(NUMH*(j-1))+i].forces, 
          sHorz[(NUMH*j)+i].forces);
      } else if (j > 0 && i > 0) { //middle

        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces, 
          sVert[(NUMW*i)+j].forces, 
          sHorz[(NUMH*(j-1))+i].forces, 
          sHorz[(NUMH*j)+i].forces);
      } else if (i == 0 && j == 0) { //first row, first column
        p[i][j].updateAcc(edge, //no top
          sVert[(NUMW*i)+j].forces, 
          edge, //no left
          sHorz[(NUMH*j)+i].forces);
      } else if (j == 0) { //first column
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

  //drag
  for (int i = 0; i < NUMH -1; i ++) {
    for (int j = 0; j < NUMW -1; j++) {
      Particle[] t = new Particle[4];
      t[0] = p[i][j];
      t[1] = p[i][j+1];
      t[2] = p[i+1][j];
      t[3] = p[i+1][j+1];
      KVector v = t[0].vel.add(
        t[1].vel.add(
        t[2].vel.add(
        t[3].vel))).scalar(.25);

      KVector n = t[1].pos.subtract(t[0].pos).cross(t[2].pos.subtract(t[0].pos));
      float area = sqrt(n.dot(n));
      float vMag = sqrt(v.dot(v));
      KVector vDrag = n.scalar(-1 * dragp * dragcd * (vMag * (v.dot(n))/area));


      //if (i == 10 && j == 10) {
      //  vDrag.print();
      //}

      p[i][j].addDrag(vDrag);
      p[i][j+1].addDrag(vDrag);     
      p[i+1][j].addDrag(vDrag);   
      p[i+1][j+1].addDrag(vDrag);
    }
  }
}

float squared(float x) {
  return x * x;
}
//https://vormplus.be/full-articles/drawing-a-cylinder-with-processing
void drawCylinder(int sides, float r, float h)
{
  float angle = 360 / sides;
  float halfHeight = h / 2;
  // draw top shape
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float z = sin( radians( i * angle ) ) * r;
    vertex( x, -halfHeight , z );
  }
  endShape(CLOSE);
  // draw bottom shape
  beginShape();
  for (int i = 0; i < sides; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float z = sin( radians( i * angle ) ) * r;
    vertex( x, halfHeight, z );
  }
  endShape(CLOSE);
  // draw body
  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < sides + 1; i++) {
    float x = cos( radians( i * angle ) ) * r;
    float z = sin( radians( i * angle ) ) * r;
    vertex( x, halfHeight, z);
    vertex( x, -halfHeight,z);
  }
  endShape(CLOSE);
}
void draw() {
  background(255, 255, 255);
  for (int i = 0; i < 50; i++) {
    update(.005);
  }
  fill(0, 0, 0);
  pushMatrix();
  translate(300, 150, 0);
  //pushMatrix();
  //rotateX(300);
  drawCylinder(10,3,310);
  //// textureMode(IMAGE);
  popMatrix();
  //popMatrix();
  beginShape(QUADS);
  
 
  for (int i = 0; i < NUMH-1; i++) { //update all positions
    for (int j = 0; j < NUMW-1; j++) {
      if (j %2== 0) {
        fill(255,204,51);
      } else{
        fill(122,0,25);
      }
      vertex(p[i][j].pos.x, p[i][j].pos.y, p[i][j].pos.z);
      vertex(p[i+1][j].pos.x, p[i+1][j].pos.y, p[i+1][j].pos.z);
      vertex(p[i+1][j+1].pos.x, p[i+1][j+1].pos.y, p[i+1][j+1].pos.z);
      vertex(p[i][j+1].pos.x, p[i][j+1].pos.y, p[i][j+1].pos.z);
    }
  }
  endShape();


  camera.Update( 1.0/frameRate );
  String runtimeReport = 

    " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle("Cloth "+ "  -  " +runtimeReport);
}
