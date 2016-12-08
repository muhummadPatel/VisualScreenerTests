import javax.swing.JOptionPane;
import controlP5.*;


int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

ControlP5 cp5;
Button startButton;
Button exitButton;
Textlabel instructionLabel;

PImage originalImg;
PImage scaledImg;
float lastScale = 0;
final float SCALE_DELAY = 25;
float scaleFactor = 0.999;

boolean testRunning;
boolean testCompleted;

void setup() {
  size(900, 650);

  HORIZONTAL_SCREEN_RESOLUTION = Integer.parseInt(JOptionPane.showInputDialog("Please enter the horizontal resolution of your screen:"));
  SCREEN_WIDTH = Integer.parseInt(JOptionPane.showInputDialog("Please enter the physical width of your screen in mm:"));

  cp5 = new ControlP5(this);

  startButton = cp5.addButton("handler_startBtn")
    .setSize(100, 50)
    .setPosition(0, 0)
    .setCaptionLabel("Start Test");

  instructionLabel = cp5.addTextlabel("instructionLabel")
    .setPosition(125, 12.5)
    .setText("Press enter when the image goes out of focus")
    .setFont(createFont("", 20));

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Exit");

  originalImg = loadImage("testImage.png");
  originalImg = fitImage(originalImg, _mm(150), _mm(90));

  initTest();
}

void draw() {
  background(125);

  if(testRunning){
    if(millis() - lastScale > SCALE_DELAY){
      try{
        scaledImg = fitImage(originalImg, (int)(scaleFactor * scaledImg.width), scaledImg.height);
        lastScale = millis();
      }catch(IllegalArgumentException e){
        // If we are in here, it means the image is no longer visible (cannot be
        // resized any smaller) and the user still has not clicked a button to
        // stop the test.
        String message = "You did not press a key. Please retake the test.";
        String title = "Incomplete Test";
        JOptionPane.showMessageDialog(null, message, title, JOptionPane.WARNING_MESSAGE);

        initTest();
      }
    }
  }

  float imgX = (width - scaledImg.width) / 2;
  float imgY = (height - scaledImg.height) / 2;
  image(scaledImg, imgX, imgY);
}

void initTest(){
  scaledImg = originalImg.get();
  testRunning = false;
  testCompleted = false;
}

int _mm(float mm){
  // divide by displayDensity to account for high-dpi displays (retina, etc.)
  return round(((0.1 * mm) * HORIZONTAL_SCREEN_RESOLUTION / (0.1 * SCREEN_WIDTH)) / displayDensity());
}

int pxToMm(float px){
  return round(((px * displayDensity() * (0.1 * SCREEN_WIDTH)) / HORIZONTAL_SCREEN_RESOLUTION) * 10);
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
  testRunning = true;
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  String title = "Confirm Exit";
  String message = "Are you sure you want to exit this test? (record will be incomplete)";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}

void keyPressed(){
  if(testRunning && (key == ENTER || key == RETURN)){
    testRunning = false;
    testCompleted = true;
    exit();
  }
}

void dispose(){
  String[] report = new String[1];
  if(testCompleted){
    int originalWidth = pxToMm(originalImg.width);
    int finalWidth = pxToMm(scaledImg.width);
    report[0] = originalWidth + "/" + finalWidth;

    String message = "Thank you, your results have been recorded.";
    String title = "Test Complete";
    JOptionPane.showMessageDialog(null, message, title, JOptionPane.INFORMATION_MESSAGE);
  }else{
    report[0] = "INC";
  }

  saveStrings("report.txt", report);
}
