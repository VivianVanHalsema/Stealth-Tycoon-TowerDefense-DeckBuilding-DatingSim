
class PlaceableWall extends BaseActor  {
  
  PlaceableWall(int x, int y, actorTypes scaractor){
    super(x,y, scaractor);
    size = new PVector(75, 100);
    angle = 0;
    position.x -= 1;
    position.y -= 12;
    scareRange = 0;
    attackSpeed = .8;
    
    sprite = loadImage("sprites/wall.png"); //PlaceHolder
  }
  
  
  
  void update() {
    //super.update();
    //if (attackCooldown < 0) { //walls don't attack :3 (...i think)
    //  if (!guestsInRange.isEmpty()) {
    //     exampleAttack();// here is where you put your special custom attack
    //  }
    //  else { attackCooldown = .8;} //this gives the tower time to turn when a new guest enters their range
    //}
   
    
    
  }
  
   void draw(){
    noStroke();
    rectMode(CENTER);
    imageMode(CENTER);
    //draw attack range
    fill(255,20);
    ellipse(position.x,position.y, scareRange,scareRange);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    imageMode(CENTER);
    sprite.resize(int(size.x), int(size.y));
    image(sprite, 0, 0);
    popMatrix();
  }
  
  
}

class Decoration extends BaseActor  {
  
  Decoration(int x, int y, actorTypes scaractor){
    super(x,y, scaractor);
    size = new PVector(75, 75);
    
    sprite = loadImage("sprites/bloodspatter.png"); //PlaceHolder
    entertainmentValue += .1;
  }
  
  
   void draw(){
    noStroke();
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    imageMode(CENTER);
    sprite.resize(int(size.x), int(size.y));
    image(sprite, 0, 0);
    popMatrix();

  }
  
  
}
class Blood extends BaseActor  {
  
  Blood(int x, int y, actorTypes scaractor){
    super(x,y, scaractor);
    
    sprite = loadImage("sprites/bloodspatter.png"); //PlaceHolder

  }
  
  
   void draw(){
     angle=90;
    noStroke();
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    imageMode(CENTER);
    sprite.resize(int(size.x), int(size.y));
    image(sprite, 0, 0);
    popMatrix();
  }
  
}
  
  class Hands extends BaseActor  {
  
  Hands(int x, int y, actorTypes scaractor){
    super(x,y, scaractor);
    angle = 90;
    sprite = loadImage("sprites/hands.png"); //PlaceHolder

  }
  
  
   void draw(){
     angle=90;
    noStroke();
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    imageMode(CENTER);
    sprite.resize(int(size.x), int(size.y));
    image(sprite, 0, 0);
    popMatrix();
    }
  }

class Tombstone extends BaseActor  {
  
   Tombstone(int x, int y, actorTypes scaractor){
    super(x,y, scaractor);
    angle=0;
    sprite = loadImage("sprites/tombstone.png"); //PlaceHolder

  }
  
  
   void draw(){
     angle=0;
    noStroke();
    imageMode(CENTER);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    imageMode(CENTER);
    sprite.resize(int(size.x), int(size.y));
    image(sprite, 0, 0);
    popMatrix();
  }
  
}
