//This is the code that creates the break room area

class BreakRoom {
 Button backButton;
 
 //room layouts gonna be smaller than the main level since it doesn't need to be that big.
 //im thinking like 6 x 6 rows and columns, will test later to see if I feel differnt
 int tileSize = 64;
 int roomCols = 6;
 int roomRows = 6;
 int roomOffsetX;
 int roomOffsetY;
 
 BreakRoomActor selectedActor = null;
 
 //new array list for actors in the breakroom to represent their sprites that show up
 //instead of making a new tab im leaving them here in breakRoom 
 ArrayList<BreakRoomActor> breakRoomActors = new ArrayList<BreakRoomActor>();
 
 //upgrade panel 
 //using same style as main menu and keeping it seperate so I can expand more of it later
 UpgradePanel upgradePanel;
 
 BreakRoom() {
  //center room on the screen here
  roomOffsetX = (width - roomCols * tileSize) / 2;
  roomOffsetY = (height - roomRows * tileSize) /2 + 20;
  
  backButton = new Button(20, 20, "SWITCH_MAIN");
  buttons.add(backButton);
  
  //basically when the room is created, it scans the global actors list and builds one
  //entry per each unique actor type the player has bought (not each active tower of the same type)
  //positions are gonna be randomly within the walls of the break room.
  buildActorList();
  
  //creates the panel once on right side of screen,
  upgradePanel = new UpgradePanel();
 }
 
 void buildActorList() {
   
  //scans global actors list and collects one of each type and loads its sprite. 
  breakRoomActors.clear();
  
  //tracks which types that are already added so it only has one per type instead of multiple
  //(this ones gonna be hard to test rn since we're short on sprites for each actor lol)
  ArrayList<actorTypes> seen = new ArrayList<actorTypes>();
  
  for (BaseActor actor : actors) {
   actorTypes type = getActorType(actor);
   if (type == null) continue; //skips unknown subclasses
   if (seen.contains(type)) continue; //already has this type so it moves on
   seen.add(type);
   
   int floorCol = int(random(1, roomCols - 1));
   int floorRow = int(random(1, roomRows - 1));
   
   float px = roomOffsetX + floorCol * tileSize + tileSize / 2;
   float py = roomOffsetY + floorRow * tileSize + tileSize / 2;
   
   //reuses same sprite so it doesn't gotta loadImage
   breakRoomActors.add(new BreakRoomActor(type, actor.sprite, px, py));
  }
 } 
 
 //basically figures out which actorTypes enum value matches the given baseActor instance.
 actorTypes getActorType(BaseActor actor) {
  if (actor instanceof Mummy) return actorTypes.MUMMY;
  if (actor instanceof Jason) return actorTypes.JASON;
  if (actor instanceof WitchDoctor) return actorTypes.WITCHDOCTOR;
  if (actor instanceof Cultist) return actorTypes.CULTIST;
  //add here if we add more classes
  return null;
    
 }
 
