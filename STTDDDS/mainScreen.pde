class MainScreen{
  
  Button titleButton;
  Button dashLockButton;
  ShopButton mummyButton;
  
  
  BaseGuest testGuest;
  Mummy mummyTest;
  Cultist cultistTest;
  //MoneySystem moneySystem;
  ArrayList<Button> buttonsToAttachToDashboard = new ArrayList<Button>();
  
  
  MainScreen(){
    
  //Button Initializations go here!!
  titleButton = new Button(width + 240, 20,"SWITCH_TITLE");
  buttons.add(titleButton);
  dashLockButton = new Button(width - 50, 0, "TOGGLE_DASHBOARD_LOCK");
  buttons.add(dashLockButton);
  
  //Shop Button initializations go here!!!!
 // moneySystem = new MoneySystem();
  mummyButton = new ShopButton(width+50, 100,"GET_TOWER");
  buttons.add(mummyButton);
  
  //Scare Actor Initialization goes here!!
  cultistTest = new Cultist(400,400);
  actors.add(cultistTest);
  mummyTest = new Mummy(600,300);
  actors.add(mummyTest);
  
  //Guest Initialization goes here!!
  testGuest = new BaseGuest(400,330);
  guests.add(testGuest);
  
  //DASHBOARD INITIALIZATION
  //----Add buttons that should be attached to the dashboard and move with 
  //----it in here using the buttonsToAttachToDashboard array list like shown below
  buttonsToAttachToDashboard.add(titleButton);
  buttonsToAttachToDashboard.add(dashLockButton);
  buttonsToAttachToDashboard.add(mummyButton);
  
  //------------------------------, location(tostart), ----------location(toend), -------------------Stored Button Elements
  uiDashboard = new MovingDashboard( new PVector(width - 50, 0), new PVector(width - 450, 0), buttonsToAttachToDashboard);

  
  }
  
  void update() {
    //UI Dashboard updates before buttons for movement and organization
    uiDashboard.update();
    
   ButtonUpdate();
   
   
   for (Attack p : attacks) {
      p.update();
   }
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
   //-----------------------------------Background Drawing Layer----------------------------
   
   
   
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
    
    
    //-------------------------------------UI DRAWING Layer---------------------------------
    //UI Dashboard is drawn here before buttons so the buttons stay visible on the dashboard
    textAlign(LEFT);
    fill (255);
    text(("$"+ floor(currentMoney)),1000, 30);
    uiDashboard.draw();
   
    ButtonDraw();
    
    
}

}
