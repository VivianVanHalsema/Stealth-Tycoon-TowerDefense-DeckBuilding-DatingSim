class BaseGuest {
  
  PVector position = new PVector();
  float size;
  float scareRange;
  
  
  BaseGuest(int x, int y){
  position.x = x;
  position.y = y;
  
  //default variables
  size = 40;
    

    
  }
  
  void update(){
    
    // this is just debugging I wanted to make sure that actors could track the position of guests
    position.y += 20*dt;
    
    
  }
  
  void draw() {
    fill(100);
    ellipse(position.x,position.y,size, size);
    
    
  } ///truly just a test Guest for detecting by tower, delete it or do whatever you want with it Ry
  
}
