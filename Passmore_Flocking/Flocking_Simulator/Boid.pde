// CS 7492 - Simulation of Biology
// Project 2 - Flocking Simulator
// Author: Austin Passmore

// Class to represent a Boid (creature).

class Boid {

  private float boidSize = 20.0;
  
  private float currPosX;
  private float currPosY;
  private float prevPosX;
  private float prevPosY;
  private float velX;
  private float velY;
  
  private ArrayList<Float> pathX = new ArrayList<Float>();
  private ArrayList<Float> pathY = new ArrayList<Float>();
  private int pathSize = 150;
  float pathRed = 50 + random(205);
  float pathGreen = 50 + random(205);
  float pathBlue = 50 + random(205);
  
  public Boid(float posX, float posY, float velX, float velY) {
    this.currPosX = posX;
    this.currPosY = posY;
    this.prevPosX = posX;
    this.prevPosY = posY;
    this.velX = velX;
    this.velY = velY;
    
    pathX.add(currPosX);
    pathY.add(currPosY);
  }
  
  // Adds the Boid's velocity to its position.
  public void updatePosition() {
    this.prevPosX = currPosX;
    this.prevPosY = currPosY;
    
    // Check if Boid is moving outside of screen
    if (currPosX + velX >= 800 - boidSize || currPosX + velX <= boidSize) {
      velX = velX * -1;
    }
    if (currPosY + velY >= 800 - boidSize || currPosY + velY <= boidSize) {
      velY = velY * -1;
    }
    
    this.currPosX += velX;
    this.currPosY += velY;
    
    // Update the Boid's path
    if (pathX.size() >= pathSize) {
      pathX.remove(0);
      pathY.remove(0);
    }
    pathX.add(currPosX);
    pathY.add(currPosY);
  }
  
  // Draws the Boid to the screen at its position.
  public void drawBoid() {
    // Make the Boid green
    noStroke();
    fill(0, 255, 0);
    
    // Rotate the Boid in the direction of velocity
    translate(currPosX, currPosY);
    rotate(atan2(velX, -1 * velY));
    translate(-1 * currPosX, -1 * currPosY);
    
    // Draw the Boid
    ellipse(this.currPosX, this.currPosY, boidSize, boidSize);
    ellipse(this.currPosX, this.currPosY + (boidSize * 0.75), boidSize / 5, boidSize);
    
    translate(currPosX, currPosY);
    rotate(-1 * atan2(velX, -1 * velY));
    translate(-1 * currPosX, -1 * currPosY);
    
  }
  
  // Draws the path that the Boid has traveled.
  public void drawPath() {
    // Makes each path a random color
    strokeWeight(4);
    stroke(pathRed, pathGreen, pathBlue);
    for (int n = 0; n < pathX.size() - 1; n++) {
      float x1 = pathX.get(n);
      float y1 = pathY.get(n);
      float x2 = pathX.get(n + 1);
      float y2 = pathY.get(n + 1);
      line(x1, y1, x2, y2);
    }
  }
  
  public float getCurrPosX() {
   return currPosX; 
  }
  
  public float getCurrPosY() {
   return currPosY; 
  }
  
  public float getVelX() {
   return velX; 
  }
  
  public float getVelY() {
   return velY; 
  }
  
  public void setVelX(float x) {
   velX = x; 
  }
  
  public void setVelY(float y) {
   velY = y;
  }
  
  
}
