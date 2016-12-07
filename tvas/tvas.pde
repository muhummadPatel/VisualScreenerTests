import java.util.*;
import javax.swing.JOptionPane;
import controlP5.*;


final int SKETCH_WIDTH = 900;
final int SKETCH_HEIGHT = 650;

ControlP5 cp5;
String[] buttonBarLabels = {
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
};
final int BUTTON_BAR_HEIGHT = 50;

PImage[] images;
int activeImage;
final int IMAGE_DISPLAY_SIZE = 500;
int x1, y1;

void settings(){
  size(SKETCH_WIDTH, SKETCH_HEIGHT);
}

void setup() {
  cp5 = new ControlP5(this);

  ButtonBar buttonBar = cp5.addButtonBar("handler_buttonBar")
    .setPosition(0, 0)
    .setSize(SKETCH_WIDTH, BUTTON_BAR_HEIGHT)
    .addItems(buttonBarLabels);

  images = new PImage[buttonBarLabels.length];
  for(int i = 0; i < images.length; i++){
    images[i] = loadImage((i + 1) + ".png");
  }
  x1 = (SKETCH_WIDTH - IMAGE_DISPLAY_SIZE) / 2;
  y1 = (SKETCH_HEIGHT - IMAGE_DISPLAY_SIZE) / 2;

  activeImage = 0;
  List<HashMap> buttonBarItems = buttonBar.getItems();
  buttonBarItems.get(activeImage).put("selected", true);
}

void draw() {
  background(125);

  image(images[activeImage], x1, y1, IMAGE_DISPLAY_SIZE, IMAGE_DISPLAY_SIZE);
}

void handler_buttonBar(int buttonValue) {
  activeImage = buttonValue;
}
