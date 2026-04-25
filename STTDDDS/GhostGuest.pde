
class GhostGuest extends BaseGuest {
  
  float movementDirection;
  float individualFrameMovement;
  
  GhostGuest(int x, int y) {
    super(x, y);
    movementDirection = random(HALF_PI);
    
  }
  
  @Override void update() {
    if (health <= 0 && terrified != true) {
      terrified = true;
      speed *= 2;
      currentMoney += 10;
      onDeath();
  }
    // this is just debugging I wanted to make sure that actors could track the position of guests
    //position.y += speed*dt *slowness;
    
    //if (findPath) findPathAndTakeNextStep();
    //updateMove();
    
    individualFrameMovement = (bpm.easeBounce(8) * movementDirection) + QUARTER_PI;
    
    
    position.y += sin(individualFrameMovement) * 50 * speed * dt * slowness;
    position.x += cos(individualFrameMovement) * 50 * speed * dt * slowness;
    
    if (position.x > 1200 || position.y > 1200) {
      opacity -= 10;
      if (opacity <= 10) {
        ExitScreen();
      }
    }
    
    
    for(Map.Entry<debuffTypes, Float> debuff : currentDebuffs.entrySet()){
     float currentTime = debuff.getValue();
     float newTime = currentTime-dt;
        // Update the timer
        debuff.setValue(newTime);
    }
    for(Map.Entry<Attack,Float> attack : hitAttacks.entrySet()){
     float currentTime = attack.getValue();
     float newTime = currentTime-dt;
        // Update the timer
        attack.setValue(newTime);
    }
    //remove all debuffs with less than 0 timer
    removeDeadDebuffs();
    removeDeadAttacks();
     
    
    
    
    
  }
  
  void draw() {
    super.draw();
    
  }
  
  
  
  
  
}
