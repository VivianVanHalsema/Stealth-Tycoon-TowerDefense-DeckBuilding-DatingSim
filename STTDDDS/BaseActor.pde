
//im formatting my child actors by putting the child class in its own tab with its associated child projectile (if applicable)

class BaseActor {
  ArrayList<BaseGuest> guestsInRange = new ArrayList<BaseGuest>(); 
  PVector position = new PVector();
  PVector size = new PVector(64,64);
  float angle = (PI/2);
  float attackCooldown;
  float maxAttackCooldown = 1;
  
  
  
  
  //variables changed in child classes
  float scareRange =160;
  PImage sprite;
  float attackSpeed = 1; // attack speed of 1 is every second, 2 is twice a second, .5 is every 2 seconds
  
  
  BaseActor(int x, int y){
    
  //input variables
  position.x = x;
  position.y = y;
  sprite = loadImage("sprites/vampire.png");

  
    
  }
  
  void update(){
    getAllInRange();
    lookAtFrontGuestInRange();
    attackCooldown -= dt *attackSpeed;
    
  }
  
  void draw() {
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
  
   boolean checkClicked(){
  return mouseX > position.x && 
         mouseX < position.x + size.x && 
         mouseY > position.y && 
         mouseY < position.y + size.y;
 }
  
  //get every Guest in scareRange
 void getAllInRange(){
  guestsInRange.clear();
  for (BaseGuest guest:guests) {
    if (guest.isCultist == true || guest.terrified == true){ continue;}
    float dis = dist(guest.position.x, guest.position.y, this.position.x, this.position.y);
    if(dis < scareRange/2 + guest.size/2){
       guestsInRange.add(guest);
    }
  }
 }
 
 //gets the guest closest to the actor itself
 BaseGuest getClosestInRange(){
    if (guestsInRange.isEmpty()) return null; 
  float closestDistance = 1000000;
  BaseGuest closestGuest = guestsInRange.get(0);
 for (BaseGuest guest:guestsInRange){
    float dis = dist(guest.position.x, guest.position.y, this.position.x, this.position.y);
    if (dis < closestDistance) {
      closestDistance = dis;
      closestGuest = guest;
}
    }
    return closestGuest;
 }
 
 
 //gets the actor closest to the bottom of the map AKA the end (used for the direction to look at
 
 //In the future maybe we could have a more specific variable on the guest side that is
 //percentage of path done or something? In case a path goes down but goes back up later in the path
 BaseGuest getFrontGuestInRange(){
    if (guestsInRange.isEmpty()) return null; 
   float frontmostDistance = MIN_FLOAT;
   BaseGuest frontmostGuest = guestsInRange.get(0);
  for (BaseGuest guest:guestsInRange){
    if (guest.position.y > frontmostDistance) {
      frontmostDistance = guest.position.y;
      frontmostGuest = guest;
    }
  }
  
  return frontmostGuest;
}

// look at closest guest in range 
void lookAtFrontGuestInRange(){
  BaseGuest guest = getFrontGuestInRange();
  if (guest != null){
    
  float targetAngle = atan2(guest.position.y - position.y, guest.position.x - position.x);
  float diff = targetAngle - angle;
  
  if (diff > PI) diff -= TWO_PI;
  if (diff < -PI) diff += TWO_PI;
  
  angle = angle +diff * .3;
  }
  
  
}

}


static enum actorTypes
  {
    CULTIST,
    MUMMY,
   VAMPIRE
  };
