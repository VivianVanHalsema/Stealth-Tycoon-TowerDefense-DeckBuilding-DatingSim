//This is the code that creates the break room area

class BreakRoom {
 Button backButton;
 
 //room layouts gonna be smaller than the main level since it doesn't need to be that big.
 //im thinking like 6 x 5 rows and columns
 int tileSize = 64;
 int roomCols = 6;
 int roomRows = 6;
 int roomOffsetX;
 int roomOffsetY;
 
 BreakRoom() {
  //center room on the screen here
  roomOffsetX = (width - roomCols * tileSize) / 2;
  roomOffsetY = (height - roomRows * tileSize) /2 + 20;
  
  backButton = new Button(20, 20, "SWITCH_MAIN");
  buttons.add(backButton);
 }
 
 void update() {
  if (Mouse.onDown(Mouse.LEFT)){
   PrevButtonClickCheck(); 
  }
  ButtonUpdate();
 }

void draw() {
 //dark background cuz spoopy
 background(35, 25,40);
 
 //walls and floor stuff
 drawBreakRoomTiles();
 
 //Room Title
 fill(220, 180, 255);
 textAlign(CENTER);
 textSize(22);
 text(" BREAK ROOM ", width/2, roomOffsetY - 16);
 
 //little flavour text
 fill(160, 140, 180);
 textSize(13);
 text("You decide to send out breaks before the next wave.", width/2, roomOffsetY + roomRows * tileSize + 24);
 
 ButtonDraw();
}

void drawBreakRoomTiles(){
 rectMode(CORNER);
 noStroke();
 
 for(int row = 0; row < roomRows; row++) {
  for (int col = 0; col < roomCols; col++) { 
    float x = roomOffsetX + col * tileSize;
    float y = roomOffsetY + row * tileSize;
    
    boolean isWall = (row == 0 || row == roomRows - 1 ||
                      col == 0 || col == roomCols - 1);
                      
    if (isWall) {
     //some walls
     fill(60, 50, 80);
     rect(x, y, tileSize, tileSize);
     //highlight for depth
     fill(80, 65, 100);
     rect(x + 2, y + 2, tileSize - 4, 6);
     rect(x + 2, y + 2, 6, tileSize - 4);
    } else {
      //floor tiles 
      if((row + col) % 2 == 0) {
        fill(90, 75, 110);
      }else {
       fill(75, 62, 95);
      }
      rect(x, y, tileSize, tileSize);
      
      //tile grout lines
      stroke(50, 40, 65);
      strokeWeight(1);
      noFill();
      rect(x + 1, y + 1, tileSize - 2, tileSize - 2);
      noStroke();
    }
  }
}

//Draw a rug in corner cuz it was in the budget
float rugX = roomOffsetX + tileSize * 2;
float rugY = roomOffsetY + tileSize * 1;
float rugW = tileSize * 4;
float rugH = tileSize * 4;
fill(120, 40, 60, 180);
rect(rugX + 6, rugY + 6, rugW - 12, rugH - 12, 6);
stroke(160, 60, 80, 160);
strokeWeight(3);
noFill();
rect(rugX + 10, rugY + 10, rugW - 20, rugH - 20, 4);
noStroke();

//candles for atmosphere and also kinda spooky
drawCandle(roomOffsetX + tileSize * 2, roomOffsetY + tileSize);
drawCandle(roomOffsetX + tileSize * 5 + 8, roomOffsetY + tileSize);

}

void drawCandle(float x, float y) {
    // Candle body
    fill(230, 220, 200);
    rectMode(CENTER);
    rect(x + tileSize / 2, y + tileSize / 2 + 8, 10, 22, 2);

    // Flame flicker (uses frameCount for a cheap animation)
    float flicker = sin(frameCount * 0.15 + x) * 2;
    fill(255, 220, 80, 220);
    ellipse(x + tileSize / 2 + flicker * 0.4, y + tileSize / 2 - 7, 7, 11);
    fill(255, 160, 40, 160);
    ellipse(x + tileSize / 2 + flicker * 0.2, y + tileSize / 2 - 6, 4, 7);

    rectMode(CORNER);
  }
}
