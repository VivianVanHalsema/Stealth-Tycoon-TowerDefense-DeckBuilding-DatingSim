//Additions from other group: Dynamic Characters and UI elements
//Bouncy characters, particle effects

import nl.genart.VJMotion.*;
import nl.genart.VJMotion.arduinocontrols.*;
import nl.genart.VJMotion.frequencyanalyzer.*;
import nl.genart.VJMotion.beatsperminute.*;

import java.util.Map;

  Level level;
  Pathfinder pathfinder;

ArrayList<Button> buttons = new ArrayList<Button>(); 
float dt, prevTime = 0;
TitleScreen titleScreen;
MainScreen mainScreen;
MovingDashboard uiDashboard;
EndingScreen endingScreen;
PlacingActor actorPlacing;
boolean keyEnter = false;
//test comment change
BreakRoom breakRoom;

BeatsPerMinute bpm;

float zoom;
static float defaultZoom = 1;
float targetZoom = defaultZoom;
float maxZoom = 2;
float minZoom = 0.5;

float currentMoney = 1000;
float entertainmentValue = 1;
float currentPrice;
float buttonPlaceCooldown = 0;
boolean placeable;

XML xml;
XML[] wavesxml;
int currWave =0; 
WaveManager waveManager;

XML xml2;
XML[] reviewsxml;
ArrayList<String> oneStarList = new ArrayList<String>();
ArrayList<String> threeStarList = new ArrayList<String>();
ArrayList<String> fiveStarList = new ArrayList<String>();


ArrayList<BaseGuest> guests = new ArrayList<BaseGuest>(); 
ArrayList<BaseActor> actors = new ArrayList<BaseActor>(); 
ArrayList<Attack> attacks = new ArrayList<Attack>();
ArrayList<Attack> aoeAttacks = new ArrayList<Attack>(); //This is to prevent crashing since it doesn't  like it when attacks.add is called  during the main loop is alrady iterating attacks.
ArrayList<Wave> waves = new ArrayList<Wave>();






void setup(){                                          

 size(1280,720, P2D); //CHANGE BACK TO P2D TO DO RY STUFF
 bpm = new BeatsPerMinute(this);
 bpm.setBPM(90);
 bpm.disableKeyPress();
  //REVIEW XML
 xml2 = loadXML("Reviews.xml");
 reviewsxml = xml2.getChildren("reviews");
if (reviewsxml.length > 0) {
    // Get the onestar, threestar, and fivestar children
    XML oneStarReviews = reviewsxml[0].getChild("onestar");
    XML threeStarReviews = reviewsxml[0].getChild("threestar");
    XML fiveStarReviews = reviewsxml[0].getChild("fivestar");
    
    // pasrse one-star reviews
    if (oneStarReviews != null) {
      XML[] oneStarReviewsXML = oneStarReviews.getChildren("review");
      for (int i = 0; i < oneStarReviewsXML.length; i++) {
        String review = oneStarReviewsXML[i].getContent();
        oneStarList.add(review);
      }
    }
    
    // parse three-star reviews
    if (threeStarReviews != null) {
      XML[] threeStarReviewsXML = threeStarReviews.getChildren("review");
      for (int i = 0; i < threeStarReviewsXML.length; i++) {
        String review = threeStarReviewsXML[i].getContent();
        threeStarList.add(review);
      }
    }
    
    // parse five-star reviews
    if (fiveStarReviews != null) {
      XML[] fiveStarReviewsXML = fiveStarReviews.getChildren("review");
      for (int i = 0; i < fiveStarReviewsXML.length; i++) {
        String review = fiveStarReviewsXML[i].getContent();
        fiveStarList.add(review);
      }
    }
}
 ///WAVE XML

 xml = loadXML("Waves.xml");
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
  else if (breakRoom != null) {
   breakRoom.update();
   if(breakRoom != null) breakRoom.draw();
  }
  else if (endingScreen != null) {
   endingScreen.update();
   if (endingScreen != null) endingScreen.draw();
  }
  
  
  Keyboard.update();
  Mouse.update();
}

//--------------------------------CONTROLS---------------------------

void mousePressed(){
  
  Mouse.handleKeyDown(mouseButton);
  //debug
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
          
          if (mainScreen != null && uiDashboard != null) { //added uiDashboard !=null here because without it, clicking any button from
           somethingClicked = true;                        //the title screen crashes bc uiDashboard technically doesn't exist yet, 
           uiDashboard.actorIsFocused = true;              //actor focusing logic still works the same tho, its just ui dashboard junk. 
          } return;
        }
      }
      for (int i = 0; i < actors.size(); i++) {
        BaseActor actor = actors.get(i);//during a wave uiDashboard is always valid so these lines behave the same as before, 
        if(actor.checkClicked()){       //the null check is only if the code somehow ever gets reached outside of mainScreen. so its prolly not important :P
          if(uiDashboard != null)uiDashboard.actorIsFocused = true; //If an actor is clicked, display their info on the dashboard stats tab
          if(uiDashboard != null)uiDashboard.currentFocusedActor = actor;
          somethingClicked = true;
          return;
        }
      }
      if (!somethingClicked && mainScreen != null && uiDashboard != null ){ //pretty much same as before, just here again in case it gets called from a 
      uiDashboard.actorIsFocused = false;                                   //screen without a dahsboard or something. 
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
breakRoom = null;

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

void switchToBreakRoom() {
 switchScreens();
 breakRoom = new BreakRoom();
}

void switchToEnding() {
 switchScreens(); 
 endingScreen = new EndingScreen(); //picks ending based on current money by end of wave 10
}

//DELTATIME
//D...DELTA RUNE??!!
    //Yup, totally the deltarune function
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
