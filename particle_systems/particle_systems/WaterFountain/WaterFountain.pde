//Created by Kadin Schermers for CSCI 5561 Spring 2020
//University of Minnesota College of Science and Engineering
//Janurary 27, 2020

String projectTitle = "Particle Motion";

Fountain fountain;
float SPLASH_FACTOR = .45; //Global variable for controlling splash behavior
int SPLASH_COUNT = 3;  //Global for # of splashes allowed. Can drastically effect performance
int SPAWN_RATE = 2; //Global for # of particles spawned each frame. Can drastically effect performance

class WaterParticle {
  
  //float oX; //initial x coord
  //float oY; //initial y coord
  //float oZ; //initial z coord
  PVector origin; //origin position vector
  
  //float positionY; //active y coord
  //float positionX; //active x coord
  //float positionZ; //active z coord
  PVector position; //position vector
  
  //float velocityY;
  //float velocityX;
  //float velocityZ;
  PVector velocity; //velocity vector
  float oV; //initial velocity
  float magnitude; //magnitude of velocty vector
  float acceleration = 9.8; //gravity
  
  float theta; //angle of trajectory
  float radius; //size of drops
  float time; //lifetime of particle TODO: switch to 'real-time'
  boolean flipped; //direction of particle; false = left
  boolean splash; //has particle splashed
  int splashCount; //recursion depth
  
  WaterParticle() { //default constructor
    
    origin = new  PVector(width/2, height/2, 0);
    position = new PVector();
    velocity = new PVector();
    oV = random(20,40); //random velocity
    theta = random(55,80); //random angle
    radius = 10;
    time = 0;
    flipped = false;
    randomFlip();
    initialVelocity();
    splash = false;
    splashCount = 0;
  }
  
  WaterParticle(WaterParticle that) { //recursive constructor
    
    origin = new PVector(that.position.x, that.position.y);
    position = new PVector();
    velocity = new PVector();
    oV = that.magnitude * SPLASH_FACTOR;
    theta = that.theta;
    radius = that.radius * .75;
    time = 0;
    flipped = that.flipped;
    initialVelocity();
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
    velocity.x = oV * cos(radians(theta));
    velocity.y = oV * sin(radians(theta));
    magnitude = velocity.mag();
  }
  
  void updateVelocity() {
    velocity.y = oV * sin(radians(theta)) - (acceleration * time);
    magnitude = velocity.mag();
  }
  
  void updatePosition() {
    if (flipped) {
      position.x = origin.x + (oV * time * cos(radians(theta)));
    } else {
      position.x = origin.x - (oV * time * cos(radians(theta)));
    }
    position.y = origin.y - (oV * time * sin(radians(theta)) - (acceleration/2 * time * time));
  }
  
  void render() {
    fill(0,0,255);
    ellipse(position.x, position.y, radius, radius);
  }
  
  void update() {
    time += .1;
    updatePosition();
    updateVelocity();
    
    if (position.y + radius > 600){
      position.y = 600 - radius;
      splash = true;
    }
  }
 
  void run() {
    this.render();
    this.update();
  }
  
  void print() {
    println("time: " + time +
            " | oX: " + origin.x +
            " | oY: " + origin.y +
            " | posX: " + position.x +
            " | posY: " + position.y +
            " | mag: " + magnitude +
            " | velY: " + velocity.y +
            " | theta: " + theta +
            " | radius: " + radius +
            " | flipped: " + flipped);
  }
}

class Fountain {
   ArrayList<WaterParticle> particles;
   
   Fountain() {
     particles = new ArrayList();
     particles.add(new WaterParticle()); //TODO: remove, for testing only
   }
 
   void spawnParticle() {
     for (int i = 0; i < SPAWN_RATE; i++) {
       particles.add(new WaterParticle());
     }
  }

  void run() {
    for(int i = particles.size()-1; i >= 0; i--) {
      WaterParticle wp = particles.get(i);
      wp.run();
      if (wp.splash) {
        particles.remove(i);
        wp.print();
        
        if (wp.splashCount <= SPLASH_COUNT) {   
          particles.add(new WaterParticle(wp));
          wp.flip();
          particles.add(new WaterParticle(wp));
        }
      }
    }
  }
}

void setup() {
 size(600, 600, P3D);
 noStroke();
 fountain = new Fountain();
}

void draw() {
  background(0);
  fountain.spawnParticle();
  fountain.run();
}
