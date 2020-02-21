int numVertical = 5;
int numHorizontal = 5;
int clothWidth = numHorizontal * 10;
int clothHeight = numVertical * 10;
float FLOOR = 500;
float GRAV = 10;
float MASS = 1;
int RAD = 3;
float RESTLEN = 10;
float KS = 5;
float KV = 10;

Particle[][] p = new Particle[numVertical][numHorizontal];

Spring[] v = new Spring[(numVertical-1)*numHorizontal];
Spring[] h = new Spring[(numHorizontal-1)*numVertical];
Camera camera;
//Create Window
void setup() {
  size(1000, 1000, P3D);
  camera = new Camera();
  surface.setTitle("Ball on Spring!");
  for (int i = 0; i < numVertical; i++) {
    for (int j = 0; j < numHorizontal; j++) {
      p[i][j] = new Particle(MASS, RAD, GRAV);
      p[i][j].setPos(500+(i*10), 100+(j*10), 0+(i*10));
    }
  }
  p[0][0].lock();
  p[numVertical-1][numHorizontal-1].lock();

  for (int i = 0; i < v.length; i++) {
    v[i] = new Spring(RESTLEN, KS, KV);
  }
  for (int j = 0; j < h.length; j++) {
    h[j] = new Spring(RESTLEN, KS, KV);
  }
}

void update(float dt) {
  for (int i = 0; i < numVertical; i++) {
    for (int j = 0; i < numHorizontal; j++) {
      p[i][j].update(dt);
    }
  }
  for (int j = 0; j < numHorizontal-1; j++) {
    v[j].calc(p[0][j], p[1][j]);
  }
  for (int j = 0; j < numVertical-1; j++){
    h[j].calc(p[j][0], p[j][1]);
  }

for (int i = 1; i < numVertical -1; i++){
  for (int j = 1; j < numHorizontal - 1; j++){
    
  }
}

for (int i = 1; i < numVertical -1; i++){
  for (int j = 1; j < numHorizontal - 1; j++){
    
  }
}

    KVector last = new KVector(); 
    p[NUMV-1].updateAcc(s[NUMV-2].forces, last); 

}


//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255, 255, 255); 
    for (int i = 0; i < 100; i++) {
    update(.001);
  }
  for (Spring i : h) {
    i.render();
  }
  for (Spring i : v) {
    i.render();
  }
  fill(0, 0, 0); 
    camera.Update( 1.0/frameRate );
}
