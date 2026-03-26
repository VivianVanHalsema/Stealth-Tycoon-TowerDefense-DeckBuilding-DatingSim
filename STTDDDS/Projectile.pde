class Projectile {
  PVector position = new PVector();
  PVector size = new PVector();
  PVector velocity = new PVector();
  float angle;
  float projectileSpeed = 5;
  float lifetime;
  boolean isAlive = true;
 Projectile (float x, float y, float angle){
   this.position.x = x;
   this.position.y = y;
   this.size.x = 20;
   this.size.y = 20;
   this.angle = angle;
   lifetime = 5;
   projectileSpeed = 5;
 }
  
  void update(){
    lifetime -= dt;
    if (lifetime < 0){
     isAlive = false;
    }
    this.velocity.x = cos(angle) * projectileSpeed;
    this.velocity.y = sin(angle) * projectileSpeed;
    position.x += velocity.x;
    position.y += velocity.y; 
    checkCollision();
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
  
 void checkCollision () {
   
   ///lol ill get to it
   
   
 }
 
  //get all guests on a line- the x and y input are the second cordinate, since I assume the first is always the position
  //it also presumes that dx and dy are located on your tower, so it doesn't check if that end of the line is located
  //in the circle. just duplicated the first condition and switch up the x and y if you need that
  ArrayList checkLineCollision(float x, float y, float lineWidth){
    ArrayList<BaseGuest> colliding = new ArrayList<BaseGuest>();
    
     float dx = this.position.x;
     float dy = this.position.y;

     float len = dist(x,y,dx,dy);
     
     for (BaseGuest guest : guests) {
       
     float gx= guest.position.x;
     float gy= guest.position.y;
     boolean lineEndCollision = pointInRadius(gx, gy, x, y, guest.size);
   
   if (lineEndCollision) {
     colliding.add(guest);
     continue;
     }
     
   
   float dot = ( ((gx-x)*(dx-x)) +((gy-y)*(dx-y)) )/pow(len,2);
   float closestX = x + (dot * (dx-x));
   float closestY = y + (dot * (dy-y));
  }
 
  return colliding;
}

}
