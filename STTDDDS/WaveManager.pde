class WaveManager {

  
  //what wave are we on

  int maxWave = 31;
  
  //how long into the wave are we
  int currWaveTime = 0;
  int maxWaveTime =  60; //60 seconds to spawn the full wave, enemies are split over 3  different times
   Wave currWaveData;
  
  
  //wave manager  
  //store waves in a csv 31 total waves
   //each wave stores an id, or which wave it is
   //and there are 3 different spawn times over the course of the wave, one immediately on wave start, on halfway through, and one 5/6~ through
  
  //the csv stores the BASE wave. Then the base is multiplied by the entertainment score
  
  
 WaveManager(){
   currWaveData = waves.get(currWave); //starts with wave 1
 }
 
 
 void update(){
   currWaveTime --; 
 
 }
  
  
  //triggered by button press, and from there the wave manager is self contained until the next wave needs to start
  void waveStart(){
  currWave ++;
  nextSetOfGuests("early");
  currWaveTime = maxWaveTime;
  currWaveData = waves.get(currWave-1);
  }
  
  //triggered depending on wave time,, we have 3 types, early who show up when it starts, middle who show up at halfway and late whoshow up near the end
  void nextSetOfGuests(String currentSet) {
  if(currentSet == "early") {
    for(Map.Entry<String, Integer> w : currWaveData.earlyWave.entrySet()) {
      //spawnGuestAtStart(w.getKey()); 
    }
  }
  else if(currentSet == "middle") {
    for(Map.Entry<String, Integer> w : currWaveData.middleWave.entrySet()) {
      //spawnGuestAtStart(w.getKey());
    }
  }
  else if(currentSet == "late") {
    for(Map.Entry<String, Integer> w : currWaveData.lateWave.entrySet()) {
      //spawnGuestAtStart(w.getKey());
    }
  }
}
  
  void spawnGuestAtStart(String guestType){
     int x = level.tiles[0][0].X +(TileHelper.W)/2;
     int y = level.tiles[0][0].Y +(TileHelper.H)/2;
     BaseGuest newGuest = new BaseGuest(x,y);
     guests.add(newGuest);
   }
     
  
  void resetWave(){
    
    
    
    currWave ++;
  }
  
  
}


class Wave {
  int id;
  HashMap<String,Integer> earlyWave= new HashMap<String,Integer>();
  HashMap<String,Integer> middleWave= new HashMap<String,Integer>();
  HashMap<String,Integer> lateWave= new HashMap<String,Integer>();
 
  
}
