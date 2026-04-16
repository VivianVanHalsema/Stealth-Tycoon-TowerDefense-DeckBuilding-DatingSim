class MainScreen{
  
  
  Camera camera;
  
  PVector savedMousePosForCamera;
  
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
  
  
  BaseGuest testGuest;
  Mummy mummyTest;
  Cultist cultistTest;
  //MoneySystem moneySystem;
  ArrayList<Button> buttonsToAttachToDashboard = new ArrayList<Button>();
  
  
  MainScreen(){
    
  //Pathfinding Initialization
  TileHelper.app = new STTDDDS();
  level = new Level();
  pathfinder = new Pathfinder();
    
  camera = new Camera();
    
  //Button Initializations go here!!
  titleButton = new Button(width + 240, 20,"SWITCH_TITLE");
  buttons.add(titleButton);
  dashLockButton = new Button(width - 50, 0, "TOGGLE_DASHBOARD_LOCK");
  buttons.add(dashLockButton);
  waveStartButton = new Button(20, 40, "WAVE_START");
  buttons.add(waveStartButton);
  breakRoomButton = new Button(20, 80, "SWITCH_TO_BREAKROOM");
  buttons.add(breakRoomButton);
  
  
  //Tab buttons initializations go here!!!!
  hireButton = new TabButton(width-40, (height/8*1),"SWITCH_TABS", dashboardTabs.HIRE);
  buttons.add(hireButton);
  upgradeButton = new TabButton(width-40,(height/8*3),"SWITCH_TABS", dashboardTabs.UPGRADE);
  buttons.add(upgradeButton);
  statsButton = new TabButton(width-40, (height/8*5),"SWITCH_TABS", dashboardTabs.STATS);
  buttons.add(statsButton);
  settingsButton = new TabButton(width-40, (height/8*7),"SWITCH_TABS", dashboardTabs.SETTINGS);
  buttons.add(settingsButton);
  
  //Dashboard button initializations go here!!!!
 // moneySystem = new MoneySystem();
  mummyButton = new ShopButton(width+50, 100,"GET_TOWER", dashboardTabs.HIRE, actorTypes.MUMMY);
  buttons.add(mummyButton);
  
  jasonButton = new ShopButton(width+50, 180, "GET_TOWER", dashboardTabs.HIRE, actorTypes.JASON);
  buttons.add(jasonButton);
  
  witchyButton = new ShopButton(width+50, 260, "GET_TOWER", dashboardTabs.HIRE, actorTypes.WITCHDOCTOR);
  buttons.add(witchyButton);
  
  
  //DASHBOARD INITIALIZATION
  //----Add buttons that should be attached to the dashboard and move with 
  //----it in here using the buttonsToAttachToDashboard array list like shown below
  buttonsToAttachToDashboard.add(titleButton);
  buttonsToAttachToDashboard.add(dashLockButton);
  buttonsToAttachToDashboard.add(mummyButton);
  buttonsToAttachToDashboard.add(jasonButton);
  buttonsToAttachToDashboard.add(witchyButton);
  buttonsToAttachToDashboard.add(hireButton);
  buttonsToAttachToDashboard.add(upgradeButton);
  buttonsToAttachToDashboard.add(statsButton);
  buttonsToAttachToDashboard.add(settingsButton);
  //------------------------------, location(tostart), ----------location(toend), -------------------Stored Button Elements
  uiDashboard = new MovingDashboard( new PVector(width - 50, 0), new PVector(width - 450, 0), buttonsToAttachToDashboard);

  
  }
  
  void update() {
    
    if (Mouse.onDown(Mouse.LEFT)) {
      PrevButtonClickCheck();
      
      if (actorPlacing != null) {
        if (actorPlacing.purchasedThisFrame == false) {
          Point g = TileHelper.pixelToGrid(new PVector(mouseX, mouseY), new PVector(camera.x, camera.y), zoom);
          Tile tile = level.getTile(g);
          PVector placingPosition = tile.getCenter();
          
          
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
            
            
            
            
            
          } //End switch case
          actorPlacing = null;
        } //end if not purchased this frame
      } //actor placing != null
    } // mouse click!!
    
    if(Mouse.onDown(Mouse.RIGHT)) {
      savedMousePosForCamera = new PVector(camera.x + mouseX, camera.y + mouseY);
    }
    
    if (Mouse.isDown(Mouse.RIGHT)) {
      camera.x = savedMousePosForCamera.x - mouseX;
      camera.y = savedMousePosForCamera.y - mouseY;
      
      if (camera.x < 0) camera.x = 0;
      if (camera.x > 320) camera.x = 320;
      if (camera.y < 0) camera.y = 0;
      if (camera.y > 880) camera.y = 880;
      
      camera.tx = camera.x;
      camera.ty = camera.y;
    }
    
    camera.update();
    //UI Dashboard updates before buttons for movement and organization
    uiDashboard.update();
    waveManager.update();
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
    for (BaseGuest guest : guests) {
      guest.update();
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
   background(TileHelper.isHex ? 0 : 127);
   level.draw();
   
   Point g = TileHelper.pixelToGrid(new PVector(mouseX, mouseY), new PVector(camera.x, camera.y), zoom);
   Tile tile = level.getTile(g);
   if (tile != null) { //This is for safety to avoid null pointers with camera stuffs
     tile.hover = true;
     PVector m = tile.getCenter();
     fill(0);
     ellipse(m.x, m.y, 5, 5);
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
    text(("$"+ floor(currentMoney)),1000, 30);
    text("Current Wave :" + currWave, 20,20);
    uiDashboard.draw();
     
    ButtonDraw();
    
    
    if (actorPlacing != null) {
      actorPlacing.draw();
    }
    
}

}
