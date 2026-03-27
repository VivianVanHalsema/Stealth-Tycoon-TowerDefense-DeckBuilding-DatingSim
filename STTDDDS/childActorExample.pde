
//here's a child actor class to walk you through what things to add and change for your own actor/tower
class ChildActorExample extends BaseActor  {
  
  ChildActorExample(int x, int y){
    super(x,y);
    
  }
  
  
  
  void update() {
    super.update();
    if (attackCooldown < 0) {
      if (!guestsInRange.isEmpty()) {
         exampleAttack();// here is where you put your special custom attack
      }
      else { attackCooldown = .8;} //this gives the
    }
   
    
    
  }
  
   void draw(){
    super.draw();
  }
  
  
  void exampleAttack() {
    // IF your actor uses projectiles, create your projectile, add it to the projectile arraylist, 
    //else you'll have you''ll have to figure it out on your own for now unless I get to it
    attackCooldown = maxAttackCooldown;
    
    
  }
  
  
}
//make sure to extend from CircleProjectile,RectProjectile, or LineProjectile(what mummy uses)
//unless you need something else like aoe or physical attack
//then gl/I'm working on it/your working on it
//depends on what it is talk to me
class ExampleProjectile extends CircleProjectile {
  
  ExampleProjectile(int x, int y, float angle){
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
   }
  
  void update(){
    super.update();
    //this should handle collision and be all you need unless ur getting freaky
 
}
 void draw(){
   super.draw();
   //this should work I'll slot in images instead of just basic shapes eventually
  }


}
