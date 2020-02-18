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
    sx = mid.pos.x - top.pos.x;
    sy = mid.pos.y - top.pos.y;
    //sz = mid.pos.z - top.pos.z;
    springLen = sqrt(sx*sx + sy*sy);// + sz * sz);
    springF = -kS*(springLen - restLen);
    dirX = sx/springLen;
    dirY = sy/springLen;
    //dirZ = sz/springLen;
    topProjVel = top.vel.x * dirX + top.vel.y * dirY;// + top.vel.z * dirZ;
    botProjVel = mid.vel.x * dirX + mid.vel.y * dirY;// + mid.vel.z * dirZ;
    dampF = -kV*(botProjVel - topProjVel);
    forceX1 = (springF + dampF) * dirX;
    forceY1 = (springF + dampF) * dirY;
    //forceZ1 = (springF + dampF) * dirZ;
    
    if (!last) {
      sx = bot.pos.x - mid.pos.x;
      sy = bot.pos.y - mid.pos.y;
      //sz = bot.pos.z - mid.pos.z;
      springLen = sqrt(sx*sx + sy*sy);// + sz * sz);
      springF = -kS*(springLen - restLen);
      dirX = sx/springLen;
      dirY = sy/springLen;
      //dirZ = sz/springLen;
      topProjVel = mid.vel.x * dirX + mid.vel.y * dirY;// + mid.vel.z * dirZ;
      botProjVel = bot.vel.x * dirX + bot.vel.y * dirY;// + bot.vel.z * dirZ;
      dampF = -kV*(botProjVel - topProjVel);
      forceX2 = (springF + dampF) * dirX;
      forceY2 = (springF + dampF) * dirY;
      //forceZ2 = (springF + dampF) * dirZ;
    } else {
      forceX2 = 0;
      forceY2 = 0;
      //forceZ2 = 0;
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
