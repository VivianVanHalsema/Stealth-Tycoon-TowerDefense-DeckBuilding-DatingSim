class MainScreen{
  
  Button titleButton;
  Button dashLockButton;
  BaseActor testActor;
  BaseGuest testGuest;
  Mummy mummyTest;
  ArrayList<Button> buttonsToAttachToDashboard = new ArrayList<Button>();
  
  
  MainScreen(){
    
  //Button Initializations go here!!
  titleButton = new Button(width + 240, 20, 140, 60, "Switch to title",true, true,"SWITCH_TITLE");
  buttons.add(titleButton);
  dashLockButton = new Button(width - 50, 0, 50, 50, "Lock", true, true, "TOGGLE_DASHBOARD_LOCK");
  buttons.add(dashLockButton);
  
  //Scare Actor Initialization goes here!!
  testActor = new BaseActor(400,400);
  actors.add(testActor);
  mummyTest = new Mummy(600,600);
  actors.add(mummyTest);
  
  //Guest Initialization goes here!!
  testGuest = new BaseGuest(400,330);
  guests.add(testGuest);
  
  //DASHBOARD INITIALIZATION
  //----Add buttons that should be attached to the dashboard and move with 
  //----it in here using the buttonsToAttachToDashboard array list like shown below
  buttonsToAttachToDashboard.add(titleButton);
  buttonsToAttachToDashboard.add(dashLockButton);
  
  //------------------------------width, height, visibility, location(tostart), ----------location(toend), -------------------Stored Button Elements
  uiDashboard = new MovingDashboard(500, height, true, new PVector(width - 50, 0), new PVector(width - 450, 0), buttonsToAttachToDashboard);

  
  }
  
  void update() {
    //UI Dashboard updates before buttons for movement and organization
    uiDashboard.update(dt);
    
   ButtonUpdate();
   
   
   for (Projectile p : projectiles) {
      p.update();
   }
      for (int i = projectiles.size() - 1; i >= 0; i--) {
    if (!projectiles.get(i).isAlive) {
      projectiles.remove(i);
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
   //-----------------------------------Background Drawing Layer----------------------------
   
   
   
   //-----------------------------------Grid Drawing Layer----------------------------------
   
   
   //-----------------------------------Character Drawing Layer-----------------------------
     for (Projectile p : projectiles) {
      p.draw();
    }
    for (BaseGuest guest : guests) {
      guest.draw();
    }
    for (BaseActor actor : actors) {
      actor.draw();
    }
    
    
    //-------------------------------------VFX Drawing Layer---------------------------------
    
    
    //-------------------------------------UI DRAWING Layer---------------------------------
    //UI Dashboard is drawn here before buttons so the buttons stay visible on the dashboard
    textAlign(LEFT);
    fill (255);
    text("$MONEY",1000, 30);
    uiDashboard.draw();
   
    ButtonDraw();
    
    
}

}
