class MainScreen{
  
  Button titleButton;
  BaseActor testActor;
  BaseGuest testGuest;
  Mummy mummyTest;
  MovingDashboard uiDashboard;
  ArrayList<Button> buttonsToAttachToDashboard = new ArrayList<Button>();
  
  
  MainScreen(){
  titleButton = new Button(width + 240, 20, 140, 60, "Switch to title",true, true,"SWITCH_TITLE");
  buttons.add(titleButton);
  testActor = new BaseActor(400,400);
  actors.add(testActor);
  mummyTest = new Mummy(600,600);
  actors.add(mummyTest);
  testGuest = new BaseGuest(400,330);
  guests.add(testGuest);
  
  buttonsToAttachToDashboard.add(titleButton);
  //------------------------------width, height, visibility, location(tostart), ----------location(toend), -------------------Stored Button Elements
  uiDashboard = new MovingDashboard(500, height, true, new PVector(width - 50, 0), new PVector(width - 450, 0), buttonsToAttachToDashboard);

  
  }
  
  void update() {
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
    uiDashboard.draw();
   
    ButtonDraw();
     for (Projectile p : projectiles) {
      p.draw();
    }
    for (BaseGuest guest : guests) {
      guest.draw();
    }
    for (BaseActor actor : actors) {
      actor.draw();
    }
}

}
