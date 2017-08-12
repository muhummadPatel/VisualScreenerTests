import javax.swing.JOptionPane;
import java.util.*;
import controlP5.*;

// GUI components
ControlP5 cp5;
Button exitButton;
ColorWheel redWheel, greenWheel;
ScrollableList languageDropdown;

int stereoRed;
int stereoGreen;

static final int TABS_HEIGHT = 50;
static final int TABS_WIDTH = 150;
static final String TAB_GLOBAL = "global";
static final String TAB_COLOUR = "default";
static final String TAB_LANGUAGE = "language";
static final int COLOUR_WHEEL_R = 300;


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

  // global (all tabs) buttons---------------------------
  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Done")
    .moveTo(TAB_GLOBAL);
}

void draw() {
  background(125);

  fill(redWheel.getRGB());
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
