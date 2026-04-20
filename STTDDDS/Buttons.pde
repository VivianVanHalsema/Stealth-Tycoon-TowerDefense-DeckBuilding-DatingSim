public class Button {
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
    
    case "SWITCH_TO_BREAKROOM":
    text = "Break Room";
    size.x = 140;
    size.y = 60;
    break;
    
    case "WAVE_START":
    text = "Start Next Wave";
    size.x = 160;
    size.y = 30;
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
println (clickAction);
  switch(clickAction) {
    
    case "SWITCH_MAIN":
    switchToMain();
    break;
    
    case "SWITCH_TITLE":
    switchToTitle();
    break;
    
    case "SWITCH_TO_BREAKROOM":
    switchToBreakRoom();
    break;
    
    case "TOGGLE_DASHBOARD_LOCK":
    toggleDashboardLock();
    break;
    case "GET_TOWER":
    println("soTrue!");
    break;
    case "SWITCH_TABS":
    println("soTrue!");
    break;
    case "WAVE_START":
    waveManager.waveStart();
    this.visible = false;
    this.clickable = false;
    break;
   }
  }
}


class ShopButton extends DashBoardButton {
  int price; 
  actorTypes actor;
  
  ShopButton(int x, int y, String clickAction, dashboardTabs tab, actorTypes scaractor) {
   super(x,y, clickAction, tab); 
    
    switch(scaractor) {
      case MUMMY:
      text = "Mummy";
      price = 10;
      break;
      case CULTIST:
      text = "Cultist";
      price = 20;
      break;
      case VAMPIRE:
      text = "Vampire";
      price = 50;
      break;
      case JASON:
      text = "Jason";
      price = 50;
      break;
      case WITCHDOCTOR:
      text = "Witch Doctor";
      price = 20;
      break;
      case WALL:
      text = "Wall";
      price = 5;
      
    }
    actor = scaractor;
    size.x=80;
    size.y=60;
 
   
  }
  
  void update () {
    super.update();
    if (currentMoney < price && actorPlacing == null){
     clickable = false; 
    } else clickable = true;
    
  }
  
  
  @Override void draw () {
    if (actorPlacing == null) {
      super.draw(); 
    } else {
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
     text("Undo",position.x +size.x/2,position.y+size.y/2+5);  
    
    }
  }
  
  void buttonClicked() {
    if (actorPlacing == null) {
      currentMoney -= price; //Spend Money on click
      actorPlacing = new PlacingActor(actor, true);
    
    } else if (actorPlacing != null && actorPlacing.purchasing == true) {
      currentMoney += price; //cancel purchase, regain the money spent
      actorPlacing = null;
    }
  } //ButtonClick End
  
  
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

    //owner.currentTab = thisTab;    //I am getting a null pointer when I click on the Mummy Button
  }

  
}
