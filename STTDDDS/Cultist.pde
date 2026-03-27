
class Cultist extends BaseActor  {
  
  Cultist(int x, int y){
    super(x,y);
    
    sprite = loadImage("sprites/cultist.png");
    attackSpeed = .4;
    scareRange = 240;
  }
  
  
  
  void update() {
    super.update();
    if (attackCooldown < 0) {
      if (!guestsInRange.isEmpty()) {
         cultistAttack();// here is where you put your special custom attack
      }
      else { attackCooldown = .8;} //this gives the tower time to turn when a new guest enters their range
    }
   
    
    
  }
  
   void draw(){
    super.draw();
  }
  
  
  void cultistAttack() {
    CultistProjectile newProjectile = new CultistProjectile(this.position.x,this.position.y, scareRange);
    attacks.add(newProjectile);
    attackCooldown = maxAttackCooldown;
    
  }
  
  
}

class CultistProjectile extends AOE {
  
  CultistProjectile(float x, float y, float ownersScareRange){
   super(x,y,ownersScareRange); 
   size.x = 10;
   speed= 120;
   damage = 10;
   lifetime = 5;
   lengthOfDebuff =20;
   debuffs.add(debuffTypes.CULTJARGON);
   }
  
  void update(){
    super.update();
}
 void draw(){
   super.draw();
   
  }


}
