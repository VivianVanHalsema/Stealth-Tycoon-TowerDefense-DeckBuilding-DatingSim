class WaveManager {

  
  //what wave are we on
  int currWave =1;
  int maxWave = 31;
  
  //how long into the wave are we
  int currWaveTime = 0;
  int maxWaveTime =  60; //60 seconds to spawn the 
 
  
  //wave manager  
  //store waves in a csv 31 total waves
   //each wave stores an id, or which wave it is
   //and there are 3 different spawn times over the course of the wave, one immediately on wave start, on halfway through, and one 5/6~ through
  
  //the csv stores the BASE wave. Then the base is multiplied by the entertainment score
  
  
  
  
 WaveManager(){

 }
  
  
  //triggered by button press, and from there the wave manager is self contained until the next wave needs to start
  void waveStart(){
    
  nextSetOfGuests("early");
  
    
    
    
  }
  
  //triggered depending on wave time,, we have 3 types, early who show up when it starts, middle who show up at halfway and late whoshow up near the end
  void nextSetOfGuests (String currentSet ) {
   
   
    
    
    
  }
  
  
  
  void resetWave(){
    
    
    
    currWave ++;
  }
  
  
}


class wave {
  int id;
  HashMap<BaseActor,Integer> earlyWave= new HashMap<BaseActor,Integer>();
  HashMap<BaseActor,Integer> middleWave= new HashMap<BaseActor,Integer>();
  HashMap<BaseActor,Integer> lateWave= new HashMap<BaseActor,Integer>();
  w
  
  
  
  
  
}
