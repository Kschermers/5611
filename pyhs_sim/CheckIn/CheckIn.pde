int numV = 5;
float[] accX = new float[numV];
float[] accY= new float[numV];
float[] velX= new float[numV];
float[] velY= new float[numV];
float[] posX= new float[numV];
float[] posY= new float[numV];


float floor = 500;
float gravity = 2000;
float radius = 5;
float stringTopY = 50;
float stringTopX = 200;
float restLen = 40;
float mass = 1; //TRY-IT: How does changing mass affect resting length?
float k = 500; //TRY-IT: How does changing k affect resting length?
float kV = .001;

//Create Window
void setup() {
  size(1000, 1000, P3D);
  surface.setTitle("Ball on Spring!");
  for(int i = 0; i < numV; i++){
    posX[i] = stringTopX;
    posY[i] = stringTopY + (i*25);
    velX[i] = .1;
    velY[i] = 0;
    accX[i] = 0;
    accY[i] = 0;
  }
}


void update(double dt) {
  for (int q = 0; q < 10; q++) { //10 substeps
    for (int i = 0; i < numV; i++) {
      accX[i] = 0; 
      accY[i] = 0;
    } //Reset acceleration
    float projVelPrev1 = 0;
    float projVelPrev2 = 0;
    for (int i = 1; i < numV-1; i++) {
      
      float sx1 = posX[i] - posX[i-1];
      float sy1 = posY[i] - posY[i-1];
      
      float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
      float stringF1 = -k * (stringLen1 - restLen);
      
      float dirX1 = sx1/stringLen1;
      float dirY1 = sy1/stringLen1;
      
      float projVel1 = velX[i]*dirX1 + velY[i]*dirY1;
      float dampF1 = -kV*(projVel1-projVelPrev1);
      projVelPrev1 = projVel1;
      
      float forceX1 = (stringF1 + dampF1) * dirX1;
      float forceY1 = (stringF1 + dampF1) * dirY1;
      
      float sx2 = posX[i+1] - posX[i];
      float sy2 = posY[i+1] - posY[i];
      
      float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
      float stringF2 = -k * (stringLen2- restLen);
      
      float dirX2 = sx2/stringLen2;
      float dirY2 = sy2/stringLen2;
      
      float projVel2 = velX[i]*dirX2 + velY[i]*dirY2;
      float dampF2 = -kV*(projVel2-projVelPrev2);
      projVelPrev2 = projVel2;
      
      float forceX2 = (stringF2 + dampF2) * dirX2;
      float forceY2 = (stringF2 + dampF2) * dirY2;
      
      accY[i] = gravity + .5*forceY1/mass - .5*forceY2/mass;
      velY[i] += accY[i]*dt;
      posY[i] += velY[i]*dt;
      
      accX[i] = forceX1/mass - forceX2/mass;
      velX[i] += accX[i]*dt;
      posX[i] += velX[i]*dt;
     
    }

      float sx1 = posX[numV-1] - posX[numV-2];
      float sy1 = posY[numV-1] - posY[numV-2];
      float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
      float stringF1 = -k * (stringLen1 - restLen);
      float dirX1 = sx1/stringLen1;
      float dirY1 = sy1/stringLen1;
      
      float projVel = velX[numV-1]*dirX1 + velY[numV-1]*dirY1;
      
      float dampF = -kV*(projVel-projVelPrev2);
      
      float forceX1 = (stringF1 + dampF) * dirX1;
      float forceY1 = (stringF1 + dampF) * dirY1;
      
           
      accY[numV-1] = gravity + forceY1/mass;
      velY[numV-1] += accY[numV-1]*dt;
      posY[numV-1]+=velY[numV-1]*dt;
      
      accX[numV-1] = forceX1/mass;
      velX[numV-1] += accX[numV-1]*dt;
      posX[numV-1]+=velX[numV-1]*dt;
      
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