int NUMV = 5;
float FLOOR = 500;
float GRAV = 10;
float MASS = 1;
int RAD = 3;
float RESTLEN = 10;
float KS = 5;
float KV = 10;

Particle[] p = new Particle[NUMV];
Spring[] s = new Spring[NUMV-1];

//Create Window
void setup() {
  size(1000, 1000, P3D);
  surface.setTitle("Ball on Spring!");
  for (int i = 0; i < NUMV; i++) {
    p[i] = new Particle(MASS, RAD, GRAV);
    p[i].setPos(500+(i*10),100+(i*10),0+(i*10));
    p[i].print(i);
    if (i < NUMV-1) {
      s[i] = new Spring(RESTLEN, KS, KV);
    }
  }
  p[0].lock();
}


void update(float dt) {

  s[0].calc(p[0],p[1]);
  
  for (int i = 1; i < NUMV-1; i++) {
    s[i].calc(p[i],p[i+1]);
    p[i].updateAcc(s[i-1].forces, s[i].forces);
  }
  
  KVector last = new KVector();
  p[NUMV-1].updateAcc(s[NUMV-2].forces, last);
  
  for (int j = 0; j < NUMV; j++) {
    p[j].update(dt);
    p[j].print(j);
  }
  for (int i = 0; i < NUMV; i++) {
    p[i].update(dt);
  }
}
  
  
//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  for (int i = 0; i < 100; i++) {
    update(.001);
  }
  for (Spring i : s) {
    i.render();
  }
  fill(0,0,0);
}
