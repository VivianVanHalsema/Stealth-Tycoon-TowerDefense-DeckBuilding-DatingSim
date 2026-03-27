class BaseGuest {
  
  PVector position = new PVector();
  int size= 40;
  float scareRange;
  float speed = 20;
  int health = 10;
  color baseColor,currentColor;
  boolean terrified = false;
  //debuff variables ENUMS BELOW  BASE GUEST CLASS
  
  //contains all debuffs with their leftover time
  HashMap<debuffTypes,Float> currentDebuffs = new HashMap<debuffTypes, Float>();
  float slowness = 1;
  
  //right now when the mummy shoots a guest their slowness and color are changed permanently
  //I just did this so I could make sure they were being hit, I want to wait to add timers until 
  //we discuss how we want to handle debuffs
  BaseGuest(int x, int y){
  position.x = x;
  position.y = y;
  baseColor = color(100,100,100);
  currentColor = baseColor;
  }
  
  void update(){
    if (health <= 0) {terrified = true;}
    // this is just debugging I wanted to make sure that actors could track the position of guests
    position.y += speed*dt *slowness;
    
    
    for(Map.Entry<debuffTypes, Float> debuff : currentDebuffs.entrySet()){
     float currentTime = debuff.getValue();
     float newTime = currentTime-dt;
        // Update the timer
        debuff.setValue(newTime);
    }
    //remove all debuffs with less than 0 timer
    removeDeadDebuffs();
     
    
    
    
  }
  
  
  //handles all attacks and debuffs
  void handleAttack (int damage, float lengthOfDebuff, ArrayList<debuffTypes> typeOfDebuffs, Projectile Attacker){
    
    
  //first deal damage
    health -=damage;
    
 //I want to make it so each guest has an array that contains projectiles that have already hit them so one projectile doesn't do 200 damage over 2 frames or whatever 
 //but I also don't want these arrays to get super bloated and slow down the game when alot of guests on screen. Something to ponder, for now get nothing actually :-)
 //maybe remove every projectile check after 3 seconds, aka just do the debuff thing slightly less complicated again
  
  //then add debuffs
   for (debuffTypes debuff: typeOfDebuffs) {
     
     currentDebuffs.put(debuff, lengthOfDebuff);
     
     switch(debuff){
       case SLOWNESS:
       //slows the guest down
       slowness = .7;
       currentColor = color (100,100,200);
       break;
       case CULTJARGON:
       //chance to make a cult member, need to ask if we want this to be temp or permanent
       
       
       break; 

     }
     
   }
    
  }
  
  //handles removing and reversing debuffs that have run out of time
  void removeDeadDebuffs(){
    ArrayList<debuffTypes> toRemove = new ArrayList<debuffTypes>();
    
    for (Map.Entry<debuffTypes, Float> debuff : currentDebuffs.entrySet()) {
     if (debuff.getValue() <= 0) {toRemove.add(debuff.getKey());}
     }
    // Remove expired debuffs and reset effects
    for (debuffTypes debuffType : toRemove) {
    currentDebuffs.remove(debuffType);
    
    // Reset effect based on debuff type
    switch(debuffType) {
        case SLOWNESS:
            slowness = 1;
            currentColor = baseColor;
            break;
        case CULTJARGON:
            break;
        }
     } 
  }
  
  
  
  void draw() {
    noStroke();
    fill(currentColor);
    ellipse(position.x,position.y,size, size);
    
    
  } ///truly just a test Guest for detecting by tower, delete it or do whatever you want with it Ry
  //okay now do NOT delete it (without warning) I've added a debuff system
  
}


//to add a debuff, it needs to be added here, in removeDeadDebuffs, handleAtack and also in the child projectile
static enum debuffTypes 
  {
   SLOWNESS,
   CULTJARGON
  };
