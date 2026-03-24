class MainScreen{
  
  Button titleButton;
  BaseActor testActor;
  BaseGuest testGuest;
  
  
  MainScreen(){
  titleButton = new Button(20,20, 140, 60, "Switch to title",true, true,"SWITCH_TITLE");
  buttons.add(titleButton);
  testActor = new BaseActor(400,400);
  testGuest = new BaseGuest(400,330);

  
  }
  
  void update() {
    ButtonUpdate();
   testActor.update();
   testGuest.update();
  }
  
 void draw() {
    ButtonDraw();
    testActor.draw();
    testGuest.draw();
  }
  
}  