 void update() {
  if (Mouse.onDown(Mouse.LEFT)){
    
    //adding checks for itf on any of the resting actor sprites 
    //keeping above prevButtonClick so it takes the priority
    boolean clickedActor = false;
    for (BreakRoomActor g : breakRoomActors) {
      if (g.checkClicked()){
       selectedActor = g;
       //tells upgrade panel which actors to display info for
       upgradePanel.setActor(selectedActor);
       upgradePanel.visible = true;
       clickedActor = true;
       break;
      }
     }
   
   //if the player has clicked anywhere that isn't an actor and insde the upgrade panel, immediately close it
   if (!clickedActor && !upgradePanel.checkHovered()) {
    selectedActor = null;
    upgradePanel.visible = false;
   }
   PrevButtonClickCheck(); 
  }
  
  upgradePanel.update();
  ButtonUpdate();
 }

void draw() {
 //dark background cuz spoopy
 background(35, 25,40);
 drawBreakRoomTiles();  //walls and floor stuff
 
 //draws each actors sprite, draw AFTER tiles so it appears on top instead of behindj
 for (BreakRoomActor g : breakRoomActors) {
   g.draw();
 }
 
 //Room Title
 fill(220, 180, 255);
 textAlign(CENTER);
 textSize(22);
 text(" BREAK ROOM ", width/2, roomOffsetY - 16);
 
 //little flavour text
 fill(160, 140, 180);
 textSize(13);
 text("You decide to send out breaks before the next wave.", width/2, roomOffsetY + roomRows * tileSize + 24);
 
 upgradePanel.draw();
 
 ButtonDraw();
}

void drawBreakRoomTiles(){
 rectMode(CORNER);
 noStroke();
 
 for(int row = 0; row < roomRows; row++) {
  for (int col = 0; col < roomCols; col++) { 
    float x = roomOffsetX + col * tileSize;
    float y = roomOffsetY + row * tileSize;
    
    boolean isWall = (row == 0 || row == roomRows - 1 ||
                      col == 0 || col == roomCols - 1);
                      
    if (isWall) {
     //some walls
     fill(60, 50, 80);
     rect(x, y, tileSize, tileSize);
     //highlight for depth
     fill(80, 65, 100);
     rect(x + 2, y + 2, tileSize - 4, 6);
     rect(x + 2, y + 2, 6, tileSize - 4);
    } else {
      //floor tiles 
      if((row + col) % 2 == 0) {
        fill(90, 75, 110);
      }else {
       fill(75, 62, 95);
      }
      rect(x, y, tileSize, tileSize);
      
      //tile grout lines
      stroke(50, 40, 65);
      strokeWeight(1);
      noFill();
      rect(x + 1, y + 1, tileSize - 2, tileSize - 2);
      noStroke();
    }
  }
}

//Draw a rug in corner cuz it was in the budget
float rugX = roomOffsetX + tileSize * 2;
float rugY = roomOffsetY + tileSize * 2;
float rugW = tileSize * 2;
float rugH = tileSize * 2;
fill(120, 40, 60, 180);
rect(rugX + 6, rugY + 6, rugW - 12, rugH - 12, 6);
stroke(160, 60, 80, 160);
strokeWeight(3);
noFill();
rect(rugX + 10, rugY + 10, rugW - 20, rugH - 20, 4);
noStroke();

 }
}

//just a container that holds everything the break room needs to know for the actor spawns
class BreakRoomActor {
 actorTypes type;
 PImage sprite;
 float x, y;
 
 //per-tower display infor for upgrade panel
 String displayName;
 String loreDescription;
 
 //upgrade labels, no functionality yet, just text and names
 String[] upgradeNames =  new String[3];
 String[] upgradeDescriptions = new String[3];
 
 BreakRoomActor(actorTypes type, PImage sprite, float x, float y) {
  this.type = type;
  this.sprite = sprite; 
  this.x = x; 
  this.y = y;
  
  //lore text and stuff based on which tower your looking at
  //add cases here when new towers are made. 
  switch(type) {
   
    
    
    case MUMMY: 
      displayName = "The Mummy";
      loreDescription = "An ancient egyptian horror unleashed from its tomb.../n" +
                        "The basement of the building./m" +
                        "Despite their slow firing speed, their range is considerable/n" +
                        "wrapping guests in their seemingly endless wrappings slowing their escape/n" + 
                        "Fun Fact: Despite their looks and inability to speak beyond mumblings,/n" +
                        "to their fellow employees, bringing water and snacks on breaks!"; 
      upgradeNames[0] = "Insert Name Here";
      upgradeDescriptions[0] = "Insert Name Here";
      upgradeNames[1] = "Insert Name Here";
      upgradeDescriptions[1] = "Insert Name Here";
      upgradeNames [2] = "Insert Name Here";
      upgradeDescriptions[2] = "Insert Name Here";
      break; 
      
      
      
      case JASON : 
      displayName = "Jason"; 
      loreDescription = "A stalker of the night... a creature of few words and chainsaws.../n"+
                        "Also supposedly has camp counselor work on their resume./n" +
                        "He wields his chainsaw to scare Guests passing him by, /n" +
                        "Though having to explain to him not to actually *USE* it was...difficult./n" +
                        "Fun Fact: Despite the chainsaw murder, he is actually quite chill when you get to know him/n" +
                        "will not stop telling stories about his mother.";
      upgradeNames[0] = "Insert Name Here";
      upgradeDescriptions[0] = "Insert Name Here";
      upgradeNames[1] = "Insert Name Here";
      upgradeDescriptions[1] = "Insert Name Here";
      upgradeNames[2] = "Insert Name Here";
      upgradeDescriptions[2] = "Insert Name Here";
      break;
      
      
      
      case WITCHDOCTOR : 
      displayName = "Witch Doctor"; 
      loreDescription = "From deep in the forest who lures in and seduces passerbys/n"+
                        "to experiement on them with her various brews, also a harvard grad/n" +
                        "majoring in chemistry. She throws her (non-toxic she claims...)/n" +
                        "To scare and slow down passerbys to a crawl, leaving an area of effect for guests./n" +
                        "Fun Fact: She claims she has a brew that turns people into toads.../n" +
                        "Also says she is a pro at DDR.";
      upgradeNames[0] = "Insert Name Here";
      upgradeDescriptions[0] = "Insert Name Here";
      upgradeNames[1] = "Insert Name Here";
      upgradeDescriptions[1] = "Insert Name Here";
      upgradeNames[2] = "Insert Name Here";
      upgradeDescriptions[2] = "Insert Name Here";
      break;
      
      
      
      case CULTIST : 
      displayName = "The Cultist"; 
      loreDescription = "His profile has very litter concrete info about him, he claims to be a servant/n"+
                        "of the deity gro-gazhoush, eater of dimensions, but nobody knows what he means by that./n" +
                        "In spite of this he has an incredibly good wortk ethic and is great at influencing /n" +
                        "The guests that pass him by, so his presence probably shouldn't hurt...right?/n" +
                        "He hands out pamphlets to the guests to indoctrinate them into his cult/n" +
                        "Fun Fact: They are amazing at baking, however despite how good they look you are hesitant to partake....";
      upgradeNames[0] = "Insert Name Here";
      upgradeDescriptions[0] = "Insert Name Here";
      upgradeNames[1] = "Insert Name Here";
      upgradeDescriptions[1] = "Insert Name Here";
      upgradeNames[2] = "Insert Name Here";
      upgradeDescriptions[2] = "Insert Name Here";
      break;
      
     //ADD MORE HERE  
  }
 }
 

//Click detection stuff, if mouse is within 24 pixels of the sprite
boolean checkClicked() {
 return dist(mouseX, mouseY, x, y) < 24; 
}

