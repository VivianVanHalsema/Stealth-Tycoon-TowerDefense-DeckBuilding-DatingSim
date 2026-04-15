import java.util.Map;

  Level level;
  Pathfinder pathfinder;

ArrayList<Button> buttons = new ArrayList<Button>(); 
float dt, prevTime = 0;
TitleScreen titleScreen;
MainScreen mainScreen;
MovingDashboard uiDashboard;
PlacingActor actorPlacing;
boolean keyEnter = false;

float zoom;
static float defaultZoom = 1;
float targetZoom = defaultZoom;
float maxZoom = 2;
float minZoom = 0.5;

XML xml;
XML[] wavesxml;
int currWave =0; 
WaveManager waveManager;
float currentMoney = 100;

ArrayList<BaseGuest> guests = new ArrayList<BaseGuest>(); 
ArrayList<BaseActor> actors = new ArrayList<BaseActor>(); 
ArrayList<Attack> attacks = new ArrayList<Attack>();
ArrayList<Wave> waves = new ArrayList<Wave>();


void setup(){

 size(1280,720); 
 
 xml = loadXML("Waves.xml"); //unfortunately it seems this MUST happen in setup
 wavesxml = xml.getChildren("wave");
 
  for (int i = 0; i < wavesxml.length; i++) {//iterate through waves
    Wave thisWave = new Wave();
    
    // Get the wave ID
    thisWave.id = wavesxml[i].getInt("id");
    
    // Parse EARLY wave data
    XML early = wavesxml[i].getChild("early");
    if (early != null) {
      thisWave.earlyWave.put("base", early.getInt("base"));
      thisWave.earlyWave.put("ghost", early.getInt("ghost"));
      thisWave.earlyWave.put("kid", early.getInt("kid"));
      thisWave.earlyWave.put("tank", early.getInt("tank"));
    }
    
    // Parse MIDDLE wave data
    XML middle = wavesxml[i].getChild("middle");
    if (middle != null) {
      thisWave.middleWave.put("base", middle.getInt("base"));
      thisWave.middleWave.put("ghost", middle.getInt("ghost"));
      thisWave.middleWave.put("kid", middle.getInt("kid"));
      thisWave.middleWave.put("tank", middle.getInt("tank"));
    }
    
    // Parse LATE wave data
    XML late = wavesxml[i].getChild("late");
    if (late != null) {
      thisWave.lateWave.put("base", late.getInt("base"));
      thisWave.lateWave.put("ghost", late.getInt("ghost"));
      thisWave.lateWave.put("kid", late.getInt("kid"));
      thisWave.lateWave.put("tank", late.getInt("tank"));
    }
    
    waves.add(thisWave);
  }// i hate that we need to have this big fat paragraph in setup but I don't think we have anyway around it unless im missing something very obvious
   waveManager = new WaveManager();
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
  //float e = scroll.getCount(); // e is only -1, 1, or 0, so we convert into something actually usable with zoom
  //targetZoom += e * -0.1;
  //targetZoom = constrain(targetZoom, minZoom, maxZoom);
} //Thanks you Vivian from one year ago :-)

//BUTTON FUNCTIONS

void PrevButtonClickCheck() { //This is what was in the mousePressed before I made it into a 
       boolean somethingClicked = false;      //input handler. needs to be called in all screens with buttons
      for (int i = 0; i < buttons.size(); i++) {
        Button butt = buttons.get(i);
        if(butt.checkClicked()){
          butt.buttonClicked();
          if (mainScreen != null){
          somethingClicked = true;
          uiDashboard.actorIsFocused = true;
          } return;
        }
      }
      for (int i = 0; i < actors.size(); i++) {
        BaseActor actor = actors.get(i);
        if(actor.checkClicked()){
          uiDashboard.actorIsFocused = true; //If an actor is clicked, display their info on the dashboard stats tab
          uiDashboard.currentFocusedActor = actor;
          somethingClicked = true;
          return;
        }
      }
      if (!somethingClicked && mainScreen != null ){ 
      uiDashboard.actorIsFocused = false;
      uiDashboard.currentFocusedActor = null;}
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
