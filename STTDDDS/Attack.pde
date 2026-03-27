class Attack {
  PVector position = new PVector();
  PVector size = new PVector();
  float lifetime;
  boolean isAlive = true;
  boolean isColliding = false; //use if your attack expires on contact, otherwise don't touch it
  
  //debuff variables
  ArrayList<debuffTypes> debuffs = new ArrayList<debuffTypes>();
  float lengthOfDebuff =3;
  Attack(float x, float y){
   this.position.x = x;
   this.position.y = y; 
    
  }
  
  void update () {
   lifetime -= dt;
    if (lifetime < 0 || isColliding){
     isAlive = false;
    }
    
  }
    
    void draw(){
      
    }
  
}


class Projectile extends Attack {

  PVector velocity = new PVector();

  //child variables
  float angle;
  float projectileSpeed = 5;
  int damage = 5;
  
 Projectile (float x, float y, float angle){
   super(x,y);
   this.size.x = 20;
   this.size.y = 20;
   this.angle = angle;
   lifetime = 5;
 }
  
  void update(){
    super.update();
    this.velocity.x = cos(angle) * projectileSpeed;
    this.velocity.y = sin(angle) * projectileSpeed;
    position.x += velocity.x;
    position.y += velocity.y; 
    //call the proper checkCollision in the child class
  }
  
  
  void handleCollisions (ArrayList<BaseGuest> colliding) {
    for (BaseGuest guest : colliding) {
      println(guest);
    guest.handleAttack(damage,lengthOfDebuff,debuffs, this);
    }
  }
  
 void checkRectCollision () {
   
   ///lol ill get to it
   
   
 }
 
 void checkCircleCollision () {
   
   
 }
 
  //get all guests on a line- the x and y input are the second cordinate, since I assume the first is always the position
  //it also presumes that dx and dy are located on your tower, so it doesn't check if that end of the line is located
  //in the circle. just duplicated the first condition and switch up the x and y if you need that
  ArrayList checkLineCollision(float x, float y, float lineWidth){
    ArrayList<BaseGuest> colliding = new ArrayList<BaseGuest>();
    
    float dx = this.position.x;
    float dy = this.position.y;
    float len = dist(x, y, dx, dy);
    
    for (BaseGuest guest : guests) {
        float gx = guest.position.x;
        float gy = guest.position.y;
        float guestRadius = guest.size / 2; 
        
        // Check if either endpoint is inside the guest
        boolean startCollision = pointInRadius(gx, gy, x, y, guestRadius);
        boolean endCollision = pointInRadius(gx, gy, dx, dy, guestRadius);
        
        if (startCollision || endCollision) {
            colliding.add(guest);
            continue;
        }
        
        // Calculate closest point on line segment
        float dot = ((gx - x) * (dx - x) + (gy - y) * (dy - y)) / (len * len);
        
        // Clamp dot to [0,1] to stay on line segment
        dot = constrain(dot, 0, 1);
        
        float closestX = x + dot * (dx - x);
        float closestY = y + dot * (dy - y);
        
        float dis = dist(closestX, closestY, gx, gy);
        
        // Check if distance is less than guest radius + half line width
        if (dis <= guestRadius + (lineWidth / 2)) {
            colliding.add(guest);
        }
    }
    
    return colliding;
}

}

class CircleProjectile extends Projectile {
  
  CircleProjectile (float x, float y, float angle){
  super(x,y,angle);
  }
  
  
  void update() {
   super.update(); 
    
    
  }
  void draw() {
    noStroke();
    rectMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);  // Rotate the projectile to face its direction... I assume these sprites are gonna need angle even tho they are ellipses...right?
    fill(255, 0, 0);
    ellipse(0, 0, size.x, size.y);
    popMatrix();
  }
  
  
  
  
}

class RectProjectile extends Projectile {
  
  RectProjectile (float x, float y, float angle){
  super(x,y,angle);
  }
  
  
  void update() {
   super.update(); 
    
    
  }
  void draw() {
    noStroke();
    rectMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);  // Rotate the projectile to face its direction
    fill(255, 0, 0);
    rect(0, 0, size.x, size.y);
    popMatrix();
  }
  
  
}

class LineProjectile extends Projectile {
  
  PVector startPosition = new PVector();
  float lineWidth = 10;
  
  
  
  LineProjectile (float x, float y, float angle){
    super(x,y,angle);
    startPosition.x = x;
    startPosition.y = y;
  }
  
  void update(){
    super.update();
    ArrayList<BaseGuest> colliding = checkLineCollision(this.startPosition.x,this.startPosition.y, lineWidth);
    handleCollisions(colliding);
  }
  
  void draw(){
    stroke(255);
    strokeWeight(lineWidth);
    strokeCap(SQUARE);
    line(position.x,position.y,startPosition.x,startPosition.y);
  }
 

  
}
