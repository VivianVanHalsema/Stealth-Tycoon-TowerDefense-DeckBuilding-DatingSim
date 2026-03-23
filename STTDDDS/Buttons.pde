class Button{
  PVector position = new PVector();
  PVector size = new PVector();
  String text;
  boolean clickable;
  boolean visible;
  boolean isHovered;
  String clickAction;
  

  Button(int x, int y, int w, int h, String text, boolean clickable, boolean visible, String clickAction){
   position.x = x; 
   position.y = y; 
   size.x = w;
   size.y = h;
   this.text = text;
   this.clickable = clickable;
   this.visible = visible;
   this.clickAction = clickAction;
  }
  
  void update(float dt){
      isHovered = checkHovered();
  }
  
  void draw(){
    noStroke();
    rectMode(CORNER);
    textAlign(CENTER);
   
    if (isHovered == true){ 
      fill(255);
      rect(position.x-3,position.y-3,size.x+6,size.y+6, 8);
    }
    if (clickable == false) {fill(80); }
    else fill(200);
   rect(position.x,position.y,size.x,size.y,8);
   fill(10);
   textSize(20);
   text(text,position.x +size.x/2,position.y+size.y/2+5);  
     
}

 boolean checkClicked(){
   if (clickable == true){
  return mouseX > position.x && 
         mouseX < position.x + size.x && 
         mouseY > position.y && 
         mouseY < position.y + size.y;}
   else return false;
 }

boolean checkHovered(){
  return mouseX > position.x && 
         mouseX < position.x + size.x && 
         mouseY > position.y && 
         mouseY < position.y + size.y;
}




void buttonClicked(){

  switch(clickAction) {
    
    case "SWITCH_MAIN":
    switchToMain();
    break;
    
    case "SWITCH_TITLE":
    switchToTitle();
    break;
    }
   }
}
