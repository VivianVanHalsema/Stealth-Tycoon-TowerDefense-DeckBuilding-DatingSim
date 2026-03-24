class BaseActor {
  ArrayList<BaseGuest> guestsInRange = new ArrayList<BaseGuest>(); 
  PVector position = new PVector();
  PVector size = new PVector();
  float scareRange;
  String attackType;
  
  
  BaseActor(int x, int y){
    
  //input variables
  position.x = x;
  position.y = y;
  //default variables
  size.x = 40;
  size.y = 40;
  //child variables
  scareRange = 160;
  
    
  }
  
  void update(){
    getAllInRange();
    
    
  }
  
  void draw() {
    rectMode(CENTER);
    //draw attack range
    fill(255,20);
    ellipse(position.x,position.y, scareRange,scareRange);
    //draw Actor itself, will be a image in future
    fill(255);
    rect(position.x,position.y,size.x,size.y);
    
  }
  //get every Guest in scareRange
 void getAllInRange(){
  guestsInRange.clear();
  for (BaseGuest Guest: enemies) {
    float dis = dist(Guest.position.x, Guest.position.y, this.position.x, this.position.y);
    if(dis < scareRange + Guest.size){
       guestsInRange.add(Guest);
    }
  }
 }
 
 //make sure to update first or call get all in range for an accurate array of enemies in range
 BaseGuest getClosestInRange(){
  float closestDistance = 1000000;
  BaseGuest closestGuest = guestsInRange.get(0);
 for (BaseGuest Guest:guestsInRange){
    float dis = dist(Guest.position.x, Guest.position.y, this.position.x, this.position.y);
    if (dis < closestDistance) {
      closestDistance = dis;
      closestGuest = Guest;
}
    }
    return closestGuest;
 }

  
  
}
