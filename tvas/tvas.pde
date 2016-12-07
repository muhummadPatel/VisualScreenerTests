import java.util.*;
import javax.swing.JOptionPane;
import controlP5.*;

ControlP5 cp5;
String[] buttonBarLabels = {
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"
};

void setup() {
  size(900, 650);

  cp5 = new ControlP5(this);

  ButtonBar buttonBar = cp5.addButtonBar("handler_buttonBar")
    .setPosition(0, 0)
    .setSize(900, 40)
    .addItems(buttonBarLabels);

  List<HashMap> buttonBarItems = buttonBar.getItems();
  buttonBarItems.get(0).put("selected", true);
}

void draw() {
  background(125);
}

void handler_buttonBar(int buttonIndex) {
  println("bar clicked, item-value:", buttonBarLabels[buttonIndex]);
}
