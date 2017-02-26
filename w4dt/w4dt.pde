import javax.swing.JOptionPane;
import controlP5.*;

// GUI components
ControlP5 cp5;
Button startButton;
Button exitButton;
Textlabel instructionLabel;

// test state logic vars
boolean testRunning = false;
boolean testCompleted = false;

// Dot related vars
int spacing = 80; //spacing from centre
int radius = 40;
PVector[] positions = new PVector[4];
color[] colors = new color[4];

void setup() {
  size(900, 650);

  // Set up the buttons and labels
  cp5 = new ControlP5(this);

  startButton = cp5.addButton("handler_startBtn")
    .setSize(100, 50)
    .setPosition(0, 0)
    .setCaptionLabel("Start Test");

  startButton = cp5.addButton("handler_stopBtn")
    .setSize(100, 50)
    .setPosition(100, 0)
    .setCaptionLabel("Stop Test");

  exitButton = cp5.addButton("handler_exitBtn")
    .setSize(100, 50)
    .setPosition(width - 100, height - 50)
    .setCaptionLabel("Exit");

  // Set up the dots' positioning and colours
  testRunning = false;
  PVector center = new PVector(width/2, height/2);
  positions[0] = new PVector(center.x, center.y - spacing);
  positions[1] = new PVector(center.x + spacing, center.y);
  positions[2] = new PVector(center.x, center.y + spacing);
  positions[3] = new PVector(center.x - spacing, center.y);

  colors[0] = color(255, 0, 0);
  colors[1] = color(0, 255, 0);
  colors[2] = color(255, 255, 255);
  colors[3] = color(0, 255, 0);
}

void draw() {
  background(0);

  if(testRunning){
    for(int i = 0; i < positions.length; i++){
      noStroke();
      fill(colors[i]);

      ellipse(positions[i].x, positions[i].y, radius, radius);
    }
  }
}

// start button handler to start the test
void handler_startBtn(){
  testRunning = true;
}

// stop button handler to stop the test
void handler_stopBtn(){
  testRunning = false;
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
