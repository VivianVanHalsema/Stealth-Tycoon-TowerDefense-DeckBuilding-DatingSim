class MovingDashboard extends Button {
  
  float a = 0;
  PVector baseLocation, overlappedLocation;
  boolean isLocked;
  boolean pIsHovered;
  PVector distanceToTravel;
  ArrayList<Button> attachedButtons = new ArrayList<Button>();
  ArrayList<PVector> buttonBaseLocations = new ArrayList<PVector>();
  ArrayList<PVector> buttonOverlappedLocations = new ArrayList<PVector>();
  PImage photo;
  dashboardTabs currentTab;
  
  MovingDashboard(PVector baseLocationInput, PVector overlappedLocationInput, ArrayList<Button> buttonsToAttach) {
    
    super(int(baseLocationInput.x), int(baseLocationInput.y), "DASHBOARD");
    photo = loadImage("sprites/exampleFolder.png");
    currentTab = dashboardTabs.HIRE;
    
    baseLocation = baseLocationInput;
    overlappedLocation = overlappedLocationInput;
    attachedButtons = buttonsToAttach;
    distanceToTravel = new PVector(overlappedLocation.x - baseLocation.x, overlappedLocation.y - baseLocation.y);
    
    
    for (Button b : attachedButtons) {
      PVector buttonLocation = new PVector(b.position.x, b.position.y);
      buttonBaseLocations.add(buttonLocation);
      buttonOverlappedLocations.add(new PVector(b.position.x + distanceToTravel.x, b.position.y + distanceToTravel.y));
    }
    
  }
  
  @Override void update() {
    isHovered = (checkHovered()||Keyboard.isDown(Keyboard.Ctrl));
    if(Keyboard.onDown(Keyboard.Z)) toggleDashboardLock();
    
    if (!isLocked) {
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
    }
    
    for(Button b : attachedButtons){
    if (b instanceof DashBoardButton){
      if (currentTab != ((DashBoardButton) b).thisTab){
        b.clickable = false;
        b.visible = false;
      } else {
       b.clickable = true;
       b.visible = true;
        
      }
    }
   
      
      
      
      
      
    }
    
    pIsHovered = isHovered;
  }
  
  @Override void draw() {
   noStroke();
   imageMode(CORNER);
   fill(#B4972C);
   push();
   translate(position.x,position.y);
   image(photo,0,0);
   pop();  
  }

}

enum dashboardTabs {
  ALL,// buttons that show on all tabs
  HIRE, //get actors
  UPGRADE,// get global upgrades
  STATS, // I think this would be useful for if each tower needs to get paid each night, so u can see ur current overhead, who's putting out the most damage etc also obvs needs a jason talk/click counter obvs
  SETTINGS //volume, quit to menu
};
