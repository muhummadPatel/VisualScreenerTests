import javax.swing.JOptionPane;
import controlP5.*;


int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

// GUI components
ControlP5 cp5;
Button exitButton;

// Test images
PImage[] images;
float[] lineHeights = { 40, 20, 14, 10, 8, 6, 5, 4 };
int activeImage;

void setup() {
  size(900, 650);

  // Callibration step so that we can display things using real mm dimensions
  try{
    HORIZONTAL_SCREEN_RESOLUTION = Integer.parseInt(JOptionPane.showInputDialog("Please enter the horizontal resolution of your screen:"));
    SCREEN_WIDTH = Integer.parseInt(JOptionPane.showInputDialog("Please enter the physical width of your screen in mm:"));
  }catch(NumberFormatException e){
    String message = "The value you entered was invalid. Please rerun the test.";
    String title = "Invalid Input";
    JOptionPane.showMessageDialog(null, message, title, JOptionPane.ERROR_MESSAGE);
    System.exit(0);
  }

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Exit");

  loadAndScaleImages();
}

void draw() {
  background(125);

  ellipse(width/2, height/2, 50, 50);
}

// convert from a dimension in mm to screen pixels (based on callibration step)
int _mm(float mm){
  // divide by displayDensity to account for high-dpi displays (retina, etc.)
  return round(((0.1 * mm) * HORIZONTAL_SCREEN_RESOLUTION / (0.1 * SCREEN_WIDTH)) / displayDensity());
}

// convert from a dimension in screen pixels to a dimension in mm. (based on callibration step)
int pxToMm(float px){
  return round(((px * displayDensity() * (0.1 * SCREEN_WIDTH)) / HORIZONTAL_SCREEN_RESOLUTION) * 10);
}

// Returns a copy of img, scaled down to fit inside maxWidth and maxHeight.
// Preserves aspect ratio to avoid image distortion.
PImage fitImage(PImage img, int maxWidth, int maxHeight) throws IllegalArgumentException{
  PImage temp = img.get();

  temp.resize(maxWidth, 0);
  if(temp.height > maxHeight){
    temp.resize(0, maxHeight);
  }

  return temp;
}

// start button handler to start the test
void handler_startBtn(){
  // TODO
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  String title = "Confirm Exit";
  String message = "Are you sure you want to exit this test?";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}

void loadAndScaleImages(){
  // assumes images are named 1.png, 2.png, etc.
  // load images
  images = new PImage[lineHeights.length];
  for(int i = 0; i < images.length; i++){
    images[i] = loadImage((i + 1) + ".png");
  }

  // scale images to actual size
  for(int i = 0; i < images.length; i++){
    images[i].resize(0, _mm(lineHeights[i]));
  }
}
