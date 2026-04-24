class BaseGuest {
  
  PVector position = new PVector();
  int size= 40;
  float scareRange;
  /*
    I had to change how speed works when implementing pathfinding.
  */
  float speed = 2; 
  int maxHealth = 100; //change this in children not health itself
  int health = maxHealth;
  color baseColor,currentColor;
  boolean terrified = false;
  boolean isCultist = false;
  boolean bandaged = false;
  boolean isOffScreen = false;
  PImage bandages;
  int opacity = 255;
  
  Point gridP = new Point(); // current position
  Point gridT = new Point(15, 14); // target position (pathfinding goal)
  //debuff variables ENUMS BELOW  BASE GUEST CLASS

  ArrayList<Tile> path;    // the path to follow to get to the target position
  boolean findPath = false;
  
  //contains all debuffs with their leftover time
  HashMap<debuffTypes,Float> currentDebuffs = new HashMap<debuffTypes, Float>();
  HashMap<Attack,Float> hitAttacks= new HashMap<Attack, Float>();
  float slowness = 1;
  
  //right now when the mummy shoots a guest their slowness and color are changed permanently
  //I just did this so I could make sure they were being hit, I want to wait to add timers until 
  //we discuss how we want to handle debuffs
  BaseGuest(int x, int y){
  bandages = loadImage("sprites/bandages.png");
  teleportTo(gridP);
  position.x = x;
  position.y = y;
  baseColor = color(100,100,100);
  currentColor = baseColor;
  setTargetPosition(new Point(14, 15));
  }
  
  void update(){
    if (health <= 0 && terrified != true) {
      terrified = true;
      speed *= 2;
      currentMoney += 10;
      onDeath();
  }
    // this is just debugging I wanted to make sure that actors could track the position of guests
    //position.y += speed*dt *slowness;
    
    if (findPath) findPathAndTakeNextStep();
    updateMove();
    
    
    
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
  
  
  //on death, call this func to add a review to displayedtext
  void addReviewToDisplay (){
  //on death, call this func on death
  //-it handles review and changes to entertainmentValue
  }
  void onDeath (){
    String review;
     if(terrified){ //5 star reviews
      int randomIndex = (int) random(fiveStarList.size()); 
      review = "5/5 Stars: " + fiveStarList.get(randomIndex);
      entertainmentValue += .1;
     }
     else if (health >= maxHealth/2){ //3 star reviews
     int randomIndex = (int) random(threeStarList.size()); 
     review = "3/5 Stars: " + threeStarList.get(randomIndex);
     
     }
     else {//1 star review
    int randomIndex = (int) random(threeStarList.size()); 
    review = "1/5 Stars: " + threeStarList.get(randomIndex);
    entertainmentValue -= .2;
    if (entertainmentValue > 1) entertainmentValue = 1; 
    }
     if (mainScreen != null){
       mainScreen.textDisplay.addNewText(review);
      }
  }
  void ExitScreen() {
    //onDeath();
    isOffScreen = true;
    
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
    tint(255, opacity);
    ellipse(position.x,position.y,size, size);
    if (bandaged){
    pushMatrix();
    translate(position.x+3, position.y);
    imageMode(CENTER);
    bandages.resize(int(size+20), int(size+20)); //changes to make temp sprite look better
    image(bandages, 0, 0);
    popMatrix();
    }
    
    noTint();
  } ///truly just a test Guest for detecting by tower, delete it or do whatever you want with it Ry
  //okay now do NOT delete it (without warning) I've added a debuff system
  
  //PATHFINDING FUNCTIONS
  void teleportTo(Point gridP) {
    Tile tile = level.getTile(gridP);
    if (tile != null) {
      this.gridP = gridP.get();
      this.gridT = gridP.get();
      this.position = tile.getCenter();
    }
  }
    
  void setTargetPosition(Point gridT) {
    this.gridT = gridT.get();
    findPath = true;
  }
  
  void findPathAndTakeNextStep() {
    findPath = false;
    Tile start = level.getTile(gridP);
    Tile end = level.getTile(gridT);
    if (start == end) {
      path = null;
      return;
    }
    path = pathfinder.findPath(start, end);

    if (path != null && path.size() > 1) { 
      Tile tile = path.get(1);
      if(tile.isPassable()) gridP = new Point(tile.X, tile.Y);
    }
  }
  
  void updateMove() {
    
    float snapThreshold = 3.5;
    PVector pixlT = level.getTileCenterAt(gridP);
    PVector diff = PVector.sub(pixlT, position);
    PVector normDiff = diff.normalize();
    
    position.x += normDiff.x * speed;
    position.y += normDiff.y * speed;
    
    
    
    if (path != null) {
      if (abs(position.x - pixlT.x) < snapThreshold) position.x = pixlT.x; 
      if (abs(position.y - pixlT.y) < snapThreshold) position.y = pixlT.y;
      
      if (pixlT.x == position.x && pixlT.y == position.y) findPath = true;
    } else if (path == null) {
      position.y += speed * 2;
      opacity -= 10;
      if (opacity <= 10) {
        ExitScreen();
      }
    }
    
    
    
  }
  
}


//to add a debuff, it needs to be added here, in removeDeadDebuffs, handleAtack and also in the child projectile
static enum debuffTypes 
  {
   SLOWNESS,
   CULTJARGON
  };
  
  
  //----------------------------------------------------------------------------------------------------------
  //---------------------------------------------     PATHFINDER    ------------------------------------------
  //----------------------------------------------------------------------------------------------------------
  
  class Pathfinder {

  boolean useManhattan = true;
  boolean useDiagonals = false;
  ArrayList<Tile> opened = new ArrayList<Tile>(); // collection of tiles we can use to solve the algorithm
  ArrayList<Tile> closed = new ArrayList<Tile>(); // collection of tiles that we've ruled out as NOT part of the solution

  Pathfinder() {
  }

  ArrayList<Tile> findPath(Tile start, Tile end) {

    // TODO: make the pathfinding algorithm ;)
    
    opened.clear();
    closed.clear();
    
    start.resetParent();
    
    // Step 1: connect the start and end tiles
    
    connectStartToEnd(start, end);
    
    // Step 2: Build Path Back to Beginning
    
    ArrayList<Tile> path = new ArrayList<Tile>();
    Tile pathNode = end;
    while(pathNode != null) {
      path.add(pathNode);
      pathNode = pathNode.parent;
      
    }
    
    // Step 3: Reverse the Collection
    ArrayList<Tile> rev = new ArrayList<Tile>();
    int maxIndex = path.size() - 1;
    for (int i = maxIndex; i >= 0; i--) {
      rev.add(path.get(i));
    }
    
    
    return rev;
  }
  /**
   * This method is simply for debugging. It prints out a path to the console.
   * @param ArrayList<Tile> path  The path to print out.
   */
  void outputPath(ArrayList<Tile> path) {
    println("BEST PATH:");
    int i = 0;
    for (Tile t : path) {
      print("\t" + i + ": " + t.X + ", " + t.Y);
      if (i == 0) print(" (current location)");
      println();
      i++;
    }
  }
  void connectStartToEnd(Tile start, Tile end) {

    // TODO: Make the algorithm
    opened.add(start);

    while (opened.size() > 0) {
      // GET THE NODE IN THE OPEN LIST WITH THE LOWEST F VALUE
      float F = 99999;
      int index = -1;

      for (int i = 0; i < opened.size(); i++) {
        Tile temp = opened.get(i);
        if (temp.F < F) {
          F = temp.F;
          index = i;
        }
      }

      Tile current = opened.remove(index);
      closed.add(current);

      if (current == end) {
        //Path is found!! :3
        break;
      }

      // loop through all of current's neighbors:
      for (int i = 0; i < current.neighbors.size(); i++) {
        Tile neighbor = current.neighbors.get(i);
        if (!tileInArray(closed, neighbor)) {
          if (!tileInArray(opened, neighbor)) {
            opened.add(neighbor);
            neighbor.setParent(current);
            neighbor.doHeuristic(end, useManhattan);
          } else {
            if (neighbor.G > current.G + neighbor.getTerrainCost()) {
              neighbor.setParent(current);
              neighbor.doHeuristic(end, useManhattan);
            } //end if
          } // end else
        } // end if
      } // end all neighbors
    } // end while loop
  } // end method
  /**
   * This method returns true if a particular tile is already in an ArrayList.
   * @param ArrayList<Tile> a  The haystack to search in.
   * @param Tile t  The needle to search for.
   * @return boolean  Whether or not the needle is in the haystack.
   */
  boolean tileInArray(ArrayList<Tile> a, Tile t) {
    for (int i = 0; i < a.size (); i++) {
      if (a.get(i) == t) return true;
    }
    return false;
  }
  /*
   * Changes the heuristic.
   */
  void toggleHeuristic() {
    useManhattan = !useManhattan;
  }
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
