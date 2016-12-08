import javax.swing.JOptionPane;
import controlP5.*;


int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

ControlP5 cp5;

PImage originalImg;
PImage scaledImg;
float lastScale = 0;
final float SCALE_DELAY = 25;
float scaleFactor = 0.999;

void setup() {
  size(900, 650);

  HORIZONTAL_SCREEN_RESOLUTION = Integer.parseInt(JOptionPane.showInputDialog("Please enter the horizontal resolution of your screen:"));
  SCREEN_WIDTH = Integer.parseInt(JOptionPane.showInputDialog("Please enter the physical width of your screen in mm:"));

  cp5 = new ControlP5(this);

  Button startButton = cp5.addButton("handler_startBtn")
    .setSize(100, 50)
    .setPosition(0, 0)
    .setCaptionLabel("Start Test");

  Button exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Exit");

  originalImg = loadImage("testImage.png");
  originalImg = fitImage(originalImg, _mm(150), _mm(90));
  scaledImg = originalImg.get();
}

void draw() {
  background(125);

  if(millis() - lastScale > SCALE_DELAY){
    try{
      scaledImg = fitImage(originalImg, (int)(scaleFactor * scaledImg.width), scaledImg.height);
      lastScale = millis();
    }catch(IllegalArgumentException e){
      // If we are in here, it means the image is no longer visible (cannot be
      // resized any smaller) and the user still has not clicked a button to
      // stop the test.
      // TODO: Ask the user to retake the test maybe? or automatically restart it
      String message = "You did not press a key. Test will now be restarted.";
      String title = "Incomplete Test";
      JOptionPane.showMessageDialog(null, message, title, JOptionPane.WARNING_MESSAGE);
      scaledImg = originalImg.get();
    }
  }

  float imgX = (width - scaledImg.width) / 2;
  float imgY = (height - scaledImg.height) / 2;
  image(scaledImg, imgX, imgY);
}

int _mm(float mm){
  // divide by displayDensity to account for high-dpi displays (retina, etc.)
  return (int)(((0.1 * mm) * HORIZONTAL_SCREEN_RESOLUTION / (0.1 * SCREEN_WIDTH)) / displayDensity());
}

PImage fitImage(PImage img, int maxWidth, int maxHeight) throws IllegalArgumentException{
  PImage temp = img.get();

  temp.resize(maxWidth, 0);
  if(temp.height > maxHeight){
    temp.resize(0, maxHeight);
  }

  return temp;
}

void handler_startBtn(){
  System.out.println("DONE");
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
