//Created by Kadin Schermers for CSCI 5561 Spring 2020
//University of Minnesota College of Science and Engineering
//Janurary 27, 2020

String projectTitle = "Camp Fire";
import peasy.*;

Fire campfire;
PeasyCam cam;
float TIME_STEP = .055; //Global for adjusting speed of simulation
int SPAWN_RATE = 40; //Global for # of particles spawned each frame. Can drastically effect performance


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
  int rStep = 255;
  int gStep = 255;
  int cStep = 0;
  boolean oob;
  
  FireParticle() { //default constructor
    
    origin = new  PVector(width/2, 600, 0);
    position = new PVector();
    velocity = new PVector();
    initialVelocity();
    oV = random(0,10); //random velocity
    thetaX = random(0,360); //random angle
    thetaZ = random(0,360);
    radius = 10;
    time = 0;
    flipped = false;
    randomFlip();
    splash = false;
    oob = false;
  }
  
  FireParticle(FireParticle that) { //recursive constructor
    
    origin = new PVector(that.position.x, that.position.y, that.position.z);
    position = new PVector();
    velocity = new PVector();
    initialVelocity();
    oV = that.magnitude;
    thetaX = that.thetaX;
    thetaZ = that.thetaZ;
    radius = that.radius * .75;
    time = 0;
    flipped = that.flipped;
    splash = false;
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
      position.x = origin.x + (oV * time * cos(radians(thetaX)));
      position.z = origin.z + (oV * time * cos(radians(thetaX)) * sin(radians(thetaZ)));
    } else {
      position.x = origin.x - (oV * time * cos(radians(thetaX)));
      position.z = origin.z - (oV * time * cos(radians(thetaX)) * sin(radians(thetaZ)));
    }
    position.y = origin.y + (oV * time * sin(radians(thetaX)) - (acceleration/2 * time * time));
    
  }
  
  void render() {
    
    if (gStep == 0 && rStep == 0) {
         print();
         time = 0;
         splash = true;
         origin = new PVector(position.x, position.y, position.z);
         position = new PVector();
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
    stroke(rStep,gStep,0);
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
      position.x = origin.x + sin(position.y * .075);
      //position.z = origin.z + sin(position.y * .075);
    } else {
      position.x = origin.x + sin(position.y * .075);
      //position.z = origin.z + sin(position.y * .075);
    }
    position.y = position.y - 3.5;
    
    if (position.y < random(-200,200)) {
      oob = true;
    }
  }
  
  void renderSmoke() {

    stroke(cStep,cStep,cStep);
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
     }
  }

  void run() {
    for(int i = particles.size()-1; i >= 0; i--) {
      FireParticle fp = particles.get(i);
      fp.run();
      if (fp.oob) {
        particles.remove(i);
      }
    }
  }
}

void setup() {
 size(800, 800, P3D);
 strokeWeight(3.5);
 campfire = new Fire();
 cam = new PeasyCam(this, 500);
 cam.setMinimumDistance(50);
 cam.setMaximumDistance(500);
 cam.lookAt(400,600,0);
}

void draw() {
  background(255);
  campfire.spawnParticle();
  campfire.run();
}
