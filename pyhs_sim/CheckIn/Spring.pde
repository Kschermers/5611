class Spring {
  
  Particle top;
  Particle mid;
  Particle bot;
  float restLen;
  float kS;
  float kV;
  
  float sx = 0;
  float sy = 0;
  //float sz = 0;
  float springLen = 0;
  float springF = 0;
  float dirX = 0; //TODO: Vectorize
  float dirY = 0;
  //float dirZ = 0;
  float topProjVel = 0;
  float botProjVel = 0;
  float dampF = 0;
  float forceX1 = 0; //TODO: Vectorize
  float forceY1 = 0;
  //float forceZ1 = 0;
  float forceX2 = 0; //TODO: Vectorize
  float forceY2 = 0;
  //float forceZ2 = 0;
  boolean last = false;
  
  Spring(Particle[] p, float rest, float k1, float k2) {
    top = p[0];
    mid = p[1];
    if (p.length == 3) {
      bot = p[2];
      last = false;
    } else {
      last = true;
    }
    restLen = rest;
    kS = k1;
    kV = k2;
  }
  
  void calc() {
    
    springFuncs(top,mid,1); 
    if (!last) {
      springFuncs(mid,bot,2);
    } else {
      forceX2 = 0;
      forceY2 = 0;
      //forceZ2 = 0;
    }
  }
  
  void springFuncs(Particle a, Particle b, int i) {
      sx = b.pos.x - a.pos.x;
      sy = b.pos.y - a.pos.y;
      //sz = bot.pos.z - mid.pos.z;
      springLen = sqrt(sx*sx + sy*sy);// + sz * sz);
      springF = -kS*(springLen - restLen);
      dirX = sx/springLen;
      dirY = sy/springLen;
      //dirZ = sz/springLen;
      topProjVel = a.vel.x * dirX + a.vel.y * dirY;// + a.vel.z * dirZ;
      botProjVel = b.vel.x * dirX + b.vel.y * dirY;// + b.vel.z * dirZ;
      dampF = -kV*(botProjVel - topProjVel);
      switch (i) {
        case 1:
          forceX1 = (springF + dampF) * dirX;
          forceY1 = (springF + dampF) * dirY;
          //forceZ1 = (springF + dampF) * dirZ;
          break;
        case 2:
          forceX2 = (springF + dampF) * dirX;
          forceY2 = (springF + dampF) * dirY;
          //forceZ2 = (springF + dampF) * dirZ;
          break;
      }
  }
  
  float[] forces() {
    float[] ret = new float[6];
    ret[0] = forceX1;
    ret[1] = forceY1;
    ret[2] = 0;//forceZ1;
    ret[3] = forceX2;
    ret[4] = forceY2;
    ret[5] = 0;//forceZ2;
    return ret;
  }
  
  void render() {
    line(top.pos.x,top.pos.y,mid.pos.x,mid.pos.y);
  }
}
