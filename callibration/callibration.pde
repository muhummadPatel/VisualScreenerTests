import javax.swing.JOptionPane;
import controlP5.*;

// GUI components
ControlP5 cp5;
Button exitButton;


void setup() {
  size(900, 650);

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Done");
}

void draw() {
  background(125);
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
