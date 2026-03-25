class MovingDashboard extends Button {
  
  float a = 0;
  PVector baseLocation, overlappedLocation;
  boolean isLocked;
  boolean pIsHovered;
  PVector distanceToTravel;
  ArrayList<Button> attachedButtons = new ArrayList<Button>();
  ArrayList<PVector> buttonBaseLocations = new ArrayList<PVector>();
  ArrayList<PVector> buttonOverlappedLocations = new ArrayList<PVector>();
  
  MovingDashboard(int w, int h, boolean visible, PVector baseLocationInput, PVector overlappedLocationInput, ArrayList<Button> buttonsToAttach) {
    super(int(baseLocationInput.x), int(baseLocationInput.y), w, h, "", false, visible, "");
    baseLocation = baseLocationInput;
    overlappedLocation = overlappedLocationInput;
    attachedButtons = buttonsToAttach;
    distanceToTravel = new PVector(overlappedLocation.x - baseLocation.x, overlappedLocation.y - baseLocation.y);
    
    
    for (Button b : attachedButtons) {
      buttonBaseLocations.add(b.position);
      buttonOverlappedLocations.add(new PVector(b.position.x + distanceToTravel.x, b.position.y + distanceToTravel.y));
    }
    
  }
  
  @Override void update(float dt) {
    isHovered = checkHovered();
    
    a += 0.04;
    if (pIsHovered != isHovered) {
      a = 0;
    }
    if (a > 1) a = 1;
    if (isHovered && a < 1) {
        position.x = lerp(position.x, overlappedLocation.x, a);
        position.y = lerp(position.y, overlappedLocation.y, a);
      } else if (!isHovered && a < 1) {
        position.x = lerp(position.x, baseLocation.x, a);
        position.y = lerp(position.y, baseLocation.y, a);
      }
      
      
    for (int i = 0; i < attachedButtons.size(); i++) {
      Button b = attachedButtons.get(i);
      if (isHovered && a < 1) {
        b.position.x = lerp(b.position.x, buttonOverlappedLocations.get(i).x, a);
        b.position.y = lerp(b.position.y, buttonOverlappedLocations.get(i).y, a);
      } else if (!isHovered && a < 1) {
        b.position.x = lerp(b.position.x, buttonBaseLocations.get(i).x, a);
        b.position.y = lerp(b.position.y, buttonBaseLocations.get(i).y, a);
      }
    }
    
    
    pIsHovered = isHovered;
  }
  
  @Override void draw() {
    noStroke();
    rectMode(CORNER);
    textAlign(CENTER);
   
    if (isHovered == true){ 
      fill(0);
      rect(position.x-3,position.y-3,size.x+6,size.y+6, 8);
    }
    
   fill(#B4972C);
   rect(position.x,position.y,size.x,size.y,8);
   fill(10);
   textSize(20);
   text(text,position.x +size.x/2,position.y+size.y/2+5);  
    
  }

  
  
}
