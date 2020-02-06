//Created by Kadin Schermers for CSCI 5561 Spring 2020
//University of Minnesota College of Science and Engineering
//Janurary 27, 2020

String projectTitle = "Camp Fire";
import peasy.*;

Fire campfire;
PeasyCam cam;

float TIME_STEP = .055; //Global for adjusting speed of simulation
int SPAWN_RATE = 150; //Global for # of particles spawned each frame. Can drastically effect performance
int pCount = 0; //number of particles on screen

class FireParticle {
  
  PVector origin; //origin position vector
  PVector position; //position vector
  PVector velocity; //velocity vector
  float oV; //initial velocity
  float magnitude; //magnitude of velocty vector
  float acceleration = 9.8; //gravity
  
  float thetaX; //angle of trajectory
  float thetaZ;
  float radius; //size of drops
  float time; //lifetime of particle TODO: switch to 'real-time'
  boolean flipped; //direction of particle; false = left
  boolean splash; //has particle splashed
  
  int rStep = 255; //color control for fire
  int gStep = 255; //color control for fire
  
  int cStep = 0; //color control for smoke
  boolean oob; //out of bounds field
  float smokeDespawn; //randomness of smoke lifetime
  
  FireParticle() { //default constructor
    
    origin = new  PVector(width/2, height/2, 0);
    position = new PVector();
    velocity = new PVector();
    initialVelocity();
    oV = random(3,10); //random velocity
    thetaX = random(0,360); //random angle
    thetaZ = random(0,360);
    radius = 10;
    time = 0;
    flipped = false;
    randomFlip();
    splash = false;
    oob = false;
  }
  
  void initialVelocity() {
    velocity.x = oV * cos(radians(thetaX) * cos(radians(thetaZ)));
    velocity.y = oV * sin(radians(thetaX));
    velocity.z = oV * cos(radians(thetaX)) * sin(radians(thetaZ));  
    magnitude = velocity.mag();
  }
  
  void randomFlip() { //randomly determine direction of particle
    if (round(random(0,1)) >= .5) {
      flip();
    }
  }
  
  void flip() {
    flipped = !flipped;
  }
  
  void updateVelocity() {
    velocity.y = oV * sin(radians(thetaX)) - (acceleration * time);
    magnitude = velocity.mag();
  }
  
  void updatePosition() {
    if (flipped) {
      position.x = origin.x + (oV * time * cos(radians(thetaX)) * cos(radians(thetaZ)));
      position.z = origin.z + (oV * time * cos(radians(thetaX)) * sin(radians(thetaZ)));
    } else {
      position.x = origin.x - (oV * time * cos(radians(thetaX)) * cos(radians(thetaZ)));
      position.z = origin.z - (oV * time * cos(radians(thetaX)) * sin(radians(thetaZ)));
    }
    position.y = origin.y + (oV * time * sin(radians(thetaX)) - (acceleration/2 * time * time));
    
  }
  
  void render() {
    
    if (gStep == 0 && rStep == 0) {
         time = 0;
         splash = true;
         origin = new PVector(position.x, position.y, position.z);
         position = new PVector();
         smokeDespawn = random(-200,100);
         if (random(0,1) < .75) {
           oob = true; //some fire doesnt turn into smoke particle
         }
    } else if (gStep > 125) {
      gStep -= 2.5;
    } else {
      gStep -= 2.5;
      rStep -= 2.5;
      
      if (rStep < 0) {
        rStep = 0;
      } if (gStep < 0) {
        gStep = 0;
      }
    }
    stroke(rStep,gStep,0,128);
    point(position.x, position.y, position.z);
  }
  
  void update() {
    time += TIME_STEP;
    updatePosition();
    updateVelocity();
    
  }
  
