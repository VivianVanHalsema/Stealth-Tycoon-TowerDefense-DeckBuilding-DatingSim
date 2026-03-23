class MainScreen{
  
  Button titleButton;
  
  
  MainScreen(){
  titleButton = new Button(20,20, 140, 60, "Switch to title",true, true,"SWITCH_TITLE");
  buttons.add(titleButton);
    

  
  }
  
  void update() {
    ButtonUpdate();
  }
  
 void draw() {
    ButtonDraw();
  }
  
}  
