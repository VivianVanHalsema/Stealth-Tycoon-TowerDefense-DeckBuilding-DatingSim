//types of attacks currently implented rectangle projectiles, circle projectiles, line projectiles

//types im planning to add - aoe projectiles,  aoe flash (first is a wave that goes out around tower, other instantly hits all in radius)
// + whatever else you need IF you ask nicely <3
//possibly cone

class Attack {
  PVector position = new PVector();
  PVector size = new PVector();
  float lifetime =3;
  int damage = 5;
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
    
 ArrayList checkCircleCollision (float x, float y, float size) {
    
    ArrayList<BaseGuest> colliding = new ArrayList<BaseGuest>();
   for (BaseGuest guest : guests) {
        float gx = guest.position.x;
        float gy = guest.position.y;
        float dis = dist (x,y, gx, gy);
   if (dis  <= size + guest.size/2) { 
       colliding.add(guest);
       continue;
   }
  }
  return colliding;
 }
 
  void handleCollisions (ArrayList<BaseGuest> colliding) {
    for (BaseGuest guest : colliding) {
    guest.handleAttack(damage,lengthOfDebuff,debuffs, this);
    }
  }
  
}


class Projectile extends Attack {

  PVector velocity = new PVector();

  //child variables
  float angle;
  float projectileSpeed = 5;
  
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
  
}
  //im p sure this works but I haven't actually tested it so don't quote me on that
class CircleProjectile extends Projectile {
  
  CircleProjectile (float x, float y, float angle){
  super(x,y,angle);
  }
  
  
  void update() {
   super.update(); 
   ArrayList<BaseGuest> colliding = checkCircleCollision(position.x,position.y,size.x);
   handleCollisions(colliding);
  }
  void draw() {
    noStroke();
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);  // Rotate the projectile to face its direction... I assume these sprites are gonna need angle even tho they are ellipses...right?
    fill(255, 0, 0);
    circle(0, 0, size.x);
    popMatrix();
  }
  
 
  
  
}

class RectProjectile extends Projectile {
  
  RectProjectile (float x, float y, float angle){
  super(x,y,angle);
  }
  
  
  void update() {
   super.update(); 
   ArrayList<BaseGuest> colliding = checkRectCollision(position.x,position.y,size.x,size.y);
   handleCollisions(colliding);
    
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
  
  //im p sure this works but I haven't actually tested it so don't quote me on that
  
  ArrayList<BaseGuest> checkRectCollision(float x, float y, float w, float h) {
    ArrayList<BaseGuest> colliding = new ArrayList<BaseGuest>();
    
    for (BaseGuest guest : guests) {
        float gx = guest.position.x;
        float gy = guest.position.y;
        

        float closestX = constrain(gx, x, x + w);
        float closestY = constrain(gy, y, y + h);
        
        
        float dis = dist(closestX, closestY, gx, gy);
        
        if (dis <= guest.size / 2) {
            colliding.add(guest);
        }
    }
    return colliding;
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

class AOE extends Attack {
  
  float speed;
  float limit;
  
  AOE(float x, float y, float ownersScareRange){
    super(x,y);
    size.x = 50;
    speed = 20;
    limit = ownersScareRange;
    
  }
  
  void update() {
  super.update();
  size.x += speed * dt;
   if (size.x > limit){ 
   isAlive = false;
   size.x = limit;
 }
  ArrayList<BaseGuest> colliding = checkCircleCollision(position.x,position.y,(size.x/2));
  handleCollisions(colliding);
  }
  
  
  void draw(){
    fill(150,150,150);
    circle(position.x,position.y, size.x);
    
  }
 
  
  
}
