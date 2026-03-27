class Mummy extends BaseActor {
  
  
  
  Mummy(int x,int y){
    super(x,y);
    sprite = loadImage("sprites/mummy.png");
    attackSpeed = .8;
    scareRange = 240;
    
  }
  
  
  
  void update() {
    super.update();
    if (attackCooldown < 0) {
      if (!guestsInRange.isEmpty()) {
        println("i'm attacking!");
         mummyAttack(); 
      }
      else { attackCooldown = .8;} //so the mummy has time to rotate towards next guest if none are there
    }
   
    
    
  }
  
  void draw(){
    super.draw();
    
    
    
    
  }
  
  
  void mummyAttack(){
    MummyProjectile newProjectile = new MummyProjectile(this.position.x,this.position.y, angle);
    projectiles.add(newProjectile);
    attackCooldown = maxAttackCooldown;
    
    
  }
  
}


class MummyProjectile extends LineProjectile {
  
  
 
  MummyProjectile (float x, float y, float angle){
    super(x,y,angle);
    lineWidth = 10;
    lifetime = .8;
    projectileSpeed = 6;
    damage = 3;
    debuffs.add(debuffTypes.SLOWNESS); //dont forget to add
  }
  
  void update(){
    super.update();
    
  }
  
  void draw(){
   super.draw();
  }
 

  
}
