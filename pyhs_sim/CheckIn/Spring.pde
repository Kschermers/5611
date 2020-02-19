class Spring {
  
  Particle top;
  Particle bot;
  float restLen;
  float kS;
  float kV;
  
  float sx = 0;
  float sy = 0;
  float sz = 0;
  float springLen = 0;
  float springF = 0;
  float dirX = 0; //TODO: Vectorize
  float dirY = 0;
  float dirZ = 0;
  float topProjVel = 0;
  float botProjVel = 0;
  float dampF = 0;
  float forceX = 0; //TODO: Vectorize
  float forceY = 0;
  float forceZ = 0;
  KVector topPos;
  KVector botPos;
  KVector forces;
  boolean last = false;
  
  Spring(float rest, float k1, float k2) {
    restLen = rest;
    kS = k1;
    kV = k2;
    dampF=0;
    forces = new KVector();
    topPos = new KVector();
    botPos = new KVector();
  }
  
  void calc(Particle a, Particle b) {
      topPos.set(a.pos);
      botPos.set(b.pos);
      sx = b.pos.x - a.pos.x;
      sy = b.pos.y - a.pos.y;
      sz = b.pos.z - a.pos.z;
      springLen = sqrt(sx*sx + sy*sy + sz*sz);
      springF = -kS*(springLen - restLen);
      dirX = sx/springLen;
      dirY = sy/springLen;
      dirZ = sz/springLen;
      topProjVel = a.vel.x * dirX + a.vel.y * dirY + a.vel.z * dirZ;
      botProjVel = b.vel.x * dirX + b.vel.y * dirY + b.vel.z * dirZ;
      dampF = -kV*(botProjVel - topProjVel);
      forces.set((springF + dampF) * dirX, 
                 (springF + dampF) * dirY, 
                 (springF + dampF) * dirZ);
      //forces.x = (springF + dampF) * dirX;
      //forces.y = (springF + dampF) * dirY;
      //forces.z = (springF + dampF) * dirZ;
  }
  
  void render() {
    line(topPos.x,topPos.y,topPos.z,botPos.x,botPos.y,topPos.z);
  }
  
  void print() {
    forces.print();
  }
}
