class Mummy extends BaseActor {
  
  
  
  Mummy(int x,int y, actorTypes scaractor){
    super(x,y, scaractor);
    sprite = loadImage("sprites/mummy.png");
    attackSpeed = .8;
    scareRange = 430;
    
  }
  
  
  
  void update() {
    //applys upgrade bonuses here each frame so they take effect right away after being purchased
    //base stats still live in the constructor above though, purely additive bonuses
    scareRange = 430 + UpgradeDump.getMummyRangeBonus();
    attackSpeed = 0.8 + UpgradeDump.getMummyAttackSpeedBonus();
    //The slow duration upgrade is read at attack-time in the mummyProjectile
    
    super.update();
    if (attackCooldown < 0) {
      if (!guestsInRange.isEmpty()) {
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
    attacks.add(newProjectile);
    attackCooldown = maxAttackCooldown;
    
    
  }
  
}


class MummyProjectile extends LineProjectile {
  
  
 
  MummyProjectile (float x, float y, float angle){
    super(x,y,angle);
    lineWidth = 10;
    lifetime = 1.0;
    projectileSpeed = 9;
    damage = 20;
    debuffs.add(debuffTypes.WRAPPED); //Adds unique mummy debuff
    //reads slow duration upgrade at moment of firing 
    //this way each projectile carries the correct debuff length as its being made
    lengthOfDebuff = 1.0 + UpgradeDump.getMummySlowBonus();
  }
  
  void update(){
    super.update();
    
  }
  
  void draw(){
   super.draw();
  }
 

  
}
