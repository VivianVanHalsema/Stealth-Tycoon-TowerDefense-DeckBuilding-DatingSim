
class Vampire extends BaseActor {
  
  ArrayList<debuffTypes> debuffs = new ArrayList<debuffTypes>();
  
  Vampire(int x, int y){
    super(x,y);
    /* customizable variables
    sprite = loadImage("sprites/mummy.png");
    attackSpeed = .8;
    scareRange = 240;
    */
    
    sprite = loadImage("sprites/vampire.png");
    attackSpeed = 5;
    scareRange = 220;
    maxAttackCooldown = 3;
    
  }
  
  
  
  void update() {
    //super
    getAllInRange();
    lookAtFrontGuestInRange();
    attackCooldown -= dt; //modified for the purposes of a quick initial attack if an enemy enters range but slower later
    
    scareRange = 220 + UpgradeDump.getVampireRangeBonus();
    maxAttackCooldown = 3 * (1 * UpgradeDump.getVampireAttackSpeedBonus());
    
    
    if (attackCooldown < 0) {
      if (!guestsInRange.isEmpty()) {
         VampireAttack();// here is where you put your special custom attack
      }
      else { attackCooldown = 0.8;} //this gives the tower time to turn when a new guest enters their range
    }
   
    
    
  }
  
   void draw(){
    super.draw();
  }
  
  
  void VampireAttack() {
    // IF your actor uses attacks, create your projectile, add it to the projectile arraylist, 
    //else you'll have you''ll have to figure it out on your own for now unless I get to it
    BaseGuest targetToBite = getClosestInRange();
    if(targetToBite != null) {
      VampireProjectile proj = new VampireProjectile(int(targetToBite.position.x), int(targetToBite.position.y), 0);
      attacks.add(proj);
    }
    attackCooldown = maxAttackCooldown;
    
    
  }
  
  
}
//make sure to extend from CircleProjectile,RectProjectile, or LineProjectile(what mummy uses)
//unless you need something else like aoe or physical attack
//then gl/I'm working on it/your working on it
//depends on what it is talk to me
class VampireProjectile extends CircleProjectile {
  
  PImage sprite;
  boolean firstFrame = true;
  
  VampireProjectile(int x, int y, float angle){
   super(x,y, angle); 
  /* change these variables to taste
  
    size.x = 50;
    size.y = 20;
    lifetime = .8;
    projectileSpeed = 6;
    damage = 3;
    
    //make sure to add your own debuff to the enum debuffTypes found at the bottom of BaseGuest
    //except for jaso nunproblematic king
    debuffs.add(debuffTypes.SLOWNESS); 
  
  */
    sprite = loadImage("sprites/vampireteeth.png");
    size.x = 100;
    size.y = 100;
    lifetime = 0.5;
    projectileSpeed = 0;
    damage = 50 + int(UpgradeDump.getVampireDamageBonus());
   }
  
  void update(){
    if (firstFrame) {
      super.update();
    } else lifetime -= dt; 
    firstFrame = false;
    
    //this should handle collision and be all you need unless ur getting freaky
 
}
 void draw(){
    noStroke();
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);  // Rotate the projectile to face its direction... I assume these sprites are gonna need angle even tho they are ellipses...right?
    fill(255, 0, 0);
    tint(255, 255*lifetime);
    //circle(0, 0, size.x);
    image(sprite, 0, 0);
    noTint();
    popMatrix();
   //this should work I'll slot in images instead of just basic shapes eventually
  }


}
