class WitchDoctor extends BaseActor {
 
  WitchDoctor(int x, int y) {
   super(x, y);
   sprite = loadImage("sprites/witchdoctor.png"); //will swap out when witch doctor is done (I am yearning)
   attackSpeed = 0.4;
   maxAttackCooldown = 1;
   scareRange = 500;
  }
  
  void update() { 
    //applies upgrades every frame
    attackSpeed = 0.4 + UpgradeDump.getWitchAttackSpeedBonus();
    //Poison pool damage and size are handled in the witchDoctorPool at spawn time
    
   super.update();
   if(attackCooldown < 0) {
    if (!guestsInRange.isEmpty()){ 
      witchDoctorAttack();
   }else {
    attackCooldown = maxAttackCooldown;
   }
  }
}

void draw() {
 noFill();
 stroke(0, 200, 100, 80);
 strokeWeight(3);
 ellipse(position.x, position.y, scareRange, scareRange);
 noStroke();
 super.draw();
}

void witchDoctorAttack() {
 BaseGuest target = getFrontGuestInRange(); 
 if(target != null) {
  WitchDoctorProjectile proj = new WitchDoctorProjectile(position.x, position.y, angle, target);
  attacks.add(proj);
  attackCooldown = maxAttackCooldown;
 }
 }
}

class WitchDoctorProjectile extends CircleProjectile { 
 
  BaseGuest target;
  
  WitchDoctorProjectile(float x, float y, float angle, BaseGuest target) {
   super(x, y, angle);
   this.target = target;
   size.x = 15;
   projectileSpeed = 3;
   lifetime = 4;
   damage = 0;
   isColliding = false;
  }
  
  void update() {
   //steer towards the target
   if (target != null) {
   float targetAngle = atan2(target.position.y - position.y, target.position.x - position.x);
   angle = lerp(angle, targetAngle, 0.2);
  }
  //Call projectile's update but not Circle projectiles collision, keeps deleting before hitting target
  lifetime -= dt;
  if (lifetime <0) isAlive = false;
  velocity.x = cos(angle) * projectileSpeed;
  velocity.y = sin(angle) * projectileSpeed;
  position.x += velocity.x;
  position.y += velocity.y;
  
  if (target != null) {
   float dis = dist(position.x, position.y, target.position.x, target.position.y);
   if (dis < 20){
     spawnPool();
     isAlive = false;
   }
  }
  }
  
  void draw() {
  noStroke();
  fill(0, 200, 100);
  circle(position.x, position.y, size.x);
  }
  void spawnPool() {
    WitchDoctorPool pool = new WitchDoctorPool(position.x, position.y);
    aoeAttacks.add(pool);
  }
}


class WitchDoctorPool extends Attack {
 
  float radius = 60;
  float tickInterval = 1.0; //deals damage every 1 second
  float tickTimer = 0;
  
  WitchDoctorPool(float x, float y) {
   super(x, y);
   lifetime = 4.0; //only around for 4 seconds
   lengthOfDebuff = 1.2; //slightly longer than the tick interval, just ot make sure the slow doesn't drop off between ticks
   debuffs.add(debuffTypes.SLOWNESS);
   
   //reads the upgrade bonuses at the moment pool spawns so each
   //pool carries the right stats at time of spawn
   damage = 10 + int(UpgradeDump.getWitchPoolDamageBonus());
   radius = 60 + UpgradeDump.getWitchPoolSizeBonus();
  }
  
  void update() {
   super.update();
   tickTimer -= dt;
   if (tickTimer <= 0) {
    tickTimer = tickInterval;
    spawnTick();
   }
  }
  
  void spawnTick() {
   WitchDoctorTick tick = new WitchDoctorTick(position.x, position.y, radius, damage, debuffs, lengthOfDebuff);
   aoeAttacks.add(tick);
  }
  
  void draw() {
   //draw a green pool of goop
   noStroke();
   float alpha = map(lifetime, 0, 4.0, 20, 70);
   fill(0, 200, 100, alpha);
   ellipse(position.x, position.y, radius * 2, radius * 2);
  }
}

class WitchDoctorTick extends Attack {
 
  float radius; 
  
  WitchDoctorTick(float x, float y, float radius, int dmg, ArrayList<debuffTypes> debuffList, float debuffLength) {
   super(x, y);
   this.radius = radius;
   this.damage = dmg;
   this.lifetime = 0.05; //exists just long enough to register hits
   this.lengthOfDebuff = debuffLength;
   for (debuffTypes d : debuffList) {
    debuffs.add(d); 
   }
  }
  
  void update() {
   super.update();
   ArrayList<BaseGuest> colliding = checkCircleCollision(position.x, position.y, radius);
   handleCollisions(colliding);
  }
  
  void draw() {
   //pool handles this, so nothing there 
  }
}