 void draw() {
  imageMode(CENTER);
  image(sprite, x, y, 45, 45);
 }
}


//Upgrade menu class, menu that appears when you click a tower in the break room.
//made it to match the one on main menu. contains portrait, lore, and upgrade buttons
class UpgradePanel {
 
  //Panel dimensions and position
  float panelX, panelY;
  float panelW = 280;
  float panelH = 520;
  
  //actor being displayed currently
  BreakRoomActor currentActor = null; 
  
  //Is the panel showing?
  boolean visible = false; 
  
  //portrait display area
  float portraitSize = 80;
  float portraitPadding = 16;
  
  //upgrade button layout- basically just 3 stacked buttons at bottom of menu
  float upgradeButtonW = 220;
  float upgradeButtonH = 64;
  float upgradeButtonSpacing = 16;
  
  //Y position of first upgrade button 
  float firstUpgradeButtonY = 280;
  
  //track which upgrade the mouse is hovering, -1 = nothing
  int hoveredUpgrade = -1;
  
  UpgradePanel() {
   //Anchor to right of screen, vertically centered,
   panelX = width - panelW - 20;
   panelY = (height - panelH) /2;
  }
  
  //called from BreakRoom when an actor gets clicked on and loads their info
  void setActor(BreakRoomActor Actor) {
   currentActor = Actor;
  }
  
  //returns true if mouse is anywhere on the panel, used to decide if a click should close the menu
  boolean checkHovered() {
   return mouseX > panelX && mouseX < panelX + panelW && 
          mouseY > panelY && mouseY < panelY + panelH;
  }
  
