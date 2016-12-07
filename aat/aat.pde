import javax.swing.JOptionPane;

int HORIZONTAL_SCREEN_RESOLUTION;
int SCREEN_WIDTH;  // width in mm of the physical screen

PImage img;

void setup() {
  size(900, 650);

  HORIZONTAL_SCREEN_RESOLUTION = Integer.parseInt(JOptionPane.showInputDialog("Please enter the horizontal resolution of your screen:"));
  SCREEN_WIDTH = Integer.parseInt(JOptionPane.showInputDialog("Please enter the physical width of your screen in mm:"));

  img = loadImage("testImage.png");
  fitImage(img, _mm(100), _mm(80));
}

void draw() {
  background(125);

  // rect(_mm(10), _mm(10), _mm(100), _mm(50));
  image(img, 0, 0);
}

int _mm(float mm){
  // divide by displayDensity to account for high-dpi displays (retina, etc.)
  return (int)((0.1 * mm) * HORIZONTAL_SCREEN_RESOLUTION / (0.1 * SCREEN_WIDTH)) / displayDensity();
}

void fitImage(PImage image, int maxWidth, int maxHeight){
  image.resize(maxWidth, 0);
  if(image.height > maxHeight){
    image.resize(0, maxHeight);
  }
}
