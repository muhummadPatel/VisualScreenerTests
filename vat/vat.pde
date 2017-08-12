import javax.swing.JOptionPane;
import controlP5.*;


int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

// settings
JSONObject settings;
JSONObject languageRepo;

// GUI components
ControlP5 cp5;
Button nextButton;
Button prevButton;
Button exitButton;

// Test images
PImage[] images;
float[] lineHeights = { 40, 20, 14, 10, 8, 6, 5, 4 };
int activeImage;

void setup() {
  size(900, 650);

  // load settings
  settings = loadJSONObject("settings.json");
  languageRepo = loadJSONObject(settings.getString("language") + ".json").getJSONObject("vat");

  // Callibration step so that we can display things using real mm dimensions
  HORIZONTAL_SCREEN_RESOLUTION = settings.getInt("horizontal_screen_resolution", -1);
  SCREEN_WIDTH = settings.getInt("screen_width", -1);

  if(HORIZONTAL_SCREEN_RESOLUTION <= 0 || SCREEN_WIDTH <= 0) {
    JOptionPane.showMessageDialog(null, i10n("message_missing_calibration_data"), i10n("title_missing_calibration_data"), JOptionPane.ERROR_MESSAGE);
    System.exit(0);
  }

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  nextButton = cp5.addButton("handler_nextBtn")
    .setSize(100, 50)
    .setPosition(width - 100, 0)
    .setCaptionLabel(i10n("button_next"));

  prevButton = cp5.addButton("handler_prevBtn")
    .setSize(100, 50)
    .setPosition(0, 0)
    .setCaptionLabel(i10n("button_previous"));

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel(i10n("button_end_test"));

  loadAndScaleImages();
  activeImage = 0;
}

void draw() {
  background(255);

  float imgX = (width - images[activeImage].width) / 2;
  float imgY = (height - images[activeImage].height) / 2;
  image(images[activeImage], imgX, imgY);
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

// next button handler to move to the next line image
void handler_nextBtn(){
  activeImage++;

  if(activeImage > (images.length-1)){
    activeImage = 0;
  }
}

// prev button handler to move to the previous line image
void handler_prevBtn(){
  activeImage--;

  if(activeImage < 0){
    activeImage = images.length - 1;
  }
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  int reply = JOptionPane.showConfirmDialog(null, i10n("prompt_confirm_exit"), i10n("title_confirm_exit"), JOptionPane.YES_NO_OPTION);
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

String i10n(String strKey) {
  return languageRepo.getString(strKey, "<unknown prompt: " + strKey + ">");
}
