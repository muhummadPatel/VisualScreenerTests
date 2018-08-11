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

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("End Test");

  // load the image and fit it to a predefined maximum dimension in mm
  originalImg = loadImage("testImage.png");
  originalImg = fitImage(originalImg, _mm(150), _mm(90));
}

void draw() {
  background(125);

  // display the scaled image in the centre of the window.
  float imgX = (width - originalImg.width) / 2;
  float imgY = (height - originalImg.height) / 2;
  image(originalImg, imgX, imgY);
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

// exit button handler terminates the sketch
void handler_exitBtn(){
  int reply = JOptionPane.showConfirmDialog(null, i10n("prompt_confirm_exit"), i10n("title_confirm_exit"), JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}

String i10n(String strKey) {
  return languageRepo.getString(strKey, "<unknown prompt: " + strKey + ">");
}
