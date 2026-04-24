
class PlaceableWall extends BaseActor  {
  
  PlaceableWall(int x, int y){
    super(x,y);
    size = new PVector(75, 100);
    angle = 0;
    position.x -= 1;
    position.y -= 12;
    scareRange = 0;
    attackSpeed = .8;
    
    sprite = loadImage("sprites/wall.png"); //PlaceHolder
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
