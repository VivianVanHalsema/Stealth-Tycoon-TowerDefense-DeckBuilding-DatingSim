class BaseGuest {
  
  PVector position = new PVector();
  int size= 40;
  float scareRange;
  float speed = 20;
  //debuffs, 
  float slowness = 1;
  
  BaseGuest(int x, int y){
  position.x = x;
  position.y = y;
  
  }
  
  void update(){
    
    // this is just debugging I wanted to make sure that actors could track the position of guests
    position.y += speed*dt *slowness;
    
    
  }
  
  void draw() {
    noStroke();
    fill(100);
    ellipse(position.x,position.y,size, size);
    
    
  } ///truly just a test Guest for detecting by tower, delete it or do whatever you want with it Ry
  
}
