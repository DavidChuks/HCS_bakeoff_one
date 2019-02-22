import java.awt.AWTException;
import java.awt.Rectangle;
import java.awt.Robot;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;

//when in doubt, consult the Processsing reference: https://processing.org/reference/

int margin = 200; //set the margin around the squares
final int padding = 50; // padding between buttons and also their width/height
final int buttonSize = 40; // padding between buttons and also their width/height
ArrayList<Integer> trials = new ArrayList<Integer>(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
int hits = 0; //number of successful clicks
int misses = 0; //number of missed clicks
int mouseR = 15; // Radius of red dot on cursor
color gray = color(128,128,128);
color red = color(255,0,0);
color green = color(0,255,0);
color mouseC = red;
int inc = 1;
Robot robot; //initalized in setup
int row = 0;
int currentRow = -1;

int numRepeats = 1; //sets the number of times each button repeats in the test

void setup()
{
  size(700, 700); // set the size of the window
  noCursor(); //hides the system cursor if you want
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  textFont(createFont("Arial", 16)); //sets the font to Arial size 16
  textAlign(CENTER);
  frameRate(60);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  //rectMode(CENTER); //enabling will break the scaffold code, but you might find it easier to work with centered rects

  try {
    robot = new Robot(); //create a "Java Robot" class that can move the system cursor
  }
  catch (AWTException e) {
    e.printStackTrace();
  }

  //===DON'T MODIFY MY RANDOM ORDERING CODE==
  for (int i = 0; i < 16; i++) //generate list of targets and randomize the order
      // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);

  frame.setLocation(0,0); // put window in top left corner of screen (doesn't always work)
}


void draw()
{
  background(0); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    float timeTaken = (finishTime-startTime) / 1000f;
    float penalty = constrain(((95f-((float)hits*100f/(float)(hits+misses)))*.2f),0,100);
    fill(255); //set fill color to white
    //write to screen (not console)
    text("Finished!", width / 2, height / 2);
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + timeTaken + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + nf((timeTaken)/(float)(hits+misses),0,3) + " sec", width / 2, height / 2 + 100);
    text("Average time for each button + penalty: " + nf(((timeTaken)/(float)(hits+misses) + penalty),0,3) + " sec", width / 2, height / 2 + 140);
    return; //return, nothing else to do now test is over
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on

  for (int i = 0; i < 16; i++)// for all button
    drawButton(i); //draw button

  fill(mouseC, 200); // set fill color to translucent red
  ellipse(mouseX, mouseY, mouseR * 2, mouseR * 2); //draw user cursor as a circle with a diameter of 40
}

void mousePressed() // test to see if hit was in target!
{
  pressBox(-1);
}

//probably shouldn't have to edit this method
Rectangle getButtonLocation(int i) //for a given button ID, what is its location and size
{
   int x = (i % 4) * (padding + buttonSize) + margin;
   int y = (i / 4) * (padding + buttonSize) + margin;
   
   return new Rectangle(x, y, buttonSize, buttonSize);
}

//you can edit this method to change how buttons appear
void drawButton(int i)
{
   if(inc >4)
  inc=1;
  Rectangle bounds = getButtonLocation(i);

  if (trials.get(trialNum) == i) // see if current button is the target
  {
    //if i is between 0 and 4
    if (i >= currentRow *4 && i < currentRow*4+4)
    fill(255,165,0);
    else
    fill(0);
    text(inc++ , bounds.x + bounds.width/2, bounds.y-5 );
    
    fill(255,165,0); // if so, fill orange
    rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
  }
  else
  {
    //if i is between 0 and 4
    if (i >= currentRow*4 && i < currentRow*4+4)
    fill(200);
    else
    fill(0);
    
    text(inc++ , bounds.x + bounds.width/2, bounds.y-5 );
    
    fill(200); // if not, fill gray
    rect(bounds.x, bounds.y, bounds.width, bounds.height); //draw button
  }

  
}

void mouseMoved()
{
   if (trialNum >= trials.size()) return;
   //can do stuff everytime the mouse is moved (i.e., not clicked)
   //https://processing.org/reference/mouseMoved_.html
   Rectangle bounds = getButtonLocation(trials.get(trialNum));
   //check to see if mouse cursor is inside button
  //if (mouseX + mouseR > bounds.x && mouseY + mouseR > bounds.y &&
  //    mouseX - mouseR < bounds.x + bounds.width && mouseY - mouseR < bounds.y + bounds.height) // test to see if hit was within bounds
  //{
  //  mouseC = green;
  //}
  //else {
  //  mouseC = gray;
  //}
  
  currentRow = findCurrentRow();
}

int findCurrentRow()
{
  int rowHeight = padding/2;
  
  for (int i = 0; i < 4; i++) {
    int y = i * (padding + buttonSize) + margin;
    if (mouseY >= y-rowHeight && mouseY < y+buttonSize+rowHeight) {
      return i;
    }
  }
  return -1;
}

void mouseDragged()
{
  //can do stuff everytime the mouse is dragged
  //https://processing.org/reference/mouseDragged_.html
}

void keyPressed()
{
  int numCode = 48;
  //can use the keyboard if you wish
  //https://processing.org/reference/keyTyped_.html
  //https://processing.org/reference/keyCode.html
  if (keyCode == SHIFT) {
    pressBox(-1);
  }
  else if (currentRow >= 0 && (keyCode >= numCode+1 && keyCode <= numCode+4)) {
    pressBox(keyCode-numCode-1);
  }
}

void pressBox(int keyColumn) {
  if (trialNum >= trials.size()) //if task is over, just return
      return;

    if (trialNum == 0) //check if first click, if so, start timer
      startTime = millis();

    if (trialNum == trials.size() - 1) //check if final click
    {
      finishTime = millis();
      //write to terminal some output. Useful for debugging too.
      println("we're done!");
    }

    Rectangle bounds = getButtonLocation(trials.get(trialNum));

   // If key input for column is specified.
   if (keyColumn >= 0) {
     int clickedBox = currentRow * 4 + keyColumn;
     if (trials.get(trialNum) == clickedBox) {
       System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
       hits++;
     }
     else {
       System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
        misses++;
     }
   }
   
   else {
     
     //check to see if mouse cursor is inside button
     if (mouseX + mouseR > bounds.x && mouseY + mouseR > bounds.y &&
        mouseX - mouseR < bounds.x + bounds.width && mouseY - mouseR < bounds.y + bounds.height) // test to see if hit was within bounds
      {
        System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
        hits++;
      }
      else
      {
        System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
        misses++;
      }
   }
   trialNum++; //Increment trial number
   mouseMoved();
}
