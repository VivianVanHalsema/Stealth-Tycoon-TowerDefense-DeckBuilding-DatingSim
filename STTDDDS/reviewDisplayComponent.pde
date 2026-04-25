class TextDisplayComponent {
  
  int x, y;
  ArrayList<DisplayedText> displayedText = new ArrayList<DisplayedText>();
  
  TextDisplayComponent(int x,int y){
  this.x = x;
  this.y = y;
  
  }
  
  void update(){
    
    for (int i = displayedText.size() - 1; i >= 0; i--) {
      DisplayedText dt = displayedText.get(i);
      dt.update();

      if (dt.lifetime <= 0) {
         displayedText.remove(i);
       }
    
    }
    
    
  }
  
 void draw() {
  int textOffset = 0;
  for (DisplayedText line : displayedText) {
    pushStyle();
    
    textSize(18);
    textAlign(LEFT, TOP);
    noStroke();
    
    //drawing the highlight
    float tw = (textWidth(line.text)*2)+10;

    fill(0,0,0,150);
    rect(x,y+textOffset,tw,30);
    
    // Draw main text
    noStroke();
    fill(200, 0,0, line.visibility);
    text(line.text, x, y + textOffset-5);
    
    popStyle();
    textOffset -= 30;
    if (textOffset >=150){ break;}
  }
}
  
  
  void addNewText(String text){    
    displayedText.add(new DisplayedText(text));
  }
  

  
}

class DisplayedText {
  String text;
  float lifetime;
  float maxLifetime = 4;
  float maxLifetimeVisibility = maxLifetime/4; // once the lifetime reaches this point, it will fade out
  float visibility = 255;
  boolean isReview;
  DisplayedText(String text) {
    this.text = text;
    this.lifetime = maxLifetime;
  }
  
  void update(){
    lifetime -=dt;
    if (lifetime <= maxLifetimeVisibility){
     visibility = map(lifetime, 0, maxLifetimeVisibility, 0, 255);
      visibility = constrain(visibility, 0, 255);
    }    
    
  }
  
}
