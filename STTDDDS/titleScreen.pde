class TitleScreen{
  
  Button mainButton;
  PImage titleCard;
  
  TitleScreen(){
  mainButton =  new Button(width/2-75, height/2+150, "SWITCH_MAIN");
  buttons.add(mainButton);
  imageMode(CENTER);
  titleCard = loadImage("sprites/havoc.png");
  titleCard.resize(500,400);
  }
  
  
  void update() {
    
    if (Mouse.onDown(Mouse.LEFT)) {
      PrevButtonClickCheck();
    }
    
    ButtonUpdate();
    }
  

  void draw() {
    gradientBackground(0,0,width,height, color(20,20,20),color(255,0,0));
    ButtonDraw();
    image(titleCard,width/2, 300);
  }
  
  void gradientBackground(int x, int y, float w, float h, color c1, color c2){
  noFill();
 for (int i = y; i <= h; i++){
  float inter = map(i, y, y+h, 0, 1);
  color c = lerpColor(c1,c2,inter);
  stroke(c);
  line(x, i, x+w, i);
 }
  }
  
}  
