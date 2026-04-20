
class PlaceableWall extends BaseActor  {
  
  PlaceableWall(int x, int y){
    super(x,y);
    /* customizable variables
    sprite = loadImage("sprites/mummy.png");
    attackSpeed = .8;
    scareRange = 240;
    */
    sprite = loadImage("sprites/cultist.png"); //PlaceHolder
  }
  
  
  
  void update() {
    super.update();
    //if (attackCooldown < 0) { //walls don't attack :3 (...i think)
    //  if (!guestsInRange.isEmpty()) {
    //     exampleAttack();// here is where you put your special custom attack
    //  }
    //  else { attackCooldown = .8;} //this gives the tower time to turn when a new guest enters their range
    //}
   
    
    
  }
  
   void draw(){
    super.draw();
  }
  
  
}
