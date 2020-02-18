int NUMV = 5;
float FLOOR = 500;
float GRAV = 10;
int MASS = 5;
int RAD = 3;
float RESTLEN = 5;
float KS = 5;
float KV = 10;

Particle[] p = new Particle[NUMV];
Spring s;

//Create Window
void setup() {
  size(1000, 1000, P3D);
  surface.setTitle("Ball on Spring!");
  for (int i = 0; i < NUMV; i++) {//0,1,2,3,4
    p[i] = new Particle(MASS, RAD, GRAV);
    p[i].setPos(500+(i*10),500+(i*25),0);
    p[i].print(i);
  }
  p[0].lock();
}


void update(float dt) {
  for (int a = 0; a < 100; a++) {
  for (int i = 1; i < NUMV; i++) {//1,2,3
    Particle[] temp;
    if (i < NUMV-1) {
      temp = new Particle[3];
      temp[0] = p[i-1];
      temp[1] = p[i];
      temp[2] = p[i+1];
    } else {
      temp = new Particle[2];
      temp[0] = p[i-1];
      temp[1] = p[i];
    }
    s = new Spring(temp, RESTLEN, KS, KV);
    s.calc();
    p[i].updateAcc(s.forces());
    p[i].update(dt);
    p[i].print(i);
    s.render();
  }
  }
}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  update(.01); //We're using a fixed, large dt -- this is a bad idea!!
  fill(0,0,0);
}
