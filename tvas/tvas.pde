import java.util.*;
import javax.swing.JOptionPane;
import controlP5.*;


// sketch dimensions
final int SKETCH_WIDTH = 900;
final int SKETCH_HEIGHT = 650;

// GUI related vars
ControlP5 cp5;
String[] buttonBarLabels = {
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
};
final int BUTTON_BAR_HEIGHT = 50;
List<HashMap> buttonBarItems;

// Test images
PImage[] images;
int activeImage;
final int IMAGE_DISPLAY_SIZE = 500;
int x1, y1;


void settings(){
  size(SKETCH_WIDTH, SKETCH_HEIGHT);
}

void setup() {
  cp5 = new ControlP5(this);

  // add the button bar
  ButtonBar buttonBar = cp5.addButtonBar("handler_buttonBar")
    .setPosition(0, 0)
    .setSize(SKETCH_WIDTH, BUTTON_BAR_HEIGHT)
    .addItems(buttonBarLabels);

  // add the next and prev buttons
  Button prevButton = cp5.addButton("handler_prevBtn")
    .setSize(100, 50)
    .setPosition(0, BUTTON_BAR_HEIGHT)
    .setCaptionLabel("Previous");

  Button nextButton = cp5.addButton("handler_nextBtn")
    .setSize(100, 50)
    .setPosition(SKETCH_WIDTH - 100, BUTTON_BAR_HEIGHT)
    .setCaptionLabel("Next");

  //add the exit button
  Button exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(SKETCH_WIDTH - 100, SKETCH_HEIGHT - 50)
    .setCaptionLabel("End Test");

  // load all test images (assumes they are named 1.png, 2.png, etc.)
  images = new PImage[buttonBarLabels.length];
  for(int i = 0; i < images.length; i++){
    images[i] = loadImage((i + 1) + ".png");
  }

  // computing the x and y co-ords of the top corner where the images should
  // be displayed. Tries to center the image in the sketch.
  x1 = (SKETCH_WIDTH - IMAGE_DISPLAY_SIZE) / 2;
  y1 = (SKETCH_HEIGHT - IMAGE_DISPLAY_SIZE) / 2;

  // set the current activeImage to 0th image and set the 0th button in the
  // button bar to be selected.
  activeImage = 0;
  buttonBarItems = buttonBar.getItems();
  buttonBarItems.get(activeImage).put("selected", true);
}

void draw() {
  background(125);

  image(images[activeImage], x1, y1, IMAGE_DISPLAY_SIZE, IMAGE_DISPLAY_SIZE);
}

// button bar handler to update the current activeImage index.
void handler_buttonBar(int buttonValue) {
  activeImage = buttonValue;
}

// button handler for the 'previous' button.
void handler_prevBtn(){
  if(activeImage > 0){
    buttonBarItems.get(activeImage).put("selected", false);
    activeImage--;
    buttonBarItems.get(activeImage).put("selected", true);
  }
}

// button handler for the 'next' button.
void handler_nextBtn(){
  if(activeImage < buttonBarItems.size() - 1){
    buttonBarItems.get(activeImage).put("selected", false);
    activeImage++;
    buttonBarItems.get(activeImage).put("selected", true);
  }
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  String title = "Confirm Exit";
  String message = "Are you sure you want to end this test?";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}

// exit handler called before the sketch closed. Prints out the report to
// report.txt. It prints the last plate on the screen (best guess of where the user stopped)
void dispose(){
  // add 1 to account for 0 indexing
  int lastImage = activeImage + 1;

  String[] report = new String[1];
  report[0] = "last displayed plate: " + lastImage;

  saveStrings("report.txt", report);
}