  void updateSmoke() {
    time += TIME_STEP;
    randomFlip();
    if (flipped) {
      position.x = origin.x + 1.5 * sin(position.y * .05);
      position.z = origin.z + 1.5 * sin(position.y * .05);
    } else {
      position.x = origin.x + 1.5 * sin(position.y * .05);
      position.z = origin.z + 1.5 * sin(position.y * .05);
    }
    position.y = position.y - 3.5;
    
    if (position.y < smokeDespawn) {
      oob = true;
    }
  }
  
  void renderSmoke() {

    stroke(cStep,cStep,cStep,128);
    if (cStep < 125) {
      cStep += 5;
    } else {
      cStep = 125;
    }
    point(position.x, position.y, position.z);
  } 
 
  void run() {
    if (!splash) {
      this.render();
      this.update();
    } else {
      this.renderSmoke();
      this.updateSmoke();
    }
  }
  
  void print() {
    println("time: " + time +
            " | oX: " + int(origin.x) +
            " | oY: " + int(origin.y) +
            " | posX: " + int(position.x) +
            " | posY: " + int(position.y) +
            " | mag: " + int(magnitude) +
            " | velY: " + int(velocity.y) +
            " | thetaX: " + int(thetaX) +
            " | thetaZ: " + int(thetaZ) +
            " | radius: " + radius +
            " | flipped: " + flipped);
  }
}

class Fire {
   ArrayList<FireParticle> particles;
   
   Fire() {
     particles = new ArrayList();
     particles.add(new FireParticle()); //TODO: remove, for testing only
   }
 
   void spawnParticle() {
     for (int i = 0; i < SPAWN_RATE; i++) {
       particles.add(new FireParticle());
       pCount++;
     }
  }

  void run() {
    for(int i = particles.size()-1; i >= 0; i--) {
      FireParticle fp = particles.get(i);
      fp.run();
      if (fp.oob) {
        particles.remove(i);
        pCount--;
      }
    }
  }
}

void translateCam(char coord, int step) {
  float[] camCoords = cam.getLookAt();
  
  if (coord =='x') {
    cam.reset();
    cam.lookAt(camCoords[0] + step, camCoords[1], camCoords[2], 500);
  } else if (coord == 'y') {
    cam.reset();
    cam.lookAt(camCoords[0], camCoords[1] + step, camCoords[2], 500);
  }
}

void setup() {
 size(800, 800, P3D);
 strokeWeight(3.5);
 campfire = new Fire();
 cam = new PeasyCam(this, 1000);
 cam.setMinimumDistance(100);
 cam.setMaximumDistance(2000);
 cam.lookAt(width/2,height/2 - 100,0);
}

void keyPressed() {
}

void draw() {
  
  if (keyPressed && keyCode == LEFT) {
    translateCam('x', -50);
  } else if (keyPressed && keyCode == RIGHT) {
    translateCam('x', 50);
  } else if (keyPressed && keyCode == UP) {
    translateCam('y', -50);
  } else if (keyPressed && keyCode == DOWN) {
     translateCam('y', 50);
  }
  
  background(255);
  
  stroke(101,67,33);
  fill(101,67,33);
  
  pushMatrix(); //log
  translate(400,410,0);
  pushMatrix();
  rotateY(.7);
  box(75,15,20);
  popMatrix();
  popMatrix();
  
  pushMatrix(); //log
  translate(400,410,0);
  pushMatrix();
  rotateY(-.7);
  box(75,15,20);
  popMatrix();
  popMatrix();
  
  stroke(76,187,23); //grass
  fill(76,187,23);
  pushMatrix();
  translate(400,420,0);
  box(5000,10,5000);
  popMatrix();
  
  stroke(250,215,28); //sun
  fill(250,215,28);
  sphere(40);
  
  stroke(135,206,235);
  fill(135,206,235);
  pushMatrix();
  translate(0,-1000,-5000);
  box(10000,5000,5);
  popMatrix();
  
  campfire.spawnParticle();
  campfire.run();
  
  String runtimeReport = "Particles: " + str(pCount) + " | Frames: " + str(round(frameRate)) + "\n";
  surface.setTitle(runtimeReport);
}
