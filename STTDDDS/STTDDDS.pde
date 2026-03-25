
ArrayList<Button> buttons = new ArrayList<Button>(); 
float dt, prevTime = 0;
TitleScreen titleScreen;
MainScreen mainScreen;

ArrayList<BaseGuest> guests = new ArrayList<BaseGuest>(); 
ArrayList<BaseActor> actors = new ArrayList<BaseActor>(); 
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
void setup(){

 size(1920,1080); 
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
  
  
}

//MOUSE FUNCTIONS (we can change these to a proper input handler later if we'd like)

void mousePressed(){

  for (int i = 0; i < buttons.size(); i++) {
    Button butt = buttons.get(i);
    if(butt.checkClicked()){
      butt.buttonClicked();
      return;
    }
  }
  //debug
  createNewGuest();
}



void mouseReleased(){

  
}

//BUTTON FUNCTIONS

void ButtonUpdate(){
    for (int i = 0; i < buttons.size(); i++) {
    Button butt = buttons.get(i);
    butt.update(dt);  
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

boolean pointInRadius(float x,float y,float circleX, float circleY, int r){
  float distX = x-circleX;
  float distY = y-circleY;
  float dis = lineLength(distX,distY);
  if (dis <=r){return true;}
  return false;
}

float lineLength(float x, float y){
return sqrt((x*x)+(y*y));
}
//MISC FUNCTIONS

void createNewGuest(){
  println("creating new guest");
  BaseGuest newGuest = new BaseGuest(mouseX,mouseY);
  guests.add(newGuest);
  
}
