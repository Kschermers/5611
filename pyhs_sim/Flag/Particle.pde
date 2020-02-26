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
    //if (!locked) {
       vel = vel.add(acc.scalar(dt));
       pos = pos.add(vel.scalar(dt));
    //}
  }
  
  void addWind() {
    acc.x += random(2,8);
    acc.y += random(-4,0);
    acc.z += random(2,8);
  }
  
  void updateAcc(KVector topVert, KVector botVert, KVector leftHorz, KVector rightHorz) {
    if (!locked){
      acc.x = ((topVert.x + leftHorz.x) - (botVert.x + rightHorz.x))/mass;
      acc.y = gravity/mass + ((topVert.y + leftHorz.y) - (botVert.y+ rightHorz.y))/mass;
      acc.z = ((topVert.z + leftHorz.z) - (botVert.z + rightHorz.z))/mass;
      addWind();
    }
  }
  
  void addDrag(KVector f) {
    if (!locked) {
      acc.x += f.x;
      acc.y += f.y;
      acc.z += f.z;
    }
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
