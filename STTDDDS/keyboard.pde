static public class Keyboard {
 
    private static boolean[] keys = new boolean[128];
    private static boolean[] pKeys = new boolean[128];
    public static final int Ctrl= 17; //open Dashboard
    public static final int Z = 90; //lock Dashboard
    
    public static void update() {
      // Update the state of all keys in the previous frame to the state in the current frame.
      for(int i = 0; i < keys.length; i++) {
        pKeys[i] = keys[i];
      }
    }
    
    private static void handleKey(int code, boolean isDown){
      keys[code] = isDown;    
    }
    
    public static boolean isDown(int code){
      return keys[code];
    }
    
    public static boolean onDown(int code){
      return (keys[code] && !pKeys[code]);
    }
    
    public static void handleKeyDown(int code){
      handleKey(code,true);
    }
    
    public static void handleKeyUp(int code){
      handleKey(code, false);
    }
} //thanks you varuun from one year ago :-)
