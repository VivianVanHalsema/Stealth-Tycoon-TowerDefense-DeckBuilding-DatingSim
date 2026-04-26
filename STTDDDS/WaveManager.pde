class WaveManager {

  
  //what wave are we on

  int maxWave = 10;
  
  //how long into the wave are we
  int currWaveTime = 0;
  int maxWaveTime =  6000; //60 seconds to spawn the full wave, enemies are split over 3  different times
   Wave currWaveData;
   boolean waveActive = false;
   boolean lateWaveComplete = false;
   boolean lateWaveStarted = false;
   boolean middleWaveStarted = false;
  ArrayList<String> queue = new ArrayList<String>();
  float currQueueTime;
  float queueDelay = 1;
  boolean allWavesComplete = true;
  //wave manager  
  //store waves in a csv 31 total waves
   //each wave stores an id, or which wave it is
   //and there are 3 different spawn times over the course of the wave, one immediately on wave start, on halfway through, and one 5/6~ through
  
  //the csv stores the BASE wave. Then the base is multiplied by the entertainment score
  
  //ENTERTAINMENT VALUE THOUGHT PROCESS
  /*
  I think that maybe I do a modulo process to get hte extra enemies
  Like for example 1.5 gets 1 extra guy fro every 3, then 2 is 1 for every 2, 3 is 1 for 1, and then it gets more.
  THis is some annoying math shit tho so i'll figure it out I guess.
  */
 WaveManager(){
   currWaveData = waves.get(currWave); //starts with wave 1

 }
 
 
 void update(){
   if (waveActive && (currWave <= maxWave)){
   currWaveTime -=gdt; 
   
   //checking when to spawn next queue guest and when to end wave
   if (!queue.isEmpty()){
     currQueueTime -= gdt;
     if (currQueueTime < 0){
       currQueueTime = queueDelay;
       println("Spawning next guest from queue with " + currWaveTime + " left on wave timer");
       spawnGuestAtStart(queue.get(0)); 
       queue.remove(0);
     }//queue timer
   } else{// we also need to check if all enemies are gone/terrified
   //so if the last part of the wave has started AND the queue is empty, we can check the current guest on the board. If there is none or they are all terrified, this wave can reset
   boolean allTerrified = true;
   for (BaseGuest guest : guests) {
      if (guest.terrified == false && guest.isCultist ==false){
       allTerrified = false;
       break;
      }
   }//check if all currently existing guests are terrified
   
    if ((!middleWaveStarted && currWaveTime <= (maxWaveTime/2)) ||(!middleWaveStarted && allTerrified) ){ // we need to check if its time to start the middle wave
   println("middle Wave is Starting at " + currWaveTime);
      nextSetOfGuests("middle");
     middleWaveStarted = true;
   }else if ((!lateWaveStarted && currWaveTime <= ((maxWaveTime/2) - maxWaveTime/4)) || (!lateWaveStarted && allTerrified) ){ // check if its time to start middle of wave
      println("late Wave is Starting at " + currWaveTime);
      nextSetOfGuests("late");
     lateWaveStarted = true;
     
   }else if(lateWaveStarted && allTerrified) {
    println("all guest have been scared! Wave " + currWave + " is complete!");
     resetWave();
     if (mainScreen != null){
       mainScreen.textDisplay.addNewText("Wave " + currWave + " is Complete");
      }
   }
   }
   }else if (currWave >= maxWave){
     allWavesComplete =true;
     
   }
   
   //hmm I have to ponder how to do the queue stuff with diff types guest
 }
  
  
  //triggered by button press, and from there the wave manager is self contained until the next wave needs to start
  void waveStart(){
  waveActive = true;
  currWave ++;
  nextSetOfGuests("early");
  currWaveTime = maxWaveTime;
  queueDelay = 1.1 - ((currWave-1)/(maxWave -1)); // queue time between spawns will decrease as the waves go on
  currWaveData = waves.get(currWave-1);
  println("wave " + currWave + " is starting");
  }
  
  //triggered depending on wave time,, we have 3 types, early who show up when it starts, middle who show up at halfway and late whoshow up near the end
  void nextSetOfGuests(String currentSet) {
  if(currentSet == "early") {
    for(Map.Entry<String, Integer> w : currWaveData.earlyWave.entrySet()) {
     addGuestToQueue(w.getKey());
    }
  }
  else if(currentSet == "middle") {
    for(Map.Entry<String, Integer> w : currWaveData.middleWave.entrySet()) {
      addGuestToQueue(w.getKey());
    }
  }
  else if(currentSet == "late") {
    for(Map.Entry<String, Integer> w : currWaveData.lateWave.entrySet()) {
      addGuestToQueue(w.getKey());
    }
  }
}
  
  void addGuestToQueue(String name, int baseAmount) {
    int totalToSpawn = baseAmount;
    
    if (entertainmentValue > 1.0) {
        // For entertainmentValue of 1.5: spawn 1 extra for every 2 base enemies
        // Formula: extraEnemies = floor(baseAmount * (entertainmentValue - 1.0))

        
        float extraRatio = entertainmentValue - 1.0; // 0.5, 1.0, 2.0, etc.

        int extraGuests= 0;
        
        if (extraRatio <= 0.5) {
            // 1.0 - 1.5:  easier scaling
            extraGuests = floor(baseAmount * extraRatio);
        } 
        else if (extraRatio <= 1.0) {
            // 1.5 - 2.0: medium scaling  
            extraGuests = floor(baseAmount * extraRatio);
        }
        else {
            // 2.0+: aggressive scaling but with diminishing returns so its not like impossible
            extraGuests = floor(baseAmount * (1.0 + log(extraRatio)));
        }
        
        totalToSpawn += extraGuests;
        
 
        if (extraGuests > 2 && mainScreen != null) {
            mainScreen.textDisplay.addNewText("High entertainment attracts " + extraGuests + " even moreGuests!");
        }
    }
    
    for (int i = 0; i < totalToSpawn; i++) {
        queue.add(name);
    }
}
  
 
  
  
  void spawnGuestAtStart(String name){
     int x = level.tiles[0][0].X +(TileHelper.W)/2;
     int y = level.tiles[0][0].Y +(TileHelper.H)/2;
     BaseGuest newGuest;
     switch(name){
       
     case("base"): //sorry this is incosistent with our out case string formatting it is too late (aka im too lazy to fix it)
     newGuest = new BaseGuest(x,y);
     break;
     case("kid"):
     newGuest = new ChildGuest(x,y); ///REPLACE WHEN REAL
     break;
     case("ghost"):
     newGuest = new GhostGuest(x,y);///REPLACE WHEN REAL
     break;
     case("tank"):
     newGuest = new BaseGuest(x,y);///REPLACE WHEN REAL
     break;
     default:
     newGuest = new BaseGuest(x,y); //make base guest if not prev
     break;
     }//end switch case
     guests.add(newGuest);
   }
     
  
  void resetWave(){
    //basically if the last wave just finished, takes player to ending screen
    if (currWave >=maxWave) {
     switchToEnding();
     return; //STOP RUNNING RESET WAVE!!!
    }
 
   mainScreen.waveStartButton.visible = true;
   mainScreen.waveStartButton.clickable = true;
   waveActive = false;
   lateWaveComplete = false;
   lateWaveStarted = false;
   middleWaveStarted = false;
  }
  
  
}


class Wave {
  int id;
  HashMap<String,Integer> earlyWave= new HashMap<String,Integer>();
  HashMap<String,Integer> middleWave= new HashMap<String,Integer>();
  HashMap<String,Integer> lateWave= new HashMap<String,Integer>();
 
  
}
