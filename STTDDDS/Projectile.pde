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
   float projectileSpeed = 5; //if you change the projectile speed you also need to recalc the velocity too
    this.velocity.x = cos(angle) * projectileSpeed;
    this.velocity.y = sin(angle) * projectileSpeed;
 }
  
  void update(){
    lifetime -= dt;
    if (lifetime < 0){
     isAlive = false;
    }
    position.x += velocity.x;
    position.y += velocity.y; 
    checkCollision();
  }
  
    void draw() {
      
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);  // Rotate the projectile to face its direction
    rectMode(CENTER);
    fill(255, 0, 0);
    rect(0, 0, size.x, size.y);
    popMatrix();
  }
  
 void checkCollision () {
   
   
   
   
 }
 
 
  
}
