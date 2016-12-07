import javax.swing.JOptionPane;

int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

PImage originalImg;
PImage scaledImg;
float lastScale = 0;
final float SCALE_DELAY = 25;
float scaleFactor = 0.999;

void setup() {
  size(900, 650);

  HORIZONTAL_SCREEN_RESOLUTION = Integer.parseInt(JOptionPane.showInputDialog("Please enter the horizontal resolution of your screen:"));
  SCREEN_WIDTH = Integer.parseInt(JOptionPane.showInputDialog("Please enter the physical width of your screen in mm:"));

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
