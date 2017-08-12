import javax.swing.JOptionPane;
import controlP5.*;

// GUI components
ControlP5 cp5;
Button exitButton;
ColorWheel redWheel, greenWheel;

int stereoRed;
int stereoGreen;

static final int TAB_HEIGHT = 25;
static final int COLOUR_WHEEL_R = 300;


void setup() {
  size(900, 650);
  PVector center = new PVector(width/2, height/2);

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("Colour")
     .setId(1)
     .setHeight(TAB_HEIGHT);

  int colourWheelYpos = (int)(center.y - (COLOUR_WHEEL_R / 2));
  int colourWheelCenterPadding = 50;
  int colourWheelLeftX = (int)center.x - COLOUR_WHEEL_R - colourWheelCenterPadding;
  int colourWheelRightX = (int)center.x + colourWheelCenterPadding;
  redWheel = cp5.addColorWheel("stereoRed", colourWheelLeftX, colourWheelYpos, COLOUR_WHEEL_R)
    .setRGB(color(255, 0, 0))
    .setLabel("stereo red")
    .moveTo("default");

  greenWheel = cp5.addColorWheel("stereoGreen", colourWheelRightX, colourWheelYpos, COLOUR_WHEEL_R)
    .setRGB(color(0, 255, 0))
    .setLabel("stereo green")
    .moveTo("default");

    cp5.addTextlabel("colourWheelInstructionLabel")
      .setPosition(colourWheelLeftX, TAB_HEIGHT + 75)
      .setText("Adjust the colours below to match your stereo glasses")
      .setFont(createFont("", 20));


  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Done")
    .moveTo("global");
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
