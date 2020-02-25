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
float dragcd = .001;

Particle[][] p = new Particle[NUMH][NUMW];
Spring[] sVert = new Spring[NUMW*(NUMH-1)];
Spring[] sHorz = new Spring[NUMH*(NUMW-1)];
KVector spherePos = new KVector(500, 100, -15);
float sphereR = 20;
Camera camera;
PImage img;
//Create Window
void setup() {
  img = loadImage("cloth_texture_1.png");
  img.resize(60, 60);
  noStroke();
  size(1000, 1000, P3D);
  camera = new Camera();
  surface.setTitle("Ball on Spring!");
  for (int i = 0; i < NUMH; i++) {
    for (int j = 0; j < NUMW; j++) {
      p[i][j] = new Particle(MASS, RAD, GRAV);
      p[i][j].setPos(600+(i*2), 50+(j*2), -30+(i*2));
      //p[i].print(i);
      p[i][j].vel = new KVector(-2, 0, 0);
      if (j==0) {
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


      if (i == 0 && j == 0) {
        vDrag.print();
      }

      p[i][j].addDrag(vDrag);
      p[i][j+1].addDrag(vDrag);     
      p[i+1][j].addDrag(vDrag);   
      p[i+1][j+1].addDrag(vDrag);
    }
  }

  //collision detection
  for (int i = 0; i < NUMH; i++) {
    for (int j = 0; j < NUMW; j++) {
      float d = (sqrt(squared(spherePos.x - p[i][j].pos.x) + squared(spherePos.y - p[i][j].pos.y) + squared(spherePos.z - p[i][j].pos.z)));
      if (abs(d) < sphereR + .09) {
        KVector n = spherePos.subtract(p[i][j].pos).scalar(-1);
        n.normalize();
        KVector bounce = n.scalar(p[i][j].vel.dot(n));
        p[i][j].vel = p[i][j].vel.subtract(bounce.scalar(1.5));
        p[i][j].pos = p[i][j].pos.add(n.scalar(.15 + sphereR - d));
      }
    }
  }
}

float squared(float x) {
  return x * x;
}
void draw() {
  if (keyPressed && key == 'i') spherePos.y -= 5;
  if (keyPressed && key == 'j') spherePos.x -= 5;
  if (keyPressed && key == 'k') spherePos.y += 5;
  if (keyPressed && key == 'l') spherePos.x += 5;
  if (keyPressed && key == 'u') spherePos.z -= 5;
  if (keyPressed && key == 'o') spherePos.z += 5;
  background(255, 255, 255);
  for (int i = 0; i < 50; i++) {
    update(.005);
  }
  pushMatrix();
  fill(255, 0, 0);
  translate(spherePos.x, spherePos.y, spherePos.z);
  sphere(sphereR);
  popMatrix();
  textureMode(IMAGE);
  beginShape(QUADS);
  texture(img);
  for (int i = 0; i < NUMH-1; i++) { //update all positions
    for (int j = 0; j < NUMW-1; j++) {
      vertex(p[i][j].pos.x, p[i][j].pos.y, p[i][j].pos.z, i*2, j*2);
      vertex(p[i+1][j].pos.x, p[i+1][j].pos.y, p[i+1][j].pos.z, i*2, j*2);
      vertex(p[i+1][j+1].pos.x, p[i+1][j+1].pos.y, p[i+1][j+1].pos.z, i*2, j*2);
      vertex(p[i][j+1].pos.x, p[i][j+1].pos.y, p[i][j+1].pos.z, i*2, j*2);
    }
  }
  endShape();


  camera.Update( 1.0/frameRate );
  String runtimeReport = 

    " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle("Cloth "+ "  -  " +runtimeReport);
}