  void update() {
   if (!visible || currentActor == null) return;
   
    //Tracks hover state for each upgrade button to highlight on mouseOver
    hoveredUpgrade = -1;
    for (int i = 0; i < 3; i++) {
     float bx = panelX + (panelW - upgradeButtonW) / 2;
     float by = panelY + firstUpgradeButtonY + i * (upgradeButtonH + upgradeButtonSpacing);
     if (mouseX > bx && mouseX < bx + upgradeButtonW &&
         mouseY > by && mouseY < by + upgradeButtonH) {
         hoveredUpgrade = i;      
      }
    }
    
    if (Mouse.onDown(Mouse.LEFT) && hoveredUpgrade != -1) {
     int cost = UpgradeDump.getCost(currentActor.type, hoveredUpgrade);
     if (UpgradeDump.canUpgrade(currentActor.type, hoveredUpgrade) && currentMoney >= cost) {
      currentMoney -= cost;
      UpgradeDump.buyUpgrade(currentActor.type, hoveredUpgrade);
      println("Upgraded " + currentActor.displayName + " slot " + hoveredUpgrade);
    }
   }
  }
  void draw() {
   if (!visible || currentActor == null) return;
   
   //panel background
   noStroke();
   fill(40, 30, 55, 230);
   rectMode(CORNER);
   rect(panelX, panelY, panelW, panelH, 10);
   
   //gold border
   stroke(#B4972C);
   strokeWeight(2);
   noFill();
   rect(panelX + 2, panelY + 2, panelW - 4, panelH - 4, 9);
   noStroke();
   
   //Portrait of sprite
   //small box where portrait will be
   float portraitX = panelX + portraitPadding;
   float portraitY = panelY + portraitPadding;
   
   
   //frame background 
   fill(60, 45, 75);
   rect(portraitX, portraitY, portraitSize, portraitSize, 6);
   stroke(#B4972C);
   strokeWeight(1);
   noFill();
   rect(portraitX, portraitY, portraitSize, portraitSize, 6);
   noStroke();
   
   //Tower sprite inside portrait box
   imageMode(CORNER);
   image(currentActor.sprite, portraitX + 8, portraitY + 8,
         portraitSize - 16, portraitSize - 16);
         
    //Tower Name next to portrait
    float nameX = portraitX + portraitSize + 12;
    float nameY = portraitY + 20;
    fill(220, 180, 255);
    textAlign(LEFT);
    textSize(18);
    text(currentActor.displayName, nameX, nameY);
    
    //gold divider under the actor name
    stroke(#B4972C);
    strokeWeight(1);
    line(nameX, nameY + 6, panelX + panelW - portraitPadding, nameY + 6);
    noStroke();
    
    //tower description below portrait
    float loreX = panelX + portraitPadding;
    float loreY = portraitY + portraitSize + 20;
    float loreW = panelW - portraitPadding * 2;
    
    fill(180, 165, 200);
    textAlign(LEFT);
    textSize(12);
    text(currentActor.loreDescription, loreX, loreY, loreW, 120); //uses processing's text overload to handle wrapping
    
    //gold divider for lore
    float dividerY = loreY + 110;
    stroke(#B4972C);
    strokeWeight(1);
    line(panelX + portraitPadding, dividerY,
         panelX + panelW - portraitPadding, dividerY);
    noStroke();
    
    //UPGRADES label
    fill (#B4972C);
    textAlign(CENTER);
    textSize(13);
    text("U P G R A D E S", panelX + panelW / 2, dividerY + 18);
    
    //three upgrade buttons
     for (int i = 0; i < 3; i++) {
      float bx = panelX + (panelW - upgradeButtonW) / 2;
      float by = panelY + firstUpgradeButtonY + i * (upgradeButtonH + upgradeButtonSpacing);
      
    // highlight on hover, same visual language as the main button clsss
    if (hoveredUpgrade == i) {
     fill(255);
     rect(bx - 3, by - 3, upgradeButtonW + 6, upgradeButtonH + 6, 8);
    }
    
    //button body
    if (!UpgradeDump.canUpgrade(currentActor.type, i)) {
        fill(45, 40, 55);
    } else if (currentMoney < UpgradeDump.getCost(currentActor.type, i)) {
        fill(50, 42, 60);
    } else {
        fill(70, 55, 90);
    }
    rect(bx, by, upgradeButtonW, upgradeButtonH, 8);
    
    //gold borders on button
    stroke(#B4972C);
    strokeWeight(1);
    noFill();
    rect(bx, by, upgradeButtonW, upgradeButtonH, 8);
    noStroke();
    
    fill(220, 200, 255);
    textAlign(LEFT);
    textSize(14);
    text(currentActor.upgradeNames[i], bx + 10, by + 20);
    
    //Upgrade description in smaller, dimmer text below the name
    fill(160, 145, 180);
    textSize(11);
    text(currentActor.upgradeDescriptions[i], bx + 10, by +30);
    
    //cost of upgrade
    fill(#B4972C);
    textAlign(RIGHT);
    textSize(13);
    if (!UpgradeDump.canUpgrade(currentActor.type, i)) {
     fill( 100, 90, 110);//dimmed gold for if upgrade is maxxed
     text( "MAXED", bx + upgradeButtonW - 10, by + 20);     
    } else {
     fill(#B4972C);
     text("$" + UpgradeDump.getCost(currentActor.type, i), bx + upgradeButtonW - 10, by + 20);
    }
  }
 }
}
