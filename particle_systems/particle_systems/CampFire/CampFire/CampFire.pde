//Created by Kadin Schermers for CSCI 5561 Spring 2020
//University of Minnesota College of Science and Engineering
//Janurary 27, 2020

String projectTitle = "Camp Fire";

Fire campfire;
float SPLASH_FACTOR = .45; //Global variable for controlling splash behavior
int SPLASH_COUNT = 3;  //Global for # of splashes allowed. Can drastically effect performance
int SPAWN_RATE = 2; //Global for # of particles spawned each frame. Can drastically effect performance

class FireParticle {
  
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
  int rStep = 255;
  int gStep = 255;
  
  FireParticle() { //default constructor
    
    origin = new  PVector(width/2, height, 0);
    position = new PVector();
    velocity = new PVector();
    initialVelocity();
    oV = random(10,35); //random velocity
    theta = random(25,60); //random angle
    radius = 10;
    time = 0;
    flipped = false;
    randomFlip();
    splash = false;
    splashCount = 0;
  }
  
  FireParticle(FireParticle that) { //recursive constructor
    
    origin = new PVector(that.position.x, that.position.y);
    position = new PVector();
    velocity = new PVector();
    initialVelocity();
    oV = that.magnitude * SPLASH_FACTOR;
    theta = that.theta;
    radius = that.radius * .75;
    time = 0;
    flipped = that.flipped;
    splash = false;
    splashCount = that.splashCount + 1;
  }
  
  void initialVelocity() {
    velocity.x = oV * cos(radians(theta));
    velocity.y = oV * sin(radians(theta));
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
    velocity.y = oV * sin(radians(theta)) - (acceleration * time);
    magnitude = velocity.mag();
  }
  
  void updatePosition() {
    if (flipped) {
      position.x = origin.x + (oV * time * cos(radians(theta)));
    } else {
      position.x = origin.x - (oV * time * cos(radians(theta)));
    }
    position.y = origin.y + (oV * time * sin(radians(theta)) - (acceleration/2 * time * time));
  }
  
  void render() {
    fill(rStep,gStep,0);
    if (gStep > 125) {
      gStep-=2;
    } else {
      gStep-=2;
      rStep-=2;
    }
    ellipse(position.x, position.y, radius, radius);
  }
  
  void update() {
    time += .05;
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
      if (fp.splash) {
        particles.remove(i);
        fp.print();
        
        if (fp.splashCount <= SPLASH_COUNT) {   
          particles.add(new FireParticle(fp));
          fp.flip();
          particles.add(new FireParticle(fp));
        }
      }
    }
  }
}

void setup() {
 size(600, 600, P3D);
 noStroke();
 campfire = new Fire();
}

void draw() {
  background(0);
  campfire.spawnParticle();
  campfire.run();
}
