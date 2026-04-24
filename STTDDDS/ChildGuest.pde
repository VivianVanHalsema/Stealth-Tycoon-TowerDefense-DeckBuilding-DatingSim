//this is the code for the child enemy type that will speed through the level healing any guests that they pass.

class ChildGuest extends BaseGuest {
 
  //This is the amount that the child restores to the guests that they pass through
  float healPerSecond = 10;
  
  //the pixel radius around the child that heals guests. 
  //basically any guest in it gets healed every frame 
  float healRadius = 60;
  
  //different color to make them pop out more from the normal gray enemies
  color childColor = color(250, 210, 60);
  
  //Constructor 
  //takes same x and y spawn as the normal guests and calls super(x, y) first so base guest sets up all its own
  //fields then override the stats here so it can be special : )
  
  ChildGuest(int x, int y) {
   super(x, y);
   
   //lower health that base guests 100 to balance out the speed and healing
   //MAKE SURE MAX HEALTH IS SETTING FIRST AND THEN SYNC HELATH TO IT
   maxHealth = 50;
   health = maxHealth; 
   
   size = 24; //making them smoler cuz baby
   
   //faster movement speed
   speed = 4; 
   
   //applies yellow color to both baseColor and currentColor.
   //since baseColor is what gets restored when a debuff wears off, i set both so it still tints correctly and doesn't 
   //return back to gray instead after a debuff. 
   baseColor = childColor;
   currentColor = childColor;
  }
  
  //using override to replace baseGuests update, but still call super.update so the logic still runs
  //(pathfinding, movement, debuff, death detections, etc.)
  @Override
  
  void update() {
   //runs all the standard baseguest logic here 
   super.update();
   
   //only heals while this child is "alive" or health is at >0.
   //basically the childs defeated after it hits 0
   if (health >0) {
      healGuests(); 
   }
  }
  
  void healGuests() {
   //determines how much healing it should apply on specific frame
   //uses dt to produce smooth per second rate regardless of the frame rate
   float healThisFrame = healPerSecond * dt;
   
   for (int i = 0; i < guests.size(); i++) {
    BaseGuest other = guests.get(i);
    
    //skips this gues since the self healing would be dumb af
    if (other == this) continue;
    
    //skips guests at full hp
    if (other.health >= other. maxHealth) continue; 
    
    //Checks whether this other guest is close enough to get the heals
    float d = dist(position.x, position.y, other.position.x, other.position.y);
    
    if (d <= healRadius) {
     //adds heal amount, but caps at guest max hp
     other.health = min(other.health + (int) healThisFrame, other.maxHealth);
    }
   }
  }
  
  @Override
  void draw() {
   //only show the heal radius ring while the child can heal. 
   if (health >0) {
    noFill();
    stroke(240, 210, 60, 60); //yellow outline
    strokeWeight(1.5);
    ellipse(position.x, position.y, healRadius * 2, healRadius * 2);
    noStroke();
   }
   
   //draws child body and any active status overlays (bandages) 
   super.draw();
  }
}
