class Particle {
  
  KVector pos;
  KVector vel;
  KVector acc;
  float gravity;
  float mass;
  int radius;
  boolean locked;
  
  public Particle(float m, int rad, float grav) {
    pos = new KVector();
    vel = new KVector();
    acc = new KVector();
    gravity = grav;
    mass = m;
    radius = rad;
    locked = false;
  }
  
  public Particle(Particle that) {
    pos = new KVector(that.pos);
    vel = new KVector(that.vel);
    acc = new KVector(that.acc);
    gravity = that.gravity;
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
  }
  
  void updateAcc(KVector top, KVector bot) {
    acc.x = (top.x - bot.x)/mass;
    acc.y = (gravity + top.y - bot.y)/mass;
    acc.z = (top.z - bot.z)/mass;
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
            " | acc.y: " + acc.y +
            " | acc.x: " + acc.z);
            
  }
}
