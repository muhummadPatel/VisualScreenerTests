import javax.swing.JOptionPane;

int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

void setup() {
  size(900, 650);

  HORIZONTAL_SCREEN_RESOLUTION = Integer.parseInt(JOptionPane.showInputDialog("Please enter the horizontal resolution of your screen:"));
  SCREEN_WIDTH = Integer.parseInt(JOptionPane.showInputDialog("Please enter the physical width of your screen in mm:"));
}

float cmToPx(float cm){
  // divide by displayDensity to account for high-dpi displays (retina, etc.)
  return (cm * HORIZONTAL_SCREEN_RESOLUTION / (0.1 * SCREEN_WIDTH)) / displayDensity();
}

void draw() {
  background(125);

  float a = cmToPx(1);
  float b = cmToPx(5);
  rect(a, a, b, b);
}
