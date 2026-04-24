class MainScreen {

  PImage background;

  Camera camera;

  PVector savedMousePosForCamera;
  
  Point pPointG;

  //textDisplay
  TextDisplayComponent textDisplay;

  //buttons
  Button titleButton;
  Button dashLockButton;
  Button waveStartButton;
  Button breakRoomButton;
  TabButton hireButton;
  TabButton upgradeButton;
  TabButton statsButton;
  TabButton settingsButton;
  //shopButtons
  ShopButton mummyButton;
  ShopButton jasonButton;
  ShopButton witchyButton;
  ShopButton wallButton;
  

  BaseGuest testGuest;
  Mummy mummyTest;
  Cultist cultistTest;
  //MoneySystem moneySystem;
  ArrayList<Button> buttonsToAttachToDashboard = new ArrayList<Button>();


  MainScreen() {

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


    //Tab buttons initializations go here!!!!
    hireButton = new TabButton(width-40, (height/8*1), "SWITCH_TABS", dashboardTabs.HIRE);
    buttons.add(hireButton);
    upgradeButton = new TabButton(width-40, (height/8*3), "SWITCH_TABS", dashboardTabs.UPGRADE);
    buttons.add(upgradeButton);
    statsButton = new TabButton(width-40, (height/8*5), "SWITCH_TABS", dashboardTabs.STATS);
    buttons.add(statsButton);
    settingsButton = new TabButton(width-40, (height/8*7), "SWITCH_TABS", dashboardTabs.SETTINGS);
    buttons.add(settingsButton);

    //Dashboard button initializations go here!!!!
    // moneySystem = new MoneySystem();
    mummyButton = new ShopButton(width+50, 100, "GET_TOWER", dashboardTabs.HIRE, actorTypes.MUMMY);
    buttons.add(mummyButton);

    jasonButton = new ShopButton(width+50, 180, "GET_TOWER", dashboardTabs.HIRE, actorTypes.JASON);
    buttons.add(jasonButton);

    witchyButton = new ShopButton(width+50, 260, "GET_TOWER", dashboardTabs.HIRE, actorTypes.WITCHDOCTOR);
    buttons.add(witchyButton);

    wallButton = new ShopButton(width+50, 340, "GET_TOWER", dashboardTabs.HIRE, actorTypes.WALL);
    buttons.add(wallButton);


    //DASHBOARD INITIALIZATION
    //----Add buttons that should be attached to the dashboard and move with
    //----it in here using the buttonsToAttachToDashboard array list like shown below
    buttonsToAttachToDashboard.add(titleButton);
    buttonsToAttachToDashboard.add(dashLockButton);
    buttonsToAttachToDashboard.add(mummyButton);
    buttonsToAttachToDashboard.add(jasonButton);
    buttonsToAttachToDashboard.add(witchyButton);
    buttonsToAttachToDashboard.add(wallButton);
    buttonsToAttachToDashboard.add(hireButton);
    buttonsToAttachToDashboard.add(upgradeButton);
    buttonsToAttachToDashboard.add(statsButton);
    buttonsToAttachToDashboard.add(settingsButton);
    //------------------------------, location(tostart), ----------location(toend), -------------------Stored Button Elements
    uiDashboard = new MovingDashboard( new PVector(width - 50, 0), new PVector(width - 450, 0), buttonsToAttachToDashboard);
  }

  void update() {
    
    buttonPlaceCooldown -= dt;

    if (Mouse.onDown(Mouse.LEFT)) {
      PrevButtonClickCheck();
      PlacingActorLogic();
      
    } // mouse click!!

    if (Mouse.isDown(Mouse.LEFT)) {
      if (buttonPlaceCooldown < 0) PlacingActorLogic();
    }

    if (Mouse.onDown(Mouse.RIGHT)) {
      savedMousePosForCamera = new PVector(camera.x + mouseX, camera.y + mouseY);
      actorPlacing = null;
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



    //-----------------------------------Grid Drawing Layer----------------------------------


    //-----------------------------------Character Drawing Layer-----------------------------
    for (Attack p : attacks) {
      p.draw();
    }
    for (BaseGuest guest : guests) {
      guest.draw();
    }


    for (BaseActor actor : actors) {
      actor.draw();
    }


    //-------------------------------------VFX Drawing Layer---------------------------------




    popMatrix(); //No longer Following Camera
    //-------------------------------------UI DRAWING Layer---------------------------------
    //UI Dashboard is drawn here before buttons so the buttons stay visible on the dashboard




    textAlign(LEFT);
    fill (255);
    text(("$"+ floor(currentMoney)), 1000, 30);
    text("Current Wave :" + currWave, 20, 20);
    uiDashboard.draw();
    textDisplay.draw();
    ButtonDraw();


    if (actorPlacing != null) {
      actorPlacing.draw();
    }
    
    pPointG = g;
  }
  
  void PlacingActorLogic() {
    
    if (actorPlacing != null && actorPlacing.purchasedThisFrame == false) {
        if (actorPlacing.purchasedThisFrame == false) {
          Point g = TileHelper.pixelToGrid(new PVector(mouseX, mouseY), new PVector(camera.x, camera.y), zoom);
          Tile tile = level.getTile(g);
          if (tile == null || tile.isPassable() == false) {
          } else {
            level.setTile(g, 2);
            pathfinder.findPath(level.getTile(new Point(0, 0)), level.getTile(new Point(14, 15)));
            if (pathfinder.pathBlocked == false && !(g.x == 0 && g.y == 0)) {
              PVector placingPosition = tile.getCenter();
              PlaceActorSwitch(placingPosition); //Gets the actor being placed and places it
              //End switch case
              currentMoney -= currentPrice; //Spend money on place
              actors = sortObjectsByHeight(); //We use this so walls can be bigger than a tile for faux 3d feels
              
            } else { //the path is blocked!!
              level.setTile(g, 0);
              placeable = false;
            } //end of pathfinding block check
            pathfinder.pathBlocked = false;
          } //end tile is not occupied
        } //end if not purchased this frame
      } //actor placing != null
      
  }
  

  void PlaceActorSwitch(PVector placingPosition) {
    switch(actorPlacing.actor) {
    case MUMMY:
      Mummy mummyToAdd;
      mummyToAdd = new Mummy(int(placingPosition.x), int(placingPosition.y));
      actors.add(mummyToAdd);
      break;

    case CULTIST:

      break;

    case VAMPIRE:

      break;

    case JASON:
      Jason jasonToAdd = new Jason(int(placingPosition.x), int(placingPosition.y));
      actors.add(jasonToAdd);

      break;

    case WITCHDOCTOR:
      WitchDoctor witchDoctorToAdd = new WitchDoctor(int(placingPosition.x), int(placingPosition.y));
      actors.add(witchDoctorToAdd);
      break;

    case WALL:
      PlaceableWall wallToAdd = new PlaceableWall(int(placingPosition.x), int(placingPosition.y));
      actors.add(wallToAdd);
      break;
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
