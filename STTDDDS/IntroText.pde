//This code is for the introduction text box that appears when you launch on main
//basically just a white box that advances text whenever the player clicks

class IntroText {
 String[] lines = {
   "Todays the big day, as long as you can remember you have always wanted to run your own haunted house.",
   "But times are tough for a green startup like yourself, so you had to take some loans to cover the cost.",
   "Little did you know that this loan shark turned out to be the grim reaper! ",
   "He may be cruel, but he is fair, he gave you 10 days to pay back his initial loan of 3,000 dollars...",
   "If you can't pay it back though, your mortal soul is his for eternity...", 
   "Welp, thats neither here nor there though, better hurry and get to work!" 
   
 };
 
 //Tracks current line 
 int currentLine = 0;
 
 //determines if intro is still active and needs to be drawn
 boolean active = true;
 
 //box height
 float boxHeight = 110;
 
 //padding inside box so text doesn't hug the edges
 float padding = 20;
 
 //Y position of the top edge of ther boxc
 float boxY; 
 
 
 //CONSTRUCTOR
 IntroText() {
  //Anchors box to ther bottom of screen here
  boxY = height - boxHeight;
 }
 //activates when player clicks anywhere on the screen. just moves to next line 
 //pretty self explanatory
 void advance() {
   currentLine++;
   if(currentLine >= lines.length) {
    active = false; //when all lines are s hown hid the box 
   }
 }
 
 void draw() {
  if (!active) return;
  
  //background box
  fill(255);
  noStroke();
  rect(0, boxY, width, boxHeight);
  
  //thin top border on box
  stroke(180);
  strokeWeight(2);
  line(0, boxY, width, boxY);
  noStroke();
  
  //daw the current line of dialogue
  fill(20);
  textAlign(LEFT, TOP);
  textSize(18);
  //this wraps the text inside the box using max widsth based on the paddsing
  //the third argument is the max width before wrapping
  text(lines[currentLine], padding, boxY + padding, width - padding * 2, boxHeight - padding);
  
  //click to continue prompt
  fill(150); //grey to not compete with main text
  textAlign(RIGHT, BOTTOM);
  textSize(13);
  text("click to continue", width - padding, boxY + boxHeight - 10);
  
  //reset text alignment so nothing else is affected in the game
  textAlign(LEFT, BASELINE);
  
 }
}
