import javax.swing.JOptionPane;
import java.util.*;
import controlP5.*;

// GUI components
ControlP5 cp5;
ColorWheel redWheel, greenWheel;
ScrollableList languageDropdown;
Textfield screenResolutionInputTextField, screenWidthInputTextField;
Textlabel resolutionCalibrationInfoLabel;

// Current settings loaded here
JSONObject oldSettings;

// vars to store the new setting values
int stereoRed, stereoGreen;
String language;
int horizontalScreenResolution, screenWidth;

static final int TABS_HEIGHT = 50;
static final int TABS_WIDTH = 150;
static final String TAB_GLOBAL = "global";
static final String TAB_COLOUR = "default";
static final String TAB_LANGUAGE = "language";
static final String TAB_RESOLUTION = "resolution";
static final int COLOUR_WHEEL_R = 300;

List<String> languages = Arrays.asList("english", "isizulu");

// To show/not-show verification image for resolution calibration tab.
// Need to do this manually as there isn't another way to display non ControlP5
// elements on only a specific tab unfortunately.
boolean showResolutionCalibrationImage = false;
PImage resolutionCalibrationImage;
PVector resolutionCalibrationImagePos;

void setup() {
  size(900, 650);
  PVector center = new PVector(width/2, height/2);

  // load old settings/default settings
  List<String> dataFiles = listFileNames(dataPath(""));
  if(dataFiles.contains("customSettings.json")) {
    oldSettings = loadJSONObject("customSettings.json");
  } else {
    oldSettings = loadJSONObject("defaultSettings.json");
  }

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  // colour settings tab---------------------------
  cp5.getTab(TAB_COLOUR)
    .activateEvent(true)
    .setLabel("Colour")
    .setId(1)
    .setWidth(TABS_WIDTH)
    .setHeight(TABS_HEIGHT);

  // adding in colour wheels and instruction text
  int colourWheelYpos = (int)(center.y - (COLOUR_WHEEL_R / 2));
  int colourWheelCenterPadding = 50;
  int colourWheelLeftX = (int)center.x - COLOUR_WHEEL_R - colourWheelCenterPadding;
  int colourWheelRightX = (int)center.x + colourWheelCenterPadding;

  cp5.addTextlabel("colourWheelInstructionLabel")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 75)
    .setText("Adjust the colours below to match your stereo glasses")
    .setFont(createFont("", 20))
    .moveTo(TAB_COLOUR);

  redWheel = cp5.addColorWheel("stereoRed", colourWheelLeftX, colourWheelYpos, COLOUR_WHEEL_R)
    .setRGB(oldSettings.getInt("stereoRed"))
    .setLabel("stereo red")
    .moveTo(TAB_COLOUR);

  greenWheel = cp5.addColorWheel("stereoGreen", colourWheelRightX, colourWheelYpos, COLOUR_WHEEL_R)
    .setRGB(oldSettings.getInt("stereoGreen"))
    .setLabel("stereo green")
    .moveTo(TAB_COLOUR);

  // Language settings tab---------------------------
  cp5.getTab(TAB_LANGUAGE)
    .activateEvent(true)
    .setLabel("Language")
    .setId(2)
    .setWidth(TABS_WIDTH)
    .setHeight(TABS_HEIGHT);

  cp5.addTextlabel("languageSelectionInstructionLabel")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 75)
    .setText("Please select the language to be used: ")
    .setFont(createFont("", 20))
    .moveTo(TAB_LANGUAGE);

  languageDropdown = cp5.addScrollableList("handler_languageDropdown")
    .setBarHeight(30)
    .setItemHeight(25)
    .setPosition((int)center.x - 75, TABS_HEIGHT + 125)
    .addItems(languages)
    .setValue(languages.indexOf(oldSettings.getString("language")))
    .open()
    .moveTo(TAB_LANGUAGE);

  // Resolution settings tab---------------------------
  cp5.getTab(TAB_RESOLUTION)
    .activateEvent(true)
    .setLabel("Resolution")
    .setId(3)
    .setWidth(TABS_WIDTH)
    .setHeight(TABS_HEIGHT);

  cp5.addTextlabel("screenResolutionInstructionLabel")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 35)
    .setText("Please enter the horizontal resolution of your screen:")
    .setFont(createFont("", 20))
    .moveTo(TAB_RESOLUTION);

  screenResolutionInputTextField = cp5.addTextfield("screenResolutionInputTextField")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 75)
    .setSize(200, 30)
    .setLabel("")
    .setFont(createFont("", 14))
    .setAutoClear(true)
    .setText("" + oldSettings.getInt("horizontalScreenResolution"))
    .setInputFilter(Textfield.INTEGER)
    .moveTo(TAB_RESOLUTION);

  cp5.addTextlabel("screenWidthInstructionLabel")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 150)
    .setText("Please enter the physical width of your screen in mm:")
    .setFont(createFont("", 20))
    .moveTo(TAB_RESOLUTION);

  screenWidthInputTextField = cp5.addTextfield("screenWidthInputTextField")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 190)
    .setSize(200, 30)
    .setLabel("")
    .setFont(createFont("", 14))
    .setAutoClear(true)
    .setText("" + oldSettings.getInt("screenWidth"))
    .setInputFilter(Textfield.INTEGER)
    .moveTo(TAB_RESOLUTION);

  resolutionCalibrationInfoLabel = cp5.addTextlabel("resolutionCalibrationInfoLabel")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 250)
    .setText("When properly calibrated, the line below should measure 100mm end-to-end:")
    .setFont(createFont("", 20))
    .moveTo(TAB_RESOLUTION);
  resolutionCalibrationImagePos = new PVector(colourWheelLeftX, 360);
  resolutionCalibrationImage = loadImage("resolutionCalibrationImage.png");

  // global (all tabs) buttons---------------------------
  cp5.addButton("handler_resetToDefault")
    .setSize(100, 50)
    .setPosition(0, height - 50)
    .setCaptionLabel("Reset to Defaults")
    .moveTo(TAB_GLOBAL);

  cp5.addButton("handler_saveBtn")
    .setSize(100, 50)
    .setPosition(width - 220, height - 50)
    .setCaptionLabel("Save Settings")
    .moveTo(TAB_GLOBAL);

  cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Exit")
    .moveTo(TAB_GLOBAL);
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    if (theControlEvent.getTab().getName().equals(TAB_RESOLUTION)) {
      showResolutionCalibrationImage = true;
    } else {
      showResolutionCalibrationImage = false;
    }
  }
}

