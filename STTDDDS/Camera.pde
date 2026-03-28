class Camera {
 
float x, y;
float tx, ty; // Target's x and y coordinates.
float dx, dy;
  
  
  Camera() {
    tx = 0;
    ty = 0;
    x = tx;
    y = ty;
  }
  
  void update() {
    
    //Set tx and ty to change camera location
    
    // For Camera Easing Effect
    dx = tx - x;
    dy = ty - y;   
    x += dx * 0.05;
    y += dy * 0.05;
    
  }
  
}
