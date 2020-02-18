class Particle {
  
  KVector pos;
  KVector vel;
  KVector acc;
  float gravity;
  int mass;
  int radius;
  boolean locked;
  
  public Particle(int m, int rad) {
    pos = new KVector();
    vel = new KVector();
    acc = new KVector();
    gravity = 10;
    mass = m;
    radius = rad;
    locked = false;
  }
  
  public Particle(Particle that) {
    pos = new KVector(that.pos);
    vel = new KVector(that.vel);
    acc = new KVector(that.acc);
    gravity = 10;
    mass = that.mass;
    radius = that.radius;
    locked = false;
  }
  
  void setPos(float a, float b, float c) {
    pos.x = a;
    pos.y = b;
    pos.z = c;
  }
  
  void lock() {
    locked = true;
  }
  
  void update(float dt) {
    if (!locked) {
       vel.add(acc.scalar(dt));
       pos.add(vel.scalar(dt));
    }
    render();
  }
  
  void updateAcc(float[] forces) {
    acc.x = .5*forces[0]/mass - .5*forces[3]/mass;
    acc.y = gravity + .5*forces[1]/mass - .5*forces[4]/mass;
    //acc.z = .5*forces[2]/mass - .5*forces[5]/mass;
  }
  
  void render() {
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    sphere(radius);
    popMatrix();
  }
  
  void print(int i) {
    println("index: " + i +
            " | pos.x: " + pos.x + 
            " | pos.y: " + pos.y +
            " | pos.z: " + pos.z +
            " | vel.x: " + vel.x +
            " | vel.y: " + vel.y +
            " | vel.z: " + vel.z +
            " | acc.x: " + acc.x +
            " | acc.x: " + acc.y +
            " | acc.x: " + acc.z);
            
  }
}
