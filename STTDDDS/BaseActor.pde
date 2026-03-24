class BaseActor {
  ArrayList<BaseGuest> guestsInRange = new ArrayList<BaseGuest>(); 
  PVector position = new PVector();
  PVector size = new PVector();
  float angle;
  float attackCooldown;
  
  
  
  //variables changed in child classes
  float scareRange;
  PImage sprite;
  float attackSpeed; // attack speed of 1 is every second, 2 is twice a second, .5 is every 2 seconds
  
  
  BaseActor(int x, int y){
    
  //input variables
  position.x = x;
  position.y = y;
  //default variables
  size.x = 64;
  size.y = 64;
  angle = 0;
  //child variables
  scareRange = 160;
  sprite = loadImage("sprites/vampire.png");
  attackSpeed = 1;
  
    
  }
  
  void update(){
    getAllInRange();
    lookAtFrontGuestInRange();
    attackCooldown -= dt *attackSpeed;
    
  }
  
  void draw() {
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
  
  //get every Guest in scareRange
 void getAllInRange(){
  guestsInRange.clear();
  for (BaseGuest guest:guests) {
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
 BaseGuest getFrontGuestInRange(){
    if (guestsInRange.isEmpty()) return null; 
   float frontmostDistance = -10000;
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
  
  angle = angle +diff * .2;
  }
  
  
}

}
