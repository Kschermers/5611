int numV = 5;
float[] accX = new float[numV];
float[] accY= new float[numV];
float[] velX= new float[numV];
float[] velY= new float[numV];
float[] projVel = new float[numV];
float[] posX= new float[numV];
float[] posY= new float[numV];


float floor = 500;
float gravity = 10;
float radius = 5;
float stringTopY = 300;
float stringTopX = 300;
float restLen = 10;
float mass = 5; //TRY-IT: How does changing mass affect resting length?
float k = 10; //TRY-IT: How does changing k affect resting length?
float kV = 10;

//Create Window
void setup() {
  size(1000, 1000, P3D);
  surface.setTitle("Ball on Spring!");
  for(int i = 0; i < numV; i++){
    posX[i] = stringTopX + (i*10);
    posY[i] = stringTopY + (i*25);
    velX[i] = .1;
    velY[i] = 0;
    accX[i] = 0;
    accY[i] = 0;
  }
}


void update(double dt) {
  for (int q = 0; q < 1; q++) { //10 substeps
    for (int i = 0; i < numV; i++)
    {
      accX[i] = 0; 
      accY[i] = 0;
    }
    for (int i = 1; i < numV-1; i++) {
      float sx = posX[i+1] - posX[i];
      float sy = posY[i+1] - posY[i];
      float stringLen = sqrt(sx*sx + sy*sy);
      float stringF = -k * (stringLen - restLen);
      float dirX = sx/stringLen;
      float dirY = sy/stringLen;
      float topProjVel = velX[i]*dirX + velY[i]*dirY;
      float botProjVel = velX[i+1]*dirX + velY[i+1]*dirY;
      float dampF = -kV*(botProjVel - topProjVel);
      
      float forceX = (stringF + dampF) * dirX;
      float forceY = (stringF + dampF) * dirY;
      
      accX[i] += .5*forceX/mass;
      accX[i+1] -= .5*forceX/mass;
      velX[i] += accX[i]*dt;
      posX[i] += velX[i]*dt;
      
      accY[i] += gravity + .5*forceY/mass;
      accY[i+1] -= .5*forceY/mass;
      velY[i] += accY[i]*dt;
      posY[i] += velY[i]*dt;
    }
    
    float sx = posX[numV-1] - posX[numV-2];
    float sy = posY[numV-1] - posY[numV-2];
    float stringLen = sqrt(sx*sx + sy*sy);
    float stringF = -k*(stringLen - restLen);
    float dirX = sx/stringLen;
    float dirY = sy/stringLen;
    float topProjVel = velX[numV-2]*dirX + velY[numV-2]*dirY;
    float botProjVel = velX[numV-1]*dirX + velY[numV-1]*dirY;
    float dampF = -kV*(botProjVel - topProjVel);
      
    float forceX = (stringF + dampF) * dirX;
    float forceY = (stringF + dampF) * dirY;
      
    accX[numV-1] += forceX/mass;
    accY[numV-1] += gravity + forceY/mass;
      
    velX[numV-1] += accX[numV-1]*dt;
    posX[numV-1] += velX[numV-1]*dt;
    
    velY[numV-1] += accY[numV-1]*dt;
    posY[numV-1] += velY[numV-1]*dt;
  }
}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  update(.001); //We're using a fixed, large dt -- this is a bad idea!!
  fill(0,0,0);
 
  for(int i = 0; i < numV-1; i++){
    pushMatrix();
    translate(posX[i], posY[i]);
    sphere(radius);
    popMatrix();
    pushMatrix();
    translate(posX[i+1], posY[i+1]);
    sphere(radius);
    popMatrix();
    line(posX[i], posY[i], posX[i+1], posY[i+1]);
    
  }
  
}
