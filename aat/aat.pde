import javax.swing.JOptionPane;
import controlP5.*;


int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

// settings
JSONObject settings;
JSONObject languageRepo;

// GUI components
ControlP5 cp5;
Button startButton;
Button exitButton;
Textlabel instructionLabel;

// Image and image scaling related vars
PImage originalImg;
PImage scaledImg;
float lastScale = 0;  // Last time (in ms) when the image was scaled
final float SCALE_DELAY = 5;  // how often (in ms) to scale down the image
float scaleFactor = 0.999;  // factor by which to scale down the image at each step

// test state logic vars
boolean testRunning = false;
boolean testCompleted = false;

void setup() {
  size(900, 650);

  // load settings
  settings = loadJSONObject("settings.json");
  languageRepo = loadJSONObject(settings.getString("language") + ".json").getJSONObject("aat");

  HORIZONTAL_SCREEN_RESOLUTION = settings.getInt("horizontal_screen_resolution", -1);
  SCREEN_WIDTH = settings.getInt("screen_width", -1);

  if(HORIZONTAL_SCREEN_RESOLUTION <= 0 || SCREEN_WIDTH <= 0) {
    JOptionPane.showMessageDialog(null, i10n("message_missing_calibration_data"), i10n("title_missing_calibration_data"), JOptionPane.ERROR_MESSAGE);
    System.exit(0);
  }

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  startButton = cp5.addButton("handler_startBtn")
    .setSize(100, 50)
    .setPosition(0, 0)
    .setCaptionLabel(i10n("button_start_test"));

  instructionLabel = cp5.addTextlabel("instructionLabel")
    .setPosition(125, 12.5)
    .setText(i10n("prompt_test_instruction"))
    .setFont(createFont("", 20));

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("End Test");

  // load the image and fit it to a predefined maximum dimension in mm
  originalImg = loadImage("testImage.png");
  originalImg = fitImage(originalImg, _mm(150), _mm(90));

  initTest();
}

void draw() {
  background(125);

  if(testRunning){
    if(millis() - lastScale > SCALE_DELAY){
      // scale down the image after every SCALE_DELAY if the test is running
      try{
        scaledImg = fitImage(originalImg, (int)(scaleFactor * scaledImg.width), scaledImg.height);
        lastScale = millis();
      }catch(IllegalArgumentException e){
        // If we are in here, it means the image is no longer visible (cannot be
        // resized any smaller) and the user still has not clicked a button to
        // stop the test. So reset the test and ask them to retake it.
        JOptionPane.showMessageDialog(null, i10n("message_incomplete_test"), i10n("title_incomplete_test"), JOptionPane.WARNING_MESSAGE);

        initTest();
      }
    }
  }

  // display the scaled image in the centre of the window.
  float imgX = (width - scaledImg.width) / 2;
  float imgY = (height - scaledImg.height) / 2;
  image(scaledImg, imgX, imgY);
}

// sets the scaled image to the original image and resets all state vars.
void initTest(){
  scaledImg = originalImg.get();
  testRunning = false;
  testCompleted = false;
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
  testRunning = true;
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  int reply = JOptionPane.showConfirmDialog(null, i10n("prompt_confirm_exit"), i10n("title_confirm_exit"), JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}

// keyPress handler to stop the test and exit when the enter key is pressed
void keyPressed(){
  if(testRunning && (key == ENTER || key == RETURN)){
    testRunning = false;
    testCompleted = true;
    exit();
  }
}

// exit handler called before the sketch closed. Prints out the report to
// report.txt. It prints the result if the test was completed or INC otherwise.
void dispose(){
  String[] report = new String[1];
  if(testCompleted){
    int originalWidth = pxToMm(originalImg.width);
    int finalWidth = pxToMm(scaledImg.width);
    report[0] = originalWidth + "/" + finalWidth;

    JOptionPane.showMessageDialog(null, i10n("message_test_complete"), i10n("title_test_complete"), JOptionPane.INFORMATION_MESSAGE);
  }else{
    report[0] = "INC";
  }

  saveStrings("report.txt", report);
}

String i10n(String strKey) {
  return languageRepo.getString(strKey, "<unknown prompt: " + strKey + ">");
}
