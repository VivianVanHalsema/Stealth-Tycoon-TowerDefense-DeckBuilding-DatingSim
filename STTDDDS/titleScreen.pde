class TitleScreen{
  
  Button mainButton;
  
  
  TitleScreen(){
  mainButton =  new Button(width/2-100, height/2-100, "SWITCH_MAIN");
  buttons.add(mainButton);

  }
  
  
  void update() {
    ButtonUpdate();
    }
  

  void draw() {
    ButtonDraw();
  }
  
}  
