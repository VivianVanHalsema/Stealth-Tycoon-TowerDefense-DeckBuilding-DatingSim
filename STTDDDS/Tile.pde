static class TileHelper {

  static STTDDDS app;
  static boolean isHex = false;
  final static int W = 100;
  final static int H = 100;
  final static int halfW = W / 2;
  final static int halfH = H / 2;

  static PVector gridToPixel(Point p) {
    return gridToPixel(p.x, p.y);
  }
  static PVector gridToPixel(int X, int Y){
    PVector v = new PVector(X * W, Y * H);
    if (isHex && X % 2 == 0) v.y += 16;
    return v;
  }
  static Point pixelToGrid(PVector v, PVector camera, float zoom) {
    
    
    //The comments are from me experimenting with different versions of getting the scale transform to work with the grid
    //Until that is cleaned up, the mouse wheel will be disabled.
    //TO DO: Fix camera zoom functionality
    
    //v = new PVector(v.x / zoom, v.y / zoom);
    
    //PVector distanceFromCameraToMouse = new PVector(v.x - 640, v.y - 360);
    
    
    
    v = new PVector(v.x + camera.x, v.y + camera.y); //Recalculate location with camera position on screen
    
    
    //println(v);
    
    //PVector p = v.normalize();
    //float vMag = v.mag();
    //p.setMag(vMag / zoom);
    
    

    int x = (int)((v.x/ W));
    if (isHex && x % 2 == 0) v.y -= halfH;
    int y = (int)((v.y/ H));

    return app.new Point(x, y);
  }
}

class Tile {

  int X; // GRID X
  int Y; // GRID Y
  int TERRAIN = 0; // TERRAIN TYPE
  boolean hover = false;

  Tile(int X, int Y) {
    this.X = X;
    this.Y = Y;
  }
  // DRAW THIS TILE:
  void draw() {
    if (TERRAIN == 0) {
      if (TileHelper.isHex) fill(127);
      else if(hover) {}
      else fill(127, 0.5); // don't draw empty tiles
    }
    if (TERRAIN == 1) fill(200);
    if (TERRAIN == 2) fill(255);
    if(hover) fill(255, 255, 0);
    
    if (TileHelper.isHex) {
      PVector p = getCenter();
      ellipse(p.x, p.y, TileHelper.W, TileHelper.H);
    } 
    else {
      PVector p = TileHelper.gridToPixel(X, Y);
      stroke(0);
      strokeWeight(2);
      rect(p.x, p.y, TileHelper.W, TileHelper.H);
      noStroke();
    }
    hover = false;
  }
  // GET THE CENTER POINT OF THIS TILE IN PIXEL-SPACE:
  PVector getCenter() {
    PVector p = TileHelper.gridToPixel(new Point(X, Y));
    p.x += TileHelper.halfW;
    p.y += TileHelper.halfH;
    return p;
  }
  boolean isPassable(){
    return (TERRAIN != 2); 
  }

  ///////////////////////////////////////////////////
  /////////////// PATHFINDING STUFF: ////////////////
  ///////////////////////////////////////////////////

  ArrayList<Tile> neighbors = new ArrayList<Tile>(); // LIST OF NEIGHBORING TILES
  Tile parent; // PARENT TILE (previous tile in the path)
  float G; // COST TO TRAVEL TO THIS TILE... from origin!
  float F; // TOTAL COST OF THIS TILE

  // ADD THE SUPPLIED TILES TO THIS TILE'S LIST OF NEIGHBORS:
  void addNeighbors(Tile[] tiles) {
    for (Tile t : tiles) {
      if (t != null) neighbors.add(t);
    }
  }
  // SET THE PARENT OF THIS TILE:
  // This is used during pathfinding to remember where the path originated.
  void setParent(Tile n) {
    parent = n;
    G = parent.G + getTerrainCost();
  }
  // RESET THE PARENT OF THIS TILE:
  // This is used when starting pathfinding. When reversing back
  // through the path, we know we've arrived once we reach a tile
  // without a parent tile.
  void resetParent() {
    parent = null;
    G = 0;
    F = 0;
  }
  // RETURN THE COST OF MOVING INTO THIS TILE:
  float getTerrainCost() {
    if (TERRAIN >= 0 && TERRAIN < LevelData.MOVECOST.length) return LevelData.MOVECOST[TERRAIN];
    return 0;
  }
  // HEURISTICS CALULATIONS:
  void doHeuristic(Tile n, boolean useManhattan) {
    if (useManhattan) F = G + distanceManhattan(n);
    if (!useManhattan) F = G + distanceEuclidean(n);
  }
  // MANHATTAN HEURISTIC CALCULATION:
  float distanceManhattan(Tile n) {
    return abs(n.X - X) + abs(n.Y - Y);
  }
  // EUCLIDEAN HEURISTIC CALCULATION:
  float distanceEuclidean(Tile n) {
    float dx = n.X - X;
    float dy = n.Y - Y;
    return sqrt(dx * dx + dy * dy);
  }
}



class Point {
  int x = 0;
  int y = 0;
  Point(){ }
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  Point get(){
    return new Point(x, y); 
  }
  Point getUp(){
    return new Point(x, y-1);
  }
  Point getDown(){
    return new Point(x, y+1);
  }
  Point getLeft(){
    return new Point(x-1, y);
  }
  Point getRight(){
    return new Point(x+1, y);
  }
  String toString(){
    return x + ", " + y; 
  }
}
