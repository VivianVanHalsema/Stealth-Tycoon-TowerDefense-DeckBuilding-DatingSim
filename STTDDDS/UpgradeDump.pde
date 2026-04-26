//This will act as a global storage for the different upgrade levels for each tower type.
//makes the upgrades permanent and applies to all duplicate towers. 
//The actors will read their upgrades here and apply them every frame. 
//This way the upgrades will be available back on main. 

static class UpgradeDump {
  //each tower type gets 3 upgrades 
  //each index value is how many times the upgrade has been bought.
  
  //mummy upgrades 0 = range, 1 = slow duration, 2 = attack speed
  static int[] mummyLevels = {0, 0, 0};
  
  //Jason upgrades 0 = range, 1 = damage, 2 = attack speed
  static int[] jasonLevels = {0, 0, 0};
  
  //WitchDoctor upgrades 0 = attack speed, 1 = pool damage, 2 = pool size
  static int[] witchLevels = {0, 0, 0};
  
  //Cultist upgrades: 0 = brainwash chance, 1 = attack speed, 2 = range
  static int[] cultistLevels = {0, 0, 0};
  
  //Vampire upgrades: 0 = damage, 1 = attack speed, 2 = range
  static int[] vampireLevels = {0, 0, 0};
  
  //Werewolf upgrades: 0 = flee chance, 1 = attack speed, 2 = damage boost
  static int[] werewolfLevels = {0, 0, 0};
  
  //max level for any single upgrade slot
  static int MAX_LEVEL = 3;
  
  //Upgrade costs per level - index is the current level before buying.
  //so level 0-1 would cost about 500, 1-2 costs more at 1000, then 2-3 costs 15000,
  //These ranges can absolutely be tweaked later
  static int[] costs = {500, 1000, 15000};
  
  //returns the int[] for a given actor type and makes other methods cleaner
   static int[] getLevels(actorTypes type) {
    switch(type) {
      case MUMMY:      return mummyLevels;
      case JASON:      return jasonLevels;
      case WITCHDOCTOR: return witchLevels;
      case CULTIST:    return cultistLevels;
      case VAMPIRE:    return vampireLevels;
      case WEREWOLF:    return werewolfLevels;
      default:         return null;
    }
  }
  
  //Returns true if an upgrade slot can still be purchased
  static boolean canUpgrade(actorTypes type, int slot) {
   int[] levels = getLevels(type);
   if (levels == null) return false;
   return levels[slot] < MAX_LEVEL;
  }
  
  //returns cost of next purchase for each slots
  //dependant on how many times its been purchased already tho
  static int getCost(actorTypes type, int slot) {
   int [] levels = getLevels(type);
   if (levels == null) return 0;
   int currentLevel = levels[slot];
   if (currentLevel >= MAX_LEVEL) return 0;
   return costs[currentLevel];
  }
  
  //deducts money and increments of the level if affordable and upgrade isn't maxxed yet
  //returns true if purchase succeeds
  static boolean buyUpgrade(actorTypes type, int slot) {
    if (!canUpgrade(type, slot)) return false;
     int[] levels = getLevels(type);  // store reference first
     levels[slot]++;                   // then increment
     return true;
  }
  
  //these are getting the towers the stats, and each actor will call this in their update() or wherever each stat is used
  //The base values will be in each actor and is added from here
  
    // MUMMY
  // Upgrade 0: +80 range per level
  static float getMummyRangeBonus()         { return mummyLevels[0] * 80; }
  // Upgrade 1: +0.5 seconds of slow per level
  static float getMummySlowBonus()          { return mummyLevels[1] * 0.5; }
  // Upgrade 2: +0.2 attack speed multiplier per level
  static float getMummyAttackSpeedBonus()   { return mummyLevels[2] * 0.2; }

  // JASON
  // Upgrade 0: +60 range per level
  static float getJasonRangeBonus()         { return jasonLevels[0] * 60; }
  // Upgrade 1: +10 damage per level
  static float getJasonDamageBonus()        { return jasonLevels[1] * 10; }
  // Upgrade 2: +0.3 attack speed multiplier per level
  static float getJasonAttackSpeedBonus()   { return jasonLevels[2] * 0.3; }

  // WITCH DOCTOR
  // Upgrade 0: +0.2 attack speed multiplier per level
  static float getWitchAttackSpeedBonus()   { return witchLevels[0] * 0.2; }
  // Upgrade 1: +8 pool damage per level
  static float getWitchPoolDamageBonus()    { return witchLevels[1] * 8; }
  // Upgrade 2: +20 pool radius per level
  static float getWitchPoolSizeBonus()      { return witchLevels[2] * 20; }

  // CULTIST
  // Upgrade 0: +0.15 brainwash chance per level (stored as 0.0-1.0 probability)
  static float getCultistBrainwashBonus()   { return cultistLevels[0] * 0.15; }
  // Upgrade 1: +0.2 attack speed multiplier per level
  static float getCultistAttackSpeedBonus() { return cultistLevels[1] * 0.2; }
  // Upgrade 2: +60 range per level
  static float getCultistRangeBonus()       { return cultistLevels[2] * 60; }
  
  // VAMPIRE
  // Upgrade 0: +7 damage per level
  static float getVampireDamageBonus()   { return vampireLevels[0] * 7; }
  // Upgrade 1: 10% quicker attacks per level
  static float getVampireAttackSpeedBonus() { return vampireLevels[1] * 0.1; }
  // Upgrade 2: +60 range per level
  static float getVampireRangeBonus()       { return vampireLevels[2] * 60; }
  
  // CULTIST
  // Upgrade 0: +0.15 flee chance per level (stored as 0.0-1.0 probability)
  static float getWerewolfFleeOddsBonus()   { return werewolfLevels[0] * 5; }
  // Upgrade 1: +0.2 attack speed multiplier per level
  static float getWerewolfAttackSpeedBonus() { return werewolfLevels[1] * 0.2; }
  // Upgrade 2: +5 damage per level
  static float getWerewolfDamageBonus()       { return werewolfLevels[2] * 5; }
}
