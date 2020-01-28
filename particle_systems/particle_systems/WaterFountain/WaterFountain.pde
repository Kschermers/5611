//Created by Kadin Schermers for CSCI 5561 Spring 2020
//University of Minnesota College of Science and Engineering
//Janurary 27, 2020

String projectTitle = "Particle Motion";

Fountain fountain;
float SPLASH_FACTOR = .45; //Global variable for controlling splash behavior

//Animation Principle: Separate Physical Update 
class WaterParticle {
  
  float radius; //size of drops
  float oV;
  float oY;
  float oX;
  float positionY;
  float positionX;
  float velocity; //initial velocity
  float acceleration = 9.8; //gravity
  float theta; //angle of trajectory
  float velocityY;
  float velocityX;
  float time;
  boolean flipped;
  boolean splash;
  float splashCount;
  
  WaterParticle() {
    radius = 10;
    time = 0;
    oV = random(20,40); //random velocity
    theta = random(55,80); //random angle
    flipped = false;
    randomFlip();
    oX = width/2;
    oY = height/2;
    initialVelocity();
    splash = false;
    splashCount = 0;
  }
  
  WaterParticle(WaterParticle that) {
    radius = that.radius * .75;
    time = 0;
    oV = that.velocity * SPLASH_FACTOR;
    theta = that.theta;
    flipped = that.flipped;
    oX = that.positionX;
    oY = that.positionY;
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
    velocity = oV;
    velocityX = oV * cos(radians(theta));
    velocityY = oV * sin(radians(theta));
  }
  
  void updateVelocity() {
    velocity = sqrt(pow(velocityX,2) + pow(velocityY,2));
    velocityY = oV * sin(radians(theta)) - (acceleration * time);
  }
  
  void updatePosition() {
    if (flipped) {
      positionX = oX + (oV * time * cos(radians(theta)));
    } else {
      positionX = oX - (oV * time * cos(radians(theta)));
    }
    positionY = oY - (oV * time * sin(radians(theta)) - (acceleration/2 * time * time));
  }
  
  void render() {
    fill(0,0,255);
    ellipse(positionX, positionY, radius, radius);
  }
  
  void update() {
    time += .1;
    updatePosition();
    updateVelocity();
    
    if (positionY + radius > 600){
      positionY = 600 - radius;
      splash = true;
    }
  }
 
  void run() {
    this.render();
    this.update();
  }
  
  void print() {
    println("time: " + time +
            " | oX: " + oX +
            " | oY: " + oY +
            " | posX: " + positionX +
            " | posY: " + positionY +
            " | vel: " + velocity +
            " | velY: " + velocityY +
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
     particles.add(new WaterParticle());
     particles.add(new WaterParticle());
  }

  void run() {
    for(int i = particles.size()-1; i >= 0; i--) {
      WaterParticle wp = particles.get(i);
      wp.run();
      if (wp.splash) {
        particles.remove(i);
        wp.print();
        
        if (wp.splashCount <= 2) {   
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
