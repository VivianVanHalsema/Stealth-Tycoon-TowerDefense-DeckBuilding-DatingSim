class MainScreen {
  
  IntroText introText;
  

  int maxScaractors = 15;
  int currentScaractorCount;

  PImage background;

  Camera camera;

  PVector savedMousePosForCamera;

  Point pPointG;

  //textDisplay
  TextDisplayComponent textDisplay;

  //buttons
  Button titleButton;
  Button dashLockButton;
  Button deleteActorButton;
  Button waveStartButton;
  Button breakRoomButton;
  DashBoardButton speedUpButton;
  TabButton hireButton;
  TabButton statsButton;
  TabButton settingsButton;
  //shopButtons
  ShopButton mummyButton;
  ShopButton jasonButton;
  ShopButton witchyButton;
  ShopButton cultistButton;
  ShopButton wallButton;
  ShopButton bloodButton;
  ShopButton tombstoneButton;
  ShopButton handsButton;
  ShopButton vampireButton;
  ShopButton werewolfButton;


  //MoneySystem moneySystem;
  ArrayList<Button> buttonsToAttachToDashboard = new ArrayList<Button>();
  boolean isDeletingMode;

  MainScreen() {
    
    introText = new IntroText(); //initializing the intro text

    //Pathfinding Initialization
    TileHelper.app = new STTDDDS();
    level = new Level();
    pathfinder = new Pathfinder();
    pPointG = new Point(-1, -1);

    camera = new Camera();
    textDisplay = new TextDisplayComponent(20, height-20);
    background = loadImage("sprites/background.png");
    background.resize(1300, 1300);

    //Button Initializations go here!!
    titleButton = new Button(width + 240, 20, "SWITCH_TITLE");
    buttons.add(titleButton);
    dashLockButton = new Button(width - 50, 0, "TOGGLE_DASHBOARD_LOCK");
    buttons.add(dashLockButton);
    waveStartButton = new Button(20, 40, "WAVE_START");
    buttons.add(waveStartButton);
    breakRoomButton = new Button(20, 80, "SWITCH_TO_BREAKROOM");
    buttons.add(breakRoomButton);
    deleteActorButton = new Button(width+145, 650, "DELETE_ACTOR");
    buttons.add(deleteActorButton);
    speedUpButton = new DashBoardButton(width+50, 50, "TOGGLE_SPEED", dashboardTabs.HIRE);
    buttons.add(speedUpButton);


    //Tab buttons initializations go here!!!!
    //hireButton = new TabButton(width-40, (height/8*1), "SWITCH_TABS", dashboardTabs.HIRE);
    //buttons.add(hireButton);
    //statsButton = new TabButton(width-40, (height/8*5), "SWITCH_TABS", dashboardTabs.STATS);
    //buttons.add(statsButton);
    //settingsButton = new TabButton(width-40, (height/8*7), "SWITCH_TABS", dashboardTabs.SETTINGS);
    //buttons.add(settingsButton);

    //Dashboard button initializations go here!!!!
    // moneySystem = new MoneySystem();
    mummyButton = new ShopButton(width+240, 100, "GET_TOWER", dashboardTabs.HIRE, actorTypes.MUMMY);
    buttons.add(mummyButton);

    jasonButton = new ShopButton(width+50, 100, "GET_TOWER", dashboardTabs.HIRE, actorTypes.JASON);
    buttons.add(jasonButton);
    
    cultistButton = new ShopButton(width+50, 180, "GET_TOWER", dashboardTabs.HIRE, actorTypes.CULTIST);
    buttons.add(cultistButton);

    witchyButton = new ShopButton(width+240, 180, "GET_TOWER", dashboardTabs.HIRE, actorTypes.WITCHDOCTOR);
    buttons.add(witchyButton);

    wallButton = new ShopButton(width+50, 400, "GET_TOWER", dashboardTabs.HIRE, actorTypes.WALL);
    buttons.add(wallButton);
    
    tombstoneButton = new ShopButton(width+50, 480, "GET_TOWER", dashboardTabs.HIRE, actorTypes.TOMBSTONE);
    buttons.add(tombstoneButton);
    
    handsButton = new ShopButton(width+240, 400, "GET_TOWER", dashboardTabs.HIRE, actorTypes.HANDS);
    buttons.add(handsButton);
    
    bloodButton = new ShopButton(width+240, 480, "GET_TOWER", dashboardTabs.HIRE, actorTypes.BLOOD);
    buttons.add(bloodButton);

    vampireButton = new ShopButton(width+50, 260, "GET_TOWER", dashboardTabs.HIRE, actorTypes.VAMPIRE);
    buttons.add(vampireButton);
    
    werewolfButton = new ShopButton(width+240, 260, "GET_TOWER", dashboardTabs.HIRE, actorTypes.WEREWOLF);
    buttons.add(werewolfButton);


    //DASHBOARD INITIALIZATION
    //----Add buttons that should be attached to the dashboard and move with
    //----it in here using the buttonsToAttachToDashboard array list like shown below
    buttonsToAttachToDashboard.add(titleButton);
    buttonsToAttachToDashboard.add(dashLockButton);
    buttonsToAttachToDashboard.add(mummyButton);
    buttonsToAttachToDashboard.add(jasonButton);
    buttonsToAttachToDashboard.add(witchyButton);
    buttonsToAttachToDashboard.add(cultistButton);
    buttonsToAttachToDashboard.add(wallButton);
    buttonsToAttachToDashboard.add(tombstoneButton);
    buttonsToAttachToDashboard.add(handsButton);
    buttonsToAttachToDashboard.add(bloodButton);
    buttonsToAttachToDashboard.add(deleteActorButton);
    //buttonsToAttachToDashboard.add(hireButton);
    //buttonsToAttachToDashboard.add(statsButton);
    //buttonsToAttachToDashboard.add(settingsButton);
    buttonsToAttachToDashboard.add(speedUpButton);
    
    buttonsToAttachToDashboard.add(vampireButton);
    buttonsToAttachToDashboard.add(werewolfButton);
    //buttonsToAttachToDashboard.add(hireButton);
    //buttonsToAttachToDashboard.add(upgradeButton);
    //buttonsToAttachToDashboard.add(statsButton);
    //buttonsToAttachToDashboard.add(settingsButton);
    //------------------------------, location(tostart), ----------location(toend), -------------------Stored Button Elements
    uiDashboard = new MovingDashboard( new PVector(width - 50, 0), new PVector(width - 450, 0), buttonsToAttachToDashboard);
  }

  void update() {

    buttonPlaceCooldown -= dt;

    if (Mouse.onDown(Mouse.LEFT)) {

      //if intro is still going, advance by clicking left click
      if (introText != null && introText.active) {
       introText.advance(); 
      } else {

       if (isDeletingMode) {
            // In delete mode, try to delete on click
            checkDeletionOnClick();
       }else{
      PrevButtonClickCheck();
      PlacingActorLogic(false);
       }
    } // mouse click!!
  }
    if (Mouse.isDown(Mouse.LEFT)) {
      if (buttonPlaceCooldown < 0) PlacingActorLogic(false);
    }

    if (Mouse.onDown(Mouse.RIGHT)) {
      savedMousePosForCamera = new PVector(camera.x + mouseX, camera.y + mouseY);
      actorPlacing = null;
        if (isDeletingMode) {
            toggleDeleteMode();
        }
    }

    if (Mouse.isDown(Mouse.RIGHT)) {
      camera.x = savedMousePosForCamera.x - mouseX;
      camera.y = savedMousePosForCamera.y - mouseY;

      if (camera.x < -75) camera.x = -75;
      if (camera.x > -5) camera.x = -5;
      if (camera.y < -50) camera.y = -50;
      if (camera.y > 530) camera.y = 530;

      camera.tx = camera.x;
      camera.ty = camera.y;
    }

    camera.update();
    //UI Dashboard updates before buttons for movement and organization
    uiDashboard.update();
    waveManager.update();
    textDisplay.update();
    ButtonUpdate();

    if (actorPlacing != null) {
      actorPlacing.update();
    }

    for (Attack p : attacks) {
      p.update();
    }
    attacks.addAll(aoeAttacks);
    aoeAttacks.clear(); //so it doesn't accumulate

    for (int i = attacks.size() - 1; i >= 0; i--) {
      if (!attacks.get(i).isAlive) {
        attacks.remove(i);
      }
    }
    for (int i = 0; i < guests.size(); i++) {
      BaseGuest guest = guests.get(i);
      guest.update();
      if (guest.isOffScreen) guests.remove(i);
    }
    for (BaseActor actor : actors) {
      actor.update();
    }
  }

  void draw() {

    //All Objects Past this point Until UI Drawing Layer are moved with camera
    pushMatrix();
    translate(width/2, height/2);
    zoom = lerp(zoom, targetZoom, .08); //zoom smoothing
    scale(zoom);
    translate(-width/2 - camera.x, -height/2 - camera.y);
    // End Camera Code, It now is moving other objects

    //-----------------------------------Background Drawing Layer----------------------------
    background(64, 0, 64);
    imageMode(CORNER);
    image(background, -50, -50);
    imageMode(CENTER);
    level.draw();

    Point g = TileHelper.pixelToGrid(new PVector(mouseX, mouseY), new PVector(camera.x, camera.y), zoom);
    Tile tile = level.getTile(g);
    if (tile != null) { //This is for safety to avoid null pointers with camera stuffs
      tile.hover = true;
      fill(0);
    }
    if ((g.x != pPointG.x) || (g.y != pPointG.y)) {
      placeable = true;
    }
    //draws a little x overlay over actors in delete mode :-)
    
    



    //-----------------------------------Grid Drawing Layer----------------------------------


    //-----------------------------------Character Drawing Layer-----------------------------
    for (Attack p : attacks) {
      p.draw();
    }
    
    for (BaseActor actor : actors) {
      actor.draw();
    }
    
    for (BaseGuest guest : guests) { //Reordered for ghosties to go over walls and still be visible
      guest.draw();
    }


    //-------------------------------------VFX Drawing Layer---------------------------------
    //draw a little x over characters so we can delete them :-)
    if (isDeletingMode) {
    // Draw a red overlay on tiles with actors
    for (BaseActor actor : actors) {
        noFill();
        stroke(255, 0, 0, 150);
        strokeWeight(3);    
        // Draw an X through the actor
        line(actor.position.x - 25, actor.position.y - 25, actor.position.x + 25, actor.position.y + 25);
        line(actor.position.x + 25, actor.position.y - 25, actor.position.x - 25, actor.position.y + 25);
    }
    }



    popMatrix(); //No longer Following Camera
    //-------------------------------------UI DRAWING Layer---------------------------------
    //UI Dashboard is drawn here before buttons so the buttons stay visible on the dashboard




    textAlign(LEFT);
    fill (255);
    text(("$"+ floor(currentMoney)), 1000, 30);
    text(("Scaractors: " + currentScaractorCount + "/" + maxScaractors), 1000, 60);
    text("Current Wave :" + currWave, 20, 20);
    uiDashboard.draw();
    textDisplay.draw();
    ButtonDraw();


    if (actorPlacing != null) {
      actorPlacing.draw();
    }
    
    if (introText != null && introText.active) {
     introText.draw(); 
    }

    pPointG = g;
  }

  void PlacingActorLogic(boolean movingVampy) { //I decided to unnest this a little because it was gross and getting wayyy too many conditions :3

    if (actorPlacing == null) return; //If we aren't in the placing state, don't continue
    if (actorPlacing.purchasedThisFrame == true) return; //If we just clicked the button, don't continue or else we will insta autoplace a tower behind dash

    //Find our tile
    Point g = TileHelper.pixelToGrid(new PVector(mouseX, mouseY), new PVector(camera.x, camera.y), zoom);
    Tile tile = level.getTile(g);

    if (tile == null || tile.isPassable() == false) return;

    level.setTile(g, 2);
    pathfinder.findPath(level.getTile(new Point(0, 0)), level.getTile(new Point(14, 15)));
    
    if (pathfinder.pathBlocked == false && !(g.x == 0 && g.y == 0)) { 
      
      if (currentMoney >= currentPrice && currentScaractorCount < maxScaractors) {
        PVector placingPosition = tile.getCenter();
        PlaceActorSwitch(placingPosition, g); //Gets the actor being placed and places it
        if (!movingVampy) currentMoney -= currentPrice; //Spend money on place
        actors = sortObjectsByHeight(); //We use this so walls can be bigger than a tile for faux 3d feels
      }

      
    } else { //the path is blocked!!
      level.setTile(g, 0);
      placeable = false;
    } //end of pathfinding block check
    pathfinder.pathBlocked = false;
  }


  void PlaceActorSwitch(PVector placingPosition, Point g) {
    switch(actorPlacing.actor) {
    case MUMMY:
      Mummy mummyToAdd;
      mummyToAdd = new Mummy(int(placingPosition.x), int(placingPosition.y), actorTypes.MUMMY);
      actors.add(mummyToAdd);
      currentScaractorCount++;
      break;

    case CULTIST:
      Cultist cultistToAdd;
      cultistToAdd = new Cultist(int(placingPosition.x), int(placingPosition.y), actorTypes.CULTIST);
      actors.add(cultistToAdd);
      break;

    case VAMPIRE:
      Vampire vampireToAdd;
      vampireToAdd = new Vampire(int(placingPosition.x), int(placingPosition.y), actorTypes.VAMPIRE);
      actors.add(vampireToAdd);
      currentScaractorCount++;
      break;

    case JASON:
      Jason jasonToAdd = new Jason(int(placingPosition.x), int(placingPosition.y), actorTypes.JASON);
      actors.add(jasonToAdd);
      currentScaractorCount++;

      break;

    case WITCHDOCTOR:
      WitchDoctor witchDoctorToAdd = new WitchDoctor(int(placingPosition.x), int(placingPosition.y), actorTypes.WITCHDOCTOR);
      actors.add(witchDoctorToAdd);
      currentScaractorCount++;
      break;

    case WALL:
      PlaceableWall wallToAdd = new PlaceableWall(int(placingPosition.x), int(placingPosition.y), actorTypes.WALL);
      actors.add(wallToAdd);
      break;
    case WEREWOLF:
      Werewolf werewolfToAdd = new Werewolf(int(placingPosition.x), int(placingPosition.y), actorTypes.WEREWOLF);
      actors.add(werewolfToAdd);
      currentScaractorCount++;
      break;
    case BLOOD:
    
     level.setTile(g,2);
     Blood bloodToAdd = new Blood(int(placingPosition.x), int(placingPosition.y), actorTypes.BLOOD);
      actors.add(bloodToAdd);
    break;
    case HANDS:
    
     level.setTile(g,2);
     Hands handsToAdd = new Hands(int(placingPosition.x), int(placingPosition.y), actorTypes.HANDS);
      actors.add(handsToAdd);
    break;
    case TOMBSTONE:
     level.setTile(g,2);
     Tombstone tombstoneToAdd = new Tombstone(int(placingPosition.x), int(placingPosition.y), actorTypes.TOMBSTONE);
      actors.add(tombstoneToAdd);
    break;
    }
  }
  
  //
  void toggleSpeedUp() {
    if (gameSpeed ==1) {gameSpeed =2;}
    else if(gameSpeed ==2) {gameSpeed =1;}
    speedUpButton.text = gameSpeed + "x";
  }
  
  
  //TOGGLE DELETE MODE TO GET RID OF STUFF
  void toggleDeleteMode() {
    isDeletingMode = !isDeletingMode;
    // Cancel any placing mode when entering delete mode
    if (isDeletingMode && actorPlacing != null) {
        actorPlacing = null;
    }
    // Update button text to show current mode
    deleteActorButton.text = isDeletingMode ? "Cancel Delete" : "Delete Mode";
}
  
void checkDeletionOnClick() {
    Point g = TileHelper.pixelToGrid(new PVector(mouseX, mouseY), new PVector(camera.x, camera.y), zoom);
    Tile tile = level.getTile(g);
    if (tile != null) {
        PVector clickPos = tile.getCenter();
        // Find actor at this position (search backwards so higher Y actors get selected first)
        BaseActor actorToDelete = null;
        for (int i = actors.size() - 1; i >= 0; i--) {
            BaseActor actor = actors.get(i);
            if (dist(actor.position.x, actor.position.y, clickPos.x, clickPos.y) < 45) {
                actorToDelete = actor;
                break;
            }
        }
        
        if (actorToDelete != null) {
            actors.remove(actorToDelete);
            // Reset the tile (make it passable again)
            if (level.getTile(g).TERRAIN == 2) {
                level.setTile(g, 0);
                // Recalculate pathfinding
                pathfinder.findPath(level.getTile(new Point(0, 0)), level.getTile(new Point(14, 15)));
            }
            // Sort actors again
            actors = sortObjectsByHeight();
            
            // Optional: Add a sound or visual feedback
            println("Deleted actor at position: " + clickPos);
        }
    }
}


  ArrayList<BaseActor> sortObjectsByHeight() {
    /*
  I know this shit is not a very optimal sorting algorithm but it's quick and easy to set up
     and we are only calling it on the frame a player places something so it shouldn't hurt too bad
     */
    ArrayList<BaseActor> sortedByHeightActors = actors;
    boolean swapped;
    BaseActor temp;
    for (int i = 0; i < sortedByHeightActors.size(); i++) {
      swapped = false;
      for (int j = 0; j < sortedByHeightActors.size() - i - 1; j++) {
        if (sortedByHeightActors.get(j).position.y > sortedByHeightActors.get(j+1).position.y) {
          temp = sortedByHeightActors.get(j);
          sortedByHeightActors.set(j, sortedByHeightActors.get(j+1));
          sortedByHeightActors.set(j + 1, temp);
          swapped = true;
        }
      }
      if (!swapped) break;
    }

    return sortedByHeightActors;
  }
}
