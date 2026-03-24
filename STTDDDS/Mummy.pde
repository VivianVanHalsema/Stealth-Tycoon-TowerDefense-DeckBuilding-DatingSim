class Mummy extends BaseActor {
  
  
  
  Mummy(int x,int y){
    super(x,y);
    sprite = loadImage("sprites/mummy.png");
    attackSpeed = .9;
    scareRange = 240;
    
  }
  
  
  
  void update() {
    super.update();
    if (attackCooldown < 0) {
      if (!guestsInRange.isEmpty()) {
        println("i'm attacking!");
         mummyAttack(); 
      }
      else { attackCooldown = .3;} //so the mummy has time to rotate towards next guest if none are there
    }
    
    
    
  }
  
  void draw(){
    super.draw();
    
    
    
    
  }
  
  
  void mummyAttack(){
    MummyProjectile newProjectile = new MummyProjectile(this.position.x,this.position.y, angle);
    projectiles.add(newProjectile);
    attackCooldown = 1;
    
    
  }
  
}


class MummyProjectile extends Projectile {
  
  MummyProjectile (float x, float y, float angle){
    super(x,y,angle);
    size.x = 50;
    size.y = 20;
    lifetime = .8;
    projectileSpeed = 3;
    this.velocity.x = cos(angle) * projectileSpeed;
    this.velocity.y = sin(angle) * projectileSpeed;
  }
  
  void update(){
    super.update();
    
  }
  
  void draw(){
    super.draw();
     
  }
  
  
  
  
  
  
  
}