void handler_languageDropdown(int n) {
  language = languages.get(n);
}

void draw() {
  background(125);

  if(showResolutionCalibrationImage) {
    try {
      resolutionCalibrationInfoLabel.setText("When properly calibrated, the line below should measure 100mm end-to-end:");

      image(fitImage(resolutionCalibrationImage, _mm(100), _mm(90)), resolutionCalibrationImagePos.x, resolutionCalibrationImagePos.y);
    } catch (IllegalArgumentException e) {
      // no-op. Don't display the image when the user is changing the value
      resolutionCalibrationInfoLabel.setText("Please check the values above");
    }
  }
}

// convert from a dimension in mm to screen pixels (based on calibration step)
int _mm(float mm){
  // pull these values fresh from the input fields so the user can verify that they work as expected
  horizontalScreenResolution = Integer.parseInt(screenResolutionInputTextField.getText());
  screenWidth = Integer.parseInt(screenWidthInputTextField.getText());

  if (horizontalScreenResolution < 150 || screenWidth < 100) {
    throw new IllegalArgumentException("Screen dimensions too low. Can't resize!");
  }

  // divide by displayDensity to account for high-dpi displays (retina, etc.)
  return round(((0.1 * mm) * horizontalScreenResolution / (0.1 * screenWidth)) / displayDensity());
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

// This function returns all the files in a directory as an array of Strings
List<String> listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    return Arrays.asList(file.list());
  } else {
    // If it's not a directory
    return null;
  }
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  exit();
}

void handler_saveBtn(){
  String title = "Save changes";
  String message = "Do you wnat to save your changes?";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    JSONObject newSettings = new JSONObject();

    newSettings.setInt("stereoRed", stereoRed);
    newSettings.setInt("stereoGreen", stereoGreen);
    newSettings.setString("language", language.toLowerCase());
    newSettings.setInt("horizontalScreenResolution", horizontalScreenResolution);
    newSettings.setInt("screenWidth", screenWidth);

    saveJSONObject(newSettings, "data/customSettings.json");
  }
}

void handler_resetToDefault(){
  String title = "Confirm Reset";
  String message = "This will reset all settings to their default values. Are you sure?";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    JSONObject defaultSettings = loadJSONObject("defaultSettings.json");

    redWheel.setRGB(defaultSettings.getInt("stereoRed"));
    greenWheel.setRGB(defaultSettings.getInt("stereoGreen"));

    languageDropdown.setValue(languages.indexOf(defaultSettings.getString("language"))).open();

    screenResolutionInputTextField.setText("" + defaultSettings.getInt("horizontalScreenResolution"));
    screenWidthInputTextField.setText("" + defaultSettings.getInt("screenWidth"));
  }
}
