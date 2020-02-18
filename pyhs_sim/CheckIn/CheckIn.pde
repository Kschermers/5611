int NUMV = 5;
float FLOOR = 500;
float GRAV = 10;
float MASS = 2;
int RAD = 3;
float RESTLEN = 5;
float KS = 1;
float KV = 5;

Particle[] p = new Particle[NUMV];
Spring[] s = new Spring[NUMV-1];

//Create Window
void setup() {
  size(1000, 1000, P3D);
  surface.setTitle("Ball on Spring!");
  for (int i = 0; i < NUMV; i++) {
    p[i] = new Particle(MASS, RAD, GRAV);
    p[i].setPos(500,100+(i*5),0);
    p[i].print(i);
    if (i < NUMV-1) {
      s[i] = new Spring(RESTLEN, KS, KV);
    }
  }
  p[0].lock();
}


void update(float dt) {

  s[0].calc(p[1],p[0]);
  s[1].calc(p[2],p[1]);
  p[1].updateAcc(s[0].forces, s[1].forces);
  
  for (int i = 2; i < NUMV-1; i++) {
    s[i].calc(p[i+1],p[i]);
    p[i].updateAcc(s[i-1].forces, s[i].forces);
  }
  
  KVector last = new KVector();
  p[NUMV-1].updateAcc(s[NUMV-2].forces, last);
  
  for (int j = 0; j < NUMV; j++) {
    p[j].update(dt);
    p[j].print(j);
    if (j < NUMV-1) {
      s[j].print();
      s[j].render();
    }
  }
}
  
  
//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  for ( int i = 0; i < 1; ++i ) {
    update(.02);
  }
  fill(0,0,0);
}
