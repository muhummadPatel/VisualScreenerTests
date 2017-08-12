import javax.swing.JOptionPane;
import java.util.*;
import controlP5.*;

// GUI components
ControlP5 cp5;
Button exitButton;
ColorWheel redWheel, greenWheel;
ScrollableList languageDropdown;
Textfield screenResolutionInputTextField, screenWidthInputTextField;
Textlabel resolutionCallibrationInfoLabel;

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

// To show/not-show verification image for resolution callibration tab.
// Need to do this manually as there isn't another way to display non ControlP5
// elements on only a specific tab unfortunately.
boolean showResolutionCallibrationImage = false;
PImage resolutionCallibrationImage;
PVector resolutionCallibrationImagePos;

void setup() {
  size(900, 650);
  PVector center = new PVector(width/2, height/2);

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
    .setRGB(color(255, 0, 0))
    .setLabel("stereo red")
    .moveTo(TAB_COLOUR);

  greenWheel = cp5.addColorWheel("stereoGreen", colourWheelRightX, colourWheelYpos, COLOUR_WHEEL_R)
    .setRGB(color(0, 255, 0))
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

  languageDropdown = cp5.addScrollableList("languageDropdown")
    .setBarHeight(30)
    .setItemHeight(25)
    .setPosition((int)center.x - 75, TABS_HEIGHT + 125)
    .addItems(Arrays.asList("English", "isiZulu"))
    .setValue(0)
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
    .setText("1080")
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
    .setText("330")
    .setInputFilter(Textfield.INTEGER)
    .moveTo(TAB_RESOLUTION);

  resolutionCallibrationInfoLabel = cp5.addTextlabel("resolutionCallibrationInfoLabel")
    .setPosition(colourWheelLeftX, TABS_HEIGHT + 250)
<<<<<<< fc660c6379fa1cb4c7745656d5c7c6bd7fc6fa5e
    .setText("When properly callibrated, the line below should measure 150mm end-to-end:")
=======
    .setText("When properly callibrated, the line below should measure 100mm end-to-end:")
>>>>>>> Add resolution callibration verification image
    .setFont(createFont("", 20))
    .moveTo(TAB_RESOLUTION);
  resolutionCallibrationImagePos = new PVector(colourWheelLeftX, 360);
  resolutionCallibrationImage = loadImage("resolutionCallibrationImage.png");

  // global (all tabs) buttons---------------------------
  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Done")
    .moveTo(TAB_GLOBAL);
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isTab()) {
    if (theControlEvent.getTab().getName().equals(TAB_RESOLUTION)) {
      showResolutionCallibrationImage = true;
    } else {
      showResolutionCallibrationImage = false;
    }
  }
}

void draw() {
  background(125);

  if(showResolutionCallibrationImage) {
    try {
<<<<<<< fc660c6379fa1cb4c7745656d5c7c6bd7fc6fa5e
      resolutionCallibrationInfoLabel.setText("When properly callibrated, the line below should measure 150mm end-to-end:");

      image(fitImage(resolutionCallibrationImage, _mm(150), _mm(90)), resolutionCallibrationImagePos.x, resolutionCallibrationImagePos.y);
=======
      resolutionCallibrationInfoLabel.setText("When properly callibrated, the line below should measure 100mm end-to-end:");

      image(fitImage(resolutionCallibrationImage, _mm(100), _mm(90)), resolutionCallibrationImagePos.x, resolutionCallibrationImagePos.y);
>>>>>>> Add resolution callibration verification image
    } catch (IllegalArgumentException e) {
      // no-op. Don't display the image when the user is changing the value
      resolutionCallibrationInfoLabel.setText("Please check the values above");
    }
  }
}

// convert from a dimension in mm to screen pixels (based on callibration step)
int _mm(float mm){
  // pull these values fresh from the input fields so the user can verify that they work as expected
<<<<<<< fc660c6379fa1cb4c7745656d5c7c6bd7fc6fa5e
  int horizontalScreenResolution = Integer.parseInt(screenResolutionInputTextField.getText());
  int screenWidth = Integer.parseInt(screenWidthInputTextField.getText());

  if (horizontalScreenResolution < 150 || screenWidth < 100) {
=======
  int horizontalScreenResolution_input = Integer.parseInt(screenResolutionInputTextField.getText());
  int screenWidth_input = Integer.parseInt(screenWidthInputTextField.getText());

  if (horizontalScreenResolution_input < 150 || screenWidth_input < 100) {
>>>>>>> Add resolution callibration verification image
    throw new IllegalArgumentException("Screen dimensions too low. Can't resize!");
  }

  // divide by displayDensity to account for high-dpi displays (retina, etc.)
<<<<<<< fc660c6379fa1cb4c7745656d5c7c6bd7fc6fa5e
  return round(((0.1 * mm) * horizontalScreenResolution / (0.1 * screenWidth)) / displayDensity());
=======
  return round(((0.1 * mm) * horizontalScreenResolution_input / (0.1 * screenWidth_input)) / displayDensity());
>>>>>>> Add resolution callibration verification image
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
  String title = "Confirm Exit";
  String message = "Are you sure?";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}
