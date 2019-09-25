// CS 7492 - Simulation of Biology
// Project 2 - Flocking Simulator
// Author: Austin Passmore

ArrayList<Boid> boidList = new ArrayList<Boid>();
int boidNum = 16;

float boidSize = 20;
float neighborRadius = 100;

// Flags for flocking variables
boolean isCentering = true;
boolean isMatching = true;
boolean isAvoiding = true;
boolean isWandering = true;

// Weights for flocking variables
float centeringWeight = 0.001;
float matchingWeight = 0.00015;
float avoidingWeight = 0.00002;
float wanderingWeight = 0.005;

// Controls if the simulation is paused or not
boolean isPaused = false;

// Controls whether Boid paths will be shown
boolean isShowPath = false;

// Controls if the Boids are attracted or repulsed by the mouse
boolean isAttracted = false;
boolean isRepulsed = false;
float mouseRadiusA = 350;
float mouseRadiusR = 200;
float mouseWeight = 0.0008;

// Variables to clamp velocities
float minVelocity = -2;
float maxVelocity = 2;

void setup() {
  size(800, 800);
  background(0, 0, 0);
  noStroke();

  for (int n = 0; n < 16; n++) {
    float posX = random(800 - (boidSize * 2)) + boidSize;
    float posY = random(800 - (boidSize * 2)) + boidSize;
    float velX = random(7) - 3;
    float velY = random(7) - 3;
    Boid aBoid = new Boid(posX, posY, velX, velY);
    boidList.add(aBoid);
  }
}

void draw() {
  if (!isPaused) {
    clear();
    for (int n = 0; n < boidList.size(); n++) {
      Boid thisBoid = boidList.get(n);
      float weightSum = 0;
      float centeringX = 0;
      float centeringY = 0;
      float matchingX = 0;
      float matchingY = 0;
      float avoidingX = 0;
      float avoidingY = 0;
      float wanderingX = 0;
      float wanderingY = 0;
      
      // Attraction to or Repulsion from the mouse
      if (mousePressed == true) {
        if (isAttracted) {
          float newVelX = mouseX - thisBoid.getCurrPosX();
          float newVelY = mouseY - thisBoid.getCurrPosY();
          float dist = sqrt((newVelX * newVelX) + (newVelY * newVelY));
          if (mouseRadiusA - dist >= 0) {
            float currVelX = thisBoid.getVelX();
            float currVelY = thisBoid.getVelY();
            thisBoid.setVelX(currVelX + mouseWeight * newVelX);
            thisBoid.setVelY(currVelY + mouseWeight * newVelY);
          }
        } else if (isRepulsed) {
          float newVelX = thisBoid.getCurrPosX() - mouseX;
          float newVelY = thisBoid.getCurrPosY() - mouseY;
          float dist = sqrt((newVelX * newVelX) + (newVelY * newVelY));
          if (mouseRadiusR - dist >= 0) {
            float currVelX = thisBoid.getVelX();
            float currVelY = thisBoid.getVelY();
            thisBoid.setVelX(currVelX + mouseWeight * newVelX);
            thisBoid.setVelY(currVelY + mouseWeight * newVelY);
          }
        }
      }
  
      for (int i = 0; i < boidList.size(); i++) {
        if (i != n) {
          Boid thatBoid = boidList.get(i);
  
          float dist = calcDistance(thisBoid, thatBoid);
          float weight = max(neighborRadius - dist, 0);
          weightSum += weight;
  
          // Flock centering force
          if (isCentering) {
            centeringX += weight * (thatBoid.getCurrPosX() - thisBoid.getCurrPosX());
            centeringY += weight * (thatBoid.getCurrPosY() - thisBoid.getCurrPosY());
          }
  
          // Mating velocities force
          if (isMatching) {
            matchingX += weight * (thatBoid.getVelX() - thisBoid.getVelX());
            matchingY += weight * (thatBoid.getVelY() - thisBoid.getVelY());
          }
  
          // Collision avoidance force
          if (isAvoiding) {
            avoidingX += weight * (thisBoid.getCurrPosX() - thatBoid.getCurrPosX());
            avoidingY += weight * (thisBoid.getCurrPosY() - thatBoid.getCurrPosY());
          }
  
          // Wandering force
          if (isWandering) {
            wanderingX += (random(200) - 100.0) / 100.0;
            wanderingY += (random(200) - 100.0) / 100.0;
          }
        }
      }
  
      if (weightSum != 0) {
        centeringX = centeringX / weightSum;
        centeringY = centeringY / weightSum;
      }
  
      // Update the Boid's new velocity
      float velX = thisBoid.getVelX();
      float velY = thisBoid.getVelY();
  
      velX += (centeringWeight * centeringX) + (matchingWeight * matchingX) + (avoidingWeight * avoidingX) + (wanderingWeight * wanderingX);
      velY += (centeringWeight * centeringY) + (matchingWeight * matchingY) + (avoidingWeight * avoidingY) + (wanderingWeight * wanderingY);
  
      // Clamp velocities
      if (velX < minVelocity) {
        velX = minVelocity;
      }
      if (velX > maxVelocity) {
        velX = maxVelocity;
      }
      if (velY < minVelocity) {
        velY = minVelocity;
      }
      if (velY > maxVelocity) {
        velY = maxVelocity;
      }
      
      thisBoid.setVelX(velX);
      thisBoid.setVelY(velY);
  
      // Update the Boid's position
      thisBoid.updatePosition();
      
      // Draw Boid and its path
      if (isShowPath) {
        thisBoid.drawPath();
      }
      thisBoid.drawBoid();
    }
    //delay(100);
  }
}

