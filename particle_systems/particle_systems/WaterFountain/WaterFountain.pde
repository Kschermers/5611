//Created by Kadin Schermers for CSCI 5561 Spring 2020
//University of Minnesota College of Science and Engineering
//Janurary 27, 2020

String projectTitle = "Water Fountain";
import peasy.*;

Fountain fountain;
PeasyCam cam;
float TIME_STEP = .1; //Global for adjusting speed of simulation
float SPLASH_FACTOR = .45; //Global variable for controlling splash behavior
int SPLASH_COUNT = 1;  //Global for # of splashes allowed. Can drastically effect performance
int SPAWN_RATE = 100; //Global for # of particles spawned each frame. Can drastically effect performance
int pCount = 0;

class WaterParticle {
  
  PVector origin; //origin position vector
  PVector position; //position vector
  PVector velocity; //velocity vector
  float oV; //initial velocity
  float magnitude; //magnitude of velocty vector
  float acceleration = 9.8; //gravity
  
  float thetaX; //angle of trajectory
  float thetaZ; //polar angle
  float radius; //size of drops
  float time; //lifetime of particle TODO: switch to 'real-time'
  boolean flipped; //direction of particle; false = left
  boolean splash; //has particle splashed
  int splashCount; //recursion depth
  
  WaterParticle() { //default constructor
    
    origin = new  PVector(width/2, height/2, 0);
    position = new PVector();
    velocity = new PVector();
    oV = random(40,60); //random velocity
    initialVelocity();
    thetaX = random(55,80); //random launch angle
    thetaZ = random(0,360);
    radius = 10;
    time = 0;
    flipped = false;
    randomFlip();
    
    splash = false;
    splashCount = 0;
  }
  
  WaterParticle(WaterParticle that) { //recursive constructor
    
    origin = new PVector(that.position.x, that.position.y, that.position.z);
    position = new PVector();
    velocity = new PVector();
    oV = that.magnitude * SPLASH_FACTOR;
    initialVelocity();
    thetaX = that.thetaX;
    thetaZ = that.thetaZ;
    radius = that.radius * .75;
    time = 0;
    flipped = that.flipped;
    splash = false;
    splashCount = that.splashCount + 1;
  }

  void randomFlip() { //randomly determine direction of particle
    if (round(random(0,1)) >= .5) {
      flip();
    }
  }
  
  void flip() {
    flipped = !flipped;
  }
  
  void initialVelocity() {
    velocity.x = oV * cos(radians(thetaX)) * cos(radians(thetaZ));
    velocity.y = oV * sin(radians(thetaX));
    velocity.z = oV * cos(radians(thetaX)) * sin(radians(thetaZ));
    magnitude = velocity.mag();
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
    position.y = origin.y - (oV * time * sin(radians(thetaX)) - (acceleration/2 * time * time));
    
  }
  
  void render() {
    stroke(0,0,255);
    point(position.x,position.y,position.z);
  }
  
  void update() {
    time += TIME_STEP;
    updatePosition();
    updateVelocity();
    
    if (position.y + radius > 600){
      position.y = 600 - radius;
      splash = true;
    }
  }
 
  void run() {
    this.update();
    this.render();
  }
  
  void print() {
    println("time: " + time +
            " | oX: " + int(origin.x) +
            " | oY: " + int(origin.y) +
            " | oZ: " + int(origin.z) +
            " | posX: " + int(position.x) +
            " | posY: " + int(position.y) +
            " | posZ: " + int(position.z) +
            " | mag: " + int(magnitude) +
            " | thetaX: " + int(thetaX) +
            " | thetaZ: " + int(thetaZ) +
            " | radius: " + radius +
            " | flipped: " + flipped);
  }
}

class Fountain {
   ArrayList<WaterParticle> particles;
   
   Fountain() {
     particles = new ArrayList();
     particles.add(new WaterParticle());
   }
 
   void spawnParticle() {
     for (int i = 0; i < SPAWN_RATE; i++) {
       particles.add(new WaterParticle());
       pCount++;
     }
  }

  void run() {
    for(int i = particles.size()-1; i >= 0; i--) {
      WaterParticle wp = particles.get(i);
      wp.run();
      if (wp.splash) {
        particles.remove(i);
        pCount--;
        wp.print();
        
        if (wp.splashCount <= SPLASH_COUNT) {   
          particles.add(new WaterParticle(wp));
          wp.flip();
          particles.add(new WaterParticle(wp));
          pCount += 2;
        }
      }
    }
  }
}

void setup() {
 size(800, 800, P3D);
 strokeWeight(2.5);
 fountain = new Fountain();
 cam = new PeasyCam(this, 500);
 cam.setMinimumDistance(50);
 cam.setMaximumDistance(1000);
 cam.lookAt(400,400,0);
}

void draw() {
  background(255);
  fountain.spawnParticle();
  fountain.run();
  
  String runtimeReport = "Particles: " + str(pCount) + " | Frames: " + str(round(frameRate)) + "\n";
  surface.setTitle(runtimeReport);
}
