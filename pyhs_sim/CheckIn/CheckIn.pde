int NUMW = 5;
int NUMH = 5;
float FLOOR = 500;
float GRAV = 8;
float MASS = 1;
int RAD = 1;
float RESTLEN = 10;
float KS = 5;
float KV = 5;

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
      p[i][j].setPos(500+(i*15),100+(j*15),0+(i*15));
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
  p[NUMH-1][0].lock();
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
