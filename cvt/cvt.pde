import java.util.*;
import javax.swing.JOptionPane;
import controlP5.*;


// sketch dimensions
final int SKETCH_WIDTH = 900;
final int SKETCH_HEIGHT = 650;

// GUI related vars
ControlP5 cp5;
final int IMAGE_DISPLAY_SIZE = 600;
int x1, y1;

// Test image
PImage test_image;


void settings(){
  size(SKETCH_WIDTH, SKETCH_HEIGHT);
}

void setup() {
  cp5 = new ControlP5(this);

  test_image = loadImage("butterfly.png");

  //add the exit button
  Button exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(SKETCH_WIDTH - 100, SKETCH_HEIGHT - 50)
    .setCaptionLabel("Exit");

  // computing the x and y co-ords of the top corner where the images should
  // be displayed. Tries to center the image in the sketch.
  x1 = (SKETCH_WIDTH - IMAGE_DISPLAY_SIZE) / 2;
  y1 = (SKETCH_HEIGHT - IMAGE_DISPLAY_SIZE) / 2;
}

void draw() {
  background(125);

  image(test_image, x1, y1, IMAGE_DISPLAY_SIZE, IMAGE_DISPLAY_SIZE);
}

// exit button handler terminates the sketch
void handler_exitBtn(){
  String title = "Confirm Exit";
  String message = "Are you sure you want to exit this test?";
  int reply = JOptionPane.showConfirmDialog(null, message, title, JOptionPane.YES_NO_OPTION);
  if(reply == JOptionPane.YES_OPTION){
    exit();
  }
}
