static class LevelData {
  
  static int[] MOVECOST = {1, 4, 1000};
  
  
  static int[][] Level1 =
  { //16 Rows 16 Columns
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //5
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //10
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, //15
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} //16
  };
  
}

class Level {

  int[][] level;
  Tile[][] tiles;
  boolean useDiagonals = false;

  Level() {
    loadLevel(LevelData.Level1);
  }
  void draw() {
    noStroke();
    //if(TileHelper.isHex) rectMode(CENTER);
    for (int Y = 0; Y < tiles.length; Y++) {
      for (int X = 0; X < tiles[Y].length; X++) {
        tiles[Y][X].draw();
      }
    }
    fill(0);
  }
  Tile getTile(int X, int Y) {
    if (X < 0 || Y < 0) return null;
    if (Y >= tiles.length || X >= tiles[0].length) return null;
    return tiles[Y][X];
  }
  Tile getTile(Point p) {
    return getTile(p.x, p.y);
  }
  PVector getTileCenterAt(Point p) {
    Tile tile = getTile(p);
    if (tile == null) return new PVector();
    return tile.getCenter();
  }
  boolean isPassable(Point p) {
    Tile tile = getTile(p);
    if (tile == null) return false;
    return tile.isPassable();
  }

  void reloadLevel() {
    loadLevel(level);
  }

  void loadLevel(int[][] layout) {

    level = layout; // cache the layout (to enable reloading levels)

    /*
    TODO: Build the level from the level data.
     
     1. Build a 2D tiles array to hold all of the tiles.
     2. Instantiate all tiles, add to the tiles array.
     3. Add all neighbors to each tile.
     (this varies with grid type: square / type; AND this varies with whether or not we allow diagonal movement)
     */

    //Step One, build multidimensional array of tiles
    int ROWS = layout.length;
    int COLUMNS = layout[0].length;
    tiles = new Tile[ROWS][COLUMNS];

    for (int Y = 0; Y < ROWS; Y++) {
      for (int X = 0; X < COLUMNS; X++) {

        Tile tile = new Tile(X, Y);
        tile.TERRAIN = layout[Y][X];
        tiles[Y][X] = tile;
      }
    }

    for (int Y = 0; Y < ROWS; Y++) {
      for (int X = 0; X < COLUMNS; X++) {

        if (TileHelper.isHex) {
          if (X % 2 == 0) {
            tiles[Y][X].addNeighbors(new Tile[] {
              getTile(X-1, Y),
              getTile(X-1, Y+1),
              getTile(X, Y-1),
              getTile(X, Y+1),
              getTile(X+1, Y),
              getTile(X+1, Y+1)
              }); //end Add Neighbors
          } else {

            tiles[Y][X].addNeighbors(new Tile[] {
              getTile(X-1, Y-1),
              getTile(X-1, Y),
              getTile(X, Y-1),
              getTile(X, Y+1),
              getTile(X+1, Y-1),
              getTile(X+1, Y)
              }); //end Add Neighbors
          }
        } //IS HEX END
        else {
          tiles[Y][X].addNeighbors(new Tile[] {
            getTile(X-1, Y), //left
            getTile(X+1, Y), //right
            getTile(X, Y-1), //down
            getTile(X, Y+1), //up

            });
          if (useDiagonals) {
              tiles[Y][X].addNeighbors(new Tile[] {
              getTile(X-1, Y-1), //topleft
              getTile(X+1, Y+1), //topright
              getTile(X+1, Y-1), //bottomright
              getTile(X-1, Y+1), //bottomleft

              });
          } //end Use Diagonals
        } //end else
      } // end columns loop
    } // end rows loop
  } // end loadLevel()

  void toggleDiagonals() {
    useDiagonals = !useDiagonals;
  }
}
