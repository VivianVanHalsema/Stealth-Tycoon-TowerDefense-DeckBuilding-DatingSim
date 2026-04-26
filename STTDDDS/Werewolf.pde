
class Werewolf extends BaseActor {

  float displaylifetime = 0;
  float displaylifetimereset = 1.5;

  Werewolf(int x, int y) {
    super(x, y);
    /* customizable variables
     sprite = loadImage("sprites/mummy.png");
     attackSpeed = .8;
     scareRange = 240;
     */

    sprite = loadImage("sprites/werewolf.png");
    sprite.resize(int(size.x), int(size.y));
    attackSpeed = .8;
    scareRange = 500;
    maxAttackCooldown = 3;
  }



  void update() {
    super.update();
    
    attackSpeed = 0.8 + UpgradeDump.getWerewolfAttackSpeedBonus();
    
    if (attackCooldown < 0) {
      if (!guestsInRange.isEmpty()) {
        werewolfAttack();// here is where you put your special custom attack
      } else {
        attackCooldown = 0.8;
      } //this gives the tower time to turn when a new guest enters their range
    }


    displaylifetime -= dt;
  }

  void draw() {
      noStroke();
      rectMode(CENTER);
      imageMode(CENTER);
      //draw attack range
      fill(255, 20);
      ellipse(position.x, position.y, scareRange, scareRange);
    if (displaylifetime <= 0) {
      
      pushMatrix();
      translate(position.x, position.y);
      rotate(angle);
      imageMode(CENTER);
      image(sprite, 2 * sin(angle) * bpm.adsr(0.5, 0.5, 0.1, 0.4), 2 * cos(angle) * bpm.adsr(0.5, 0.5, 0.1, 0.4));
      //image(sprite, 0, 0);
      popMatrix();
    }
  }


  void werewolfAttack() {
    // IF your actor uses attacks, create your projectile, add it to the projectile arraylist,
    //else you'll have you''ll have to figure it out on your own for now unless I get to it
    displaylifetime = displaylifetimereset;
    WerewolfProjectile werewolfProjectile = new WerewolfProjectile(int(this.position.x), int(this.position.y), angle, displaylifetime, sprite);
    attacks.add(werewolfProjectile);
    attackCooldown = maxAttackCooldown;
  }
}
//make sure to extend from CircleProjectile,RectProjectile, or LineProjectile(what mummy uses)
//unless you need something else like aoe or physical attack
//then gl/I'm working on it/your working on it
//depends on what it is talk to me
class WerewolfProjectile extends CircleProjectile {

  PImage sprite;

  WerewolfProjectile(int x, int y, float angle, float lifetimesync, PImage wwsprite) {
    super(x, y, angle);
    sprite = wwsprite;
    /* change these variables to taste
     
     size.x = 50;
     size.y = 20;
     lifetime = .8;
     projectileSpeed = 6;
     damage = 3;
     
     //make sure to add your own debuff to the enum debuffTypes found at the bottom of BaseGuest
     //except for jaso nunproblematic king
     debuffs.add(debuffTypes.SLOWNESS);
     
     */
    size.x = 75;
    size.y = 75;
    lifetime = lifetimesync;
    projectileSpeed = 8;
    damage = 15 + int(UpgradeDump.getWerewolfDamageBonus());;
    
    debuffs.add(debuffTypes.FLEEING);
    
    lengthOfDebuff = 1;
    
  }

  void update() {
    super.update();
    
    if (isColliding) isAlive = false;
    //this should handle collision and be all you need unless ur getting freaky
  }
  void draw() {
    noStroke();
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);  // Rotate the projectile to face its direction... I assume these sprites are gonna need angle even tho they are ellipses...right?
    fill(255, 0, 0);
    tint(255, 128);
    //circle(0, 0, size.x);
    image(sprite, 0, 0);
    noTint();
    popMatrix();
    //this should work I'll slot in images instead of just basic shapes eventually
  }
}
