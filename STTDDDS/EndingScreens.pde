//This is the tab for ending screen stuffs
//basically will be a black screen that displays different ending text 
//based on how much money you have by the last wave

class EndingScreen {
 //text for good ending
 String[] goodEnding = {
  "You count your money with your Scaractors, counting every last bill until you reach $3,000! ", 
  "He shows up after closing up for the day, clearly at least a little disappointed he didn't get a free soul out of the deal.", 
  "However he seems genuinely happy that things worked out for you, so you can't be too upset at him.", 
  "He tells you to 'come back if your in a tough spot again' and leaves, wishing you luck.", 
  "As the weeks go by work about your amazing haunteds house travels far and wide!", 
  "Many people commenting on the commitment to realism and how authentic the monsters look...", 
  "Thanks to the work of you and your Scaractors, people are coming across the coutnry to see it.", 
  "And despite this, you get the feeling that things are only just beginning for your little haunted house.",
  "GOOD ENDING = CONGRATULATIONS AND THANKS FOR PLAYING!" 
 };
 
 //Text for bad ending 
 String[] badEnding = {
   "As you reach the last day, you realize you won't have enough money to pay back Death.", 
   "And as soon as that thought enters your mind and the last customer is gone, he's there.", 
   "You beg and plead for more time but he isn't hearing it, you had your chance.",
   "His laughter echoes throughout the building, your Scaractors suddenly nowhere to be found.", 
   "You feel your insides are being torn inside out, like something is being dragged out of you...", 
   "Something intangible that shouldn't be removed, something you weren't even aware of before.", 
   "Death then takes your soul and then subjects you to an eternity of eternal torture, clearly delighting in it a little bit.", 
   "Throughout it all you wonder if there was anything you could have done different to avoid this fate...", 
   "Was following your dreams of a haunted house really so foolish and stupid? But such thoughts are pointless now.", 
   "You merely must accept your fate and ponder these questions for all eternity.", 
   "BAD ENDING -ETERNAL TORTURE" 
 };
 
 //the lines actually being shown this run 
 //based on currentMoney
 String[] lines; 
 
 //current line
 int currentLine = 0;
 
 //whether screen is still active, once set to false
 //game resets back to title
 boolean active = true;
 
 //padding inside text box
 float padding = 40;
 
 //height of text box
 float boxHeight = 140;
 
 //CONSTRUCTOR 
 
 EndingScreen() {
  if (currentMoney >= 3000) {
    lines = goodEnding; 
 } else {
   lines = badEnding; 
 }
}

//code for advancing text in the text box
void advance() {
 currentLine++;
 
 if (currentLine >= lines.length) {
  active = false; 
  
  //resets all global game states so a fresh run can start and not haver weird stuff saved over
  resetGame();
  
  //sends player to title
  switchToTitle();
 }
}

//Resets game and clears towers and stuff
void resetGame() {
 //clears enemies, towers, and projectiles from board
 guests.clear();
 actors.clear();
 attacks.clear();
 aoeAttacks.clear();
 
 //rewsets money value for fresh run
 currentMoney = 1000;
 entertainmentValue = 1;
 
 //reset the wave counter so the next run starts at wave 1.
 currWave = 0;
 
 //Re-create wave manager so its internal state is fresh again
 waveManager = new WaveManager();
}

//update that checks for left click 
void update() {
 if (!active) return; 
 
 if (Mouse.onDown(Mouse.LEFT)) {
  advance(); 
 }
}

//drawing text box stuff
  void draw() {
    if (!active) return;

    // Black background covering the entire screen 
    background(0);

    // Which ending label at the top of the screen 
    // Shows "GOOD ENDING" or "BAD ENDING" 
    textAlign(CENTER, TOP);
    textSize(14);
    if (lines == goodEnding) {
      fill(180, 220, 140); // Soft green for good ending
      text("GOOD ENDING", width / 2, 20);
    } else {
      fill(220, 120, 100); // Soft red for bad ending
      text("BAD ENDING", width / 2, 20);
    }

    // Text box at the bottom of the screen
    float boxY = height - boxHeight;

    // White box background
    fill(255);
    noStroke();
    rect(0, boxY, width, boxHeight);

    // Thin top border
    stroke(180);
    strokeWeight(2);
    line(0, boxY, width, boxY);
    noStroke();

    // Current line of ending text
    fill(20);
    textAlign(LEFT, TOP);
    textSize(18);
    text(lines[currentLine], padding, boxY + padding, width - padding * 2, boxHeight - padding);

    // Reset text alignment so nothing bleeds into other screens.
    textAlign(LEFT, BASELINE);
  }
}
