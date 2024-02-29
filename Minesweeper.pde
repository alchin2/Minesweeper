import de.bezier.guido.*;
import java.util.ArrayList;

public static final int NUM_ROWS = 10;
public static final int NUM_COLS = 10;
public static final int NUM_MINES = 10;

private MSButton[][] buttons; 
private ArrayList<MSButton> mines;

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);


  Interactive.make(this);
  mines = new ArrayList<MSButton>();
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  setMines();
}

public void setMines() {
  for (int i = 0; i < NUM_MINES; i++) {
    int row = (int) (Math.random() * NUM_ROWS);
    int col = (int) (Math.random() * NUM_COLS);
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
    }
  }
}

public void draw() {
  background(0);
  if (isWon()) {
    displayWinningMessage();
  }
}

public boolean isWon() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!mines.contains(buttons[r][c]) && !buttons[r][c].isClicked()) {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage() {
  for (MSButton mine : mines) {
    mine.setLabel("YOU LOSE!");
  }
}

public void displayWinningMessage() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setLabel("Win!");
    }
  }
}




public boolean isValid(int r, int c)
{
  if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS) {
    return true;
  }
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row - 1; i <= row + 1; i++) {
    for (int j = col - 1; j <= col + 1; j++) {
      if (isValid(i, j) && mines.contains(buttons[i][j])) {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false){clicked = false;}
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol)>0) {
      setLabel(" "+countMines(myRow, myCol));
    }else{
    for (int i = myRow - 1; i <= myRow + 1; i++) {
    for (int j = myCol - 1; j <= myCol + 1; j++) {
      if (isValid(i, j) && buttons[i][j].isClicked()==false) {
        buttons[i][j].mousePressed();
      }
    }
  }}
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
 public boolean isClicked() {
    return clicked;
  }
}
