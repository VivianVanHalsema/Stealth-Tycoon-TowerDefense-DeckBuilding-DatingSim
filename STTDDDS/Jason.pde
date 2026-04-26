class Jason extends BaseActor {
 Jason(int x, int y, actorTypes scaractor){ 
   super(x,y, scaractor);
   sprite = loadImage("sprites/jason.png");
   attackSpeed = 1;
   maxAttackCooldown = 1;
   scareRange = 200;
 }

 void update() {
   //apllies upgrade bonuses every frame
   scareRange = 200 + UpgradeDump.getJasonRangeBonus();
   attackSpeed = 1.0 + UpgradeDump.getJasonAttackSpeedBonus();
   //damage is passed onto JasonAOEHit at attack time
   
  super.update();
  if (attackCooldown < 0) {
  if (!guestsInRange.isEmpty()) {
    JasonPulse();
  } else {
    attackCooldown = maxAttackCooldown;
  }
 }
}

void draw() {
 noFill();
 stroke(180, 0, 255, 80);
 strokeWeight(3);
 ellipse(position.x, position.y, scareRange, scareRange);
 noStroke();
 super.draw();
}

void JasonPulse() {
 JasonAOEHit hit = new JasonAOEHit(position.x, position.y, scareRange);
 attacks.add(hit);
 attackCooldown = maxAttackCooldown;
}

} 

class JasonAOEHit extends Attack {
 float aoeRadius;
 
 void update() {
   super.update();
   ArrayList<BaseGuest> colliding = checkCircleCollision(position.x, position.y, aoeRadius);
   handleCollisions(colliding);
  }
  
 JasonAOEHit(float x, float y, float radius) {
  super(x, y);
  aoeRadius = radius/2;
  damage = 25 + int(UpgradeDump.getJasonDamageBonus());
  lifetime = 0.05;
  lengthOfDebuff = 0;
 }
 
 void draw() {
  noStroke();
  fill(180, 0, 255, 40);
  ellipse(position.x, position.y, aoeRadius * 2, aoeRadius * 2);
 }
}