// Controls keyboard inputs
void keyPressed() {
  if (key == '1') {            // Toggle flock centering
    if (isCentering) {
      isCentering = false;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    } else {
      isCentering = true;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    }
  } else if (key == '2') {     // Toggle velocity matching
    if (isMatching) {
      isMatching = false;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    } else {
      isMatching = true;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    }
  } else if (key == '3') {     // Toggle collision avoidance
    if (isAvoiding) {
      isAvoiding = false;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    } else {
      isAvoiding = true;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    }
  } else if (key == '4') {     // Toggle boid wandering
    if (isWandering) {
      isWandering = false;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    } else {
      isWandering = true;
      println("Centering: " + isCentering + ", Matching: " + isMatching + ", Avoiding: " + isAvoiding + ", Wandering: " + isWandering);
    }
  } else if (key == 's') {     // Scatter all boids and set random velocity
    for (int n = 0; n < boidList.size(); n++) {
      float posX = random(800 - (boidSize * 2)) + boidSize;
      float posY = random(800 - (boidSize * 2)) + boidSize;
      float velX = random(7) - 3;
      float velY = random(7) - 3;
      Boid thisBoid = new Boid(posX, posY, velX, velY);
      boidList.set(n, thisBoid);
      println("Boids have been scattered.");
    }
  } else if (key == '=' || key == '+') {    // Add Boids
    if (boidList.size() < 100) {
      float posX = random(800 - (boidSize * 2)) + boidSize;
      float posY = random(800 - (boidSize * 2)) + boidSize;
      float velX = random(7) - 3;
      float velY = random(7) - 3;
      Boid newBoid = new Boid(posX, posY, velX, velY);
      boidList.add(newBoid);
      boidNum = boidList.size();
      println("New boid added.");
    }
  } else if (key == '-') {     // Subtract Boids
    if (boidList.size() > 0) {
      boidList.remove(0);
      boidNum = boidList.size();
      println("A boid has been removed.");
    }
  } else if (key == ' ') {     // Toggle pauseing of simulation
    if (isPaused) {
      isPaused = false;
      println("Resuming simulation.");
    } else {
      isPaused = true;
      println("Simulation paused.");
    }
  } else if (key == 'p') {     // Toggle showing of paths
    if (isShowPath) {
      isShowPath = false;
      println("Paths have been toggled off.");
    } else {
      isShowPath = true;
      println("Paths have been toggled on.");
    }
  } else if (key == 'c') {     // Clear paths
    isShowPath = false;
    println("Paths have been cleared.");
  } else if (key == 'a') {     // Toggle attraction mode
    if (isAttracted) {
      isAttracted = false;
      println("Mouse attraction has been toggled off.");
    } else {
      isAttracted = true;
      isRepulsed = false;
      println("Mouse attraction mode has been toggled on.");
    }
  } else if (key == 'r') {     // Toggle repulsion mode
    if (isRepulsed) {
      isRepulsed = false;
      println("Mouse repulsion has been toggled off.");
    } else {
      isRepulsed = true;
      isAttracted = false;
      println("Mouse repulsion mode has been toggled on.");
    }
  }
}

private float calcDistance(Boid thisBoid, Boid thatBoid) {
  float diffX = thatBoid.getCurrPosX() - thisBoid.getCurrPosX();
  float diffY = thatBoid.getCurrPosY() - thisBoid.getCurrPosY();
  float dist = sqrt((diffX * diffX) + (diffY * diffY));
  return dist;
}
