class BaseGuest {
  
  PVector position = new PVector();
  int size= 40;
  float scareRange;
  float speed = 20;
  int health = 100;
  color baseColor,currentColor;
  boolean terrified = false;
  boolean isCultist = false;
  boolean bandaged = false;
  PImage bandages;
  //debuff variables ENUMS BELOW  BASE GUEST CLASS
  
  //contains all debuffs with their leftover time
  HashMap<debuffTypes,Float> currentDebuffs = new HashMap<debuffTypes, Float>();
  HashMap<Attack,Float> hitAttacks= new HashMap<Attack, Float>();
  float slowness = 1;
  
  //right now when the mummy shoots a guest their slowness and color are changed permanently
  //I just did this so I could make sure they were being hit, I want to wait to add timers until 
  //we discuss how we want to handle debuffs
  BaseGuest(int x, int y){
  bandages = loadImage("sprites/bandages.png");
  position.x = x;
  position.y = y;
  baseColor = color(100,100,100);
  currentColor = baseColor;
  }
  
  void update(){
    if (health <= 0 && terrified != true) {
      terrified = true;
      speed = 40;
      currentMoney += 10;
  }
    // this is just debugging I wanted to make sure that actors could track the position of guests
    position.y += speed*dt *slowness;
    
    
    for(Map.Entry<debuffTypes, Float> debuff : currentDebuffs.entrySet()){
     float currentTime = debuff.getValue();
     float newTime = currentTime-dt;
        // Update the timer
        debuff.setValue(newTime);
    }
    for(Map.Entry<Attack,Float> attack : hitAttacks.entrySet()){
     float currentTime = attack.getValue();
     float newTime = currentTime-dt;
        // Update the timer
        attack.setValue(newTime);
    }
    //remove all debuffs with less than 0 timer
    removeDeadDebuffs();
    removeDeadAttacks();
     
    
    
    
  }
  
  
  //handles all attacks and debuffs
  void handleAttack (int damage, float lengthOfDebuff, ArrayList<debuffTypes> typeOfDebuffs, Attack attacker){
    
    //checks if this attack has already hit guest
   if (hitAttacks.containsKey(attacker)) {

        return; // Already hit by this attack
    }

  //first deal damage
    health -=damage;
  //add projectile to hit arraylist so no doublehits
  hitAttacks.put(attacker,(attacker.lifetime +.5));
  //then add debuffs
   for (debuffTypes debuff: typeOfDebuffs) {
     
     if (debuff == debuffTypes.CULTJARGON) {
       float randomCultistChance = random(0,50);
       if (randomCultistChance <= 40){ 
         //if smaller than 40, guest is not convinced
       continue;
       }
     }
       
     currentDebuffs.put(debuff, lengthOfDebuff);
     
     switch(debuff){
       case SLOWNESS:
       //slows the guest down
       slowness = .65;
       bandaged = true;
       break;
       case CULTJARGON:
       //chance to make a cult member, need to ask if we want this to be temp or permanent
       
       currentColor = color (100,200,100);
       isCultist = true;
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
            bandaged = false;
            break;
        case CULTJARGON:
             
             currentColor = baseColor;
            break;
        }
     } 
  }
  
  void removeDeadAttacks(){
    ArrayList<Attack> toRemove = new ArrayList<Attack>();
    
    for (Map.Entry<Attack,Float> attack : hitAttacks.entrySet()) {
     if (attack.getValue() <= 0) {toRemove.add(attack.getKey());}
     }
    // Remove expired debuffs and reset effects
    for (Attack attack : toRemove) {
    hitAttacks.remove(attack);
     } 
  }
  
  void draw() {
    noStroke();
    fill(currentColor);
    ellipse(position.x,position.y,size, size);
    if (bandaged){
    pushMatrix();
    translate(position.x+3, position.y);
    imageMode(CENTER);
    bandages.resize(int(size+20), int(size+20)); //changes to make temp sprite look better
    image(bandages, 0, 0);
    popMatrix();
    }
    
    
  } ///truly just a test Guest for detecting by tower, delete it or do whatever you want with it Ry
  //okay now do NOT delete it (without warning) I've added a debuff system
  
}


//to add a debuff, it needs to be added here, in removeDeadDebuffs, handleAtack and also in the child projectile
static enum debuffTypes 
  {
   SLOWNESS,
   CULTJARGON
  };
