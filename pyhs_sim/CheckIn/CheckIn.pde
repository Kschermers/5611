int NUMW = 5;
int NUMH = 5;
float FLOOR = 500;
float GRAV = 10;
float MASS = 1;
int RAD = 1;
float RESTLEN = 10;
float KS = 5;
float KV = 10;

Particle[][] p = new Particle[NUMH][NUMW];
Spring[] sVert = new Spring[NUMW*(NUMH-1)];
Spring[] sHorz = new Spring[NUMH*(NUMW-1)];
Camera camera;
//Create Window
void setup() {
  size(1000, 1000, P3D);
  camera = new Camera();
  surface.setTitle("Ball on Spring!");
  for (int i = 0; i < NUMH; i++) {
    for (int j = 0; j < NUMW; j++) {
      p[i][j] = new Particle(MASS, RAD, GRAV);
      p[i][j].setPos(500+(i*10),100+(j*10),0+(i*10));
      //p[i].print(i);
      
   }
  }
 for (int i = 0; i < sHorz.length; i ++) {
        sHorz[i] = new Spring(RESTLEN,KS,KV);
      }
 for (int j = 0; j < sVert.length; j++) {
        sVert[j] = new Spring(RESTLEN,KS,KV);
      }
     
  p[0][0].lock();
  p[0][NUMW-1].lock();
}

void update(float dt) {

  for (int i = 0; i < NUMH; i++) { //update all positions
    for (int j = 0; j < NUMW; j++) {
      p[i][j].update(dt);
    }
  }
  for (int i = 0; i < NUMH-1; i++) { //calc vert springs
    for (int j = 0; j < NUMW; j++) {
      sVert[i+j].calc(p[i][j],p[i+1][j]);
    }
  }
  for (int i = 0; i < NUMW-1; i++) { //calc horz springs
    for (int j = 0; j < NUMH; j++) {
      sHorz[i+j].calc(p[j][i],p[j][i+1]);
    }
  }
  KVector edge = new KVector();
  for (int i = 0; i < NUMH; i++) {
    for (int j = 0; j < NUMW; j ++) {
      if (j > 0 && i > 0) { //middle
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          sVert[(NUMW*i)+j].forces,
                          sHorz[(NUMH*(j-1))+i].forces,
                          sHorz[(NUMH*j)+i].forces);
      } else if (i == NUMH-1 && j == NUMW-1) { //last row, last column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces, 
                          edge, //no bottom
                          sHorz[(NUMH*(j-1))+i].forces,
                          edge); //no right
      } else if (i == NUMH-1 && j == 0) { //last row, first column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          edge, //no bottom
                          edge, //no left
                          sHorz[(NUMH*j)+i].forces);
      } else if (i == 0 && j == NUMW-1) { //first row, last column
        p[i][j].updateAcc(edge, //no top
                          sVert[(NUMW*i)+j].forces,
                          sHorz[(NUMH*(j-1))+i].forces,
                          edge); //no right
      } else if (i == 0 && j == 0) { //first row, first column
        p[i][j].updateAcc(edge, //no top
                          sVert[(NUMW*i)+j].forces, 
                          edge, //no left
                          sHorz[(NUMH*j)+i].forces);
      } else if (j == NUMW-1) { //last column
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          sVert[(NUMW*i)+j].forces,
                          sHorz[(NUMH*(j-1))+i].forces,
                          edge); //no right
      } else if (i == NUMH-1) { //bottom row
        p[i][j].updateAcc(sVert[(NUMW*(i-1))+j].forces,
                          edge, //no bottom
                          sHorz[(NUMH*(j-1))+i].forces,
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
}
  
  
//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  for (int i = 0; i < 100; i++) {
    update(.005);
  }
  for (int i = 0; i < NUMH; i++) { //update all positions
    for (int j = 0; j < NUMW; j++) {
      p[i][j].render();
    }
  }
  for (Spring i : sVert) {
    i.render();
  }
  for (Spring i : sHorz) {
    i.render();
  }
  
  fill(0,0,0);
  camera.Update( 1.0/frameRate );
}
