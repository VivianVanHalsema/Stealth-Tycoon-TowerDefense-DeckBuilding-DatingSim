import java.util.Map;


ArrayList<Button> buttons = new ArrayList<Button>(); 
float dt, prevTime = 0;
TitleScreen titleScreen;
MainScreen mainScreen;
MovingDashboard uiDashboard;
boolean keyEnter = false;

float zoom;
float targetZoom = 1;
float maxZoom = 2;
float minZoom = 0.5;

ArrayList<BaseGuest> guests = new ArrayList<BaseGuest>(); 
ArrayList<BaseActor> actors = new ArrayList<BaseActor>(); 
ArrayList<Attack> attacks = new ArrayList<Attack>();
void setup(){

 size(1280,720); 
 windowTitle("Stealth Tycoon Tower Defense Deck Building Dating Sim");
 switchToTitle();
}


void draw(){
  background(20);
  calcDeltaTime(); 
  
  if(titleScreen != null){
    titleScreen.update();
    if(titleScreen != null) titleScreen.draw(); 
  }
  else if(mainScreen != null){
    mainScreen.update();
    if(mainScreen != null) mainScreen.draw(); 
  }
  
  
  
  Keyboard.update();
  Mouse.update();
}

//--------------------------------CONTROLS---------------------------

void mousePressed(){
  
  Mouse.handleKeyDown(mouseButton);
  //debug
  createNewGuest();
}
void mouseReleased(){
  Mouse.handleKeyUp(mouseButton);
}

void keyPressed(){
  //println(keyCode);
  Keyboard.handleKeyDown(keyCode);
}
void keyReleased(){
  Keyboard.handleKeyUp(keyCode);
}

void mouseWheel(MouseEvent scroll) {
  float e = scroll.getCount(); // e is only -1, 1, or 0, so we convert into something actually usable with zoom
  targetZoom += e * -0.1;
  targetZoom = constrain(targetZoom, minZoom, maxZoom);
} //Thanks you Vivian from one year ago :-)

//BUTTON FUNCTIONS

void PrevButtonClickCheck() { //This is what was in the mousePressed before I made it into a 
                              //input handler. needs to be called in all screens with buttons
      for (int i = 0; i < buttons.size(); i++) {
        Button butt = buttons.get(i);
        if(butt.checkClicked()){
          butt.buttonClicked();
          return;
        }
      }
}

void ButtonUpdate(){
    for (int i = 0; i < buttons.size(); i++) {
    Button butt = buttons.get(i);
    butt.update();  
  }
}

void ButtonDraw(){
    for (int i = 0; i < buttons.size(); i++) {
    Button butt = buttons.get(i);
    if (butt.visible == true){
    butt.draw();  
    }
  }
}

//SCREEN FUNCTIONS

void switchScreens(){
  
titleScreen = null;
mainScreen = null;

for (int i = buttons.size() - 1; i >= 0; i--) {
    buttons.remove(i);
  }
}

void switchToTitle(){
switchScreens();
titleScreen = new TitleScreen();
}

void switchToMain(){
switchScreens();
mainScreen = new MainScreen();
}

//DELTATIME
void calcDeltaTime() {
  float currTime = millis();
  dt = (currTime - prevTime) / 1000.0;
  prevTime = currTime;
}
//HELPER FUNCTIONS

boolean pointInRadius(float x,float y,float cx, float cy, float r){
  float dis = dist(x,y,cx,cy);
  if (dis <=r){return true;}
  return false;
}

boolean pointOnLine(float x1, float y1, float x2, float y2, float px, float py){
  
  float dis1 = dist(px,py, x1,y1);
  float dis2 = dist(px,py, x2,y2);
  
  float len = dist(x1,y1,x2,y2);
  //this makes the point line collision slightly less accurate, but I think that feels a little better
  float buffer =.2;
  
  if (dis1+dis2 >= len-buffer && dis1+dis2 <= len+ buffer){ return true;}
  return false;
}


//MISC FUNCTIONS

void createNewGuest(){
  BaseGuest newGuest = new BaseGuest(mouseX,mouseY);
  guests.add(newGuest);
  
}

void toggleDashboardLock() {
  if (uiDashboard != null) {
    if (uiDashboard.isLocked) {
      uiDashboard.isLocked = false;
    } else {
      uiDashboard.isLocked = true;
    }
    //uiDashboard.a = round(uiDashboard.a);// does NOT work figure out why later
  }
}
