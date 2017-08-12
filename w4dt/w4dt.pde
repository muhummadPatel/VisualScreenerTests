import javax.swing.JOptionPane;
import controlP5.*;


// settings
JSONObject settings;
JSONObject languageRepo;

// GUI components
ControlP5 cp5;
Button startButton;
Button exitButton;

// test state logic vars
boolean testRunning = false;
boolean testCompleted = false;

// Dot related vars
int spacing = 90; //spacing from centre
int radius = 55;
PVector[] positions = new PVector[4];
color[] colors = new color[4];
PImage imageMask;


void setup() {
  size(900, 650);

  // load settings
  settings = loadJSONObject("settings.json");
  languageRepo = loadJSONObject(settings.getString("language") + ".json").getJSONObject("w4dt");

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  startButton = cp5.addButton("handler_startBtn")
    .setSize(100, 50)
    .setPosition(0, 0)
    .setCaptionLabel(i10n("button_show_test"));

  startButton = cp5.addButton("handler_stopBtn")
    .setSize(100, 50)
    .setPosition(100, 0)
    .setCaptionLabel(i10n("button_hide_test"));

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel(i10n("button_end_test"));

  int white = color(255, 255, 255);
  int red = settings.getInt("stereo_red", color(255, 0, 0));
  int green = settings.getInt("stereo_green", color(0, 255, 0));
  colors[0] = red;
  colors[1] = green;
  colors[2] = white;
  colors[3] = green;

  // Image is just used as a mask. Colour is controlled by tinting with the
  // values defined above
  imageMask = loadImage("white.png");
  imageMask.resize(0, radius);

  // Set up the dots' positioning and colours
  testRunning = false;
  PVector center = new PVector(width/2 - imageMask.width/2, height/2 - imageMask.height/2);
  positions[0] = new PVector(center.x, center.y - spacing);
  positions[1] = new PVector(center.x + spacing, center.y);
  positions[2] = new PVector(center.x, center.y + spacing);
  positions[3] = new PVector(center.x - spacing, center.y);
}

void draw() {
  background(0);

  if(testRunning){
    for(int i = 0; i < positions.length; i++){
      noStroke();
      tint(colors[i]);
      image(imageMask, positions[i].x, positions[i].y);
    }
  }
}

// start button handler to start the test
void handler_startBtn(){
  testRunning = true;
}

// stop button handler to stop the test
void handler_stopBtn(){
  testRunning = false;
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  String title = "Confirm Exit";
  String message = "Are you sure you want to end this test?";
  int reply = JOptionPane.showConfirmDialog(null, i10n("prompt_confirm_exit"), i10n("title_confirm_exit"), JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}

String i10n(String strKey) {
  return languageRepo.getString(strKey, "<unknown prompt: " + strKey + ">");
}
