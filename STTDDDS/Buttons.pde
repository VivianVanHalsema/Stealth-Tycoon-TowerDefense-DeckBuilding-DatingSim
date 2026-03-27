public class Button{
  PVector position = new PVector();
  PVector size = new PVector();
  String text;
  boolean clickable;
  boolean visible;
  boolean isHovered;
  String clickAction;
  

  public Button(int x, int y, String clickAction){
   position.x = x; 
   position.y = y; 
   this.clickable = true;
   this.visible = true;
   this.clickAction = clickAction;
   switch(clickAction) {
    
    case "SWITCH_MAIN":
    text = "Go to main";
    size.x=140;
    size.y=60;
    break;
    
    case "SWITCH_TITLE":
    text = "Go to title";
    size.x=140;
    size.y=60;
    break;
    
    case "TOGGLE_DASHBOARD_LOCK":
    text = "lock";
    size.x=60;
    size.y=60;
    break;
    
    case "DASHBOARD":
    text = "";
    size.x=500;
    size.y=height;
    break;
   }
  }
  
  public void update(){
      isHovered = checkHovered();
  }
  
  public void draw(){
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
    
    case "TOGGLE_DASHBOARD_LOCK":
    toggleDashboardLock();
    break;
    
    case "GET_TOWER"://
    //moneySystem.buyTower(actor);
    break;
    case "SWITCH_TABS":
    
    break;
   }
  }
}


class ShopButton extends DashBoardButton {
  int price; 
  actorTypes actor;
  
  ShopButton(int x, int y, String clickAction, dashboardTabs tab) {
   super(x,y, clickAction, tab); 
    switch(clickAction) {
    
    case "GET_TOWER":
    
    text = "Mummy";
    actor = actorTypes.MUMMY;
    price = 100;
    size.x=80;
    size.y=60;
    break;
    
    }
  }
  
  void update () {
    super.update();
    if (currentMoney < price){
     clickable = false; 
    } else clickable = true;}
  
  
  void draw () {
   super.draw(); 
    
  }
  
  
  
}

class TabButton extends Button {
  
dashboardTabs thisTab; 
MovingDashboard owner;
  
  TabButton(int x, int y, String clickAction, dashboardTabs tab) {
   super(x,y, clickAction); 
    thisTab = tab;
    owner = uiDashboard;
    text = "";
    size.x = 60;
    size.y = 80;
    
  }
  
  void update () {
    super.update();
    if (owner == null){
     owner = uiDashboard;
    }
 
  }
  
  
  void draw () {
   super.draw(); 
    
  }
  
  void buttonClicked(){

    owner.currentTab = thisTab;    
  }

  
}

class DashBoardButton extends Button {
  
dashboardTabs thisTab; 
MovingDashboard owner;
  
  DashBoardButton(int x, int y, String clickAction, dashboardTabs tab) {
   super(x,y, clickAction); 
    thisTab = tab;
    text = "";
    size.x = 40;
    size.y = 80;
    
  }
  
  void update () {
    super.update();
 
  }
  
  
  void draw () {
   super.draw(); 
    
  }
  
  void buttonClicked(){

    owner.currentTab = thisTab;    
  }

  
}
