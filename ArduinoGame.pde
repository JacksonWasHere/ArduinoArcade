#include <LiquidCrystal.h>

//variables for game mechanics
int player[] = {0, 0};
int enemies[20][2];
int enemyMoveWait = 800;
int currentMoveWait = 0;
int enemySpawnWait = 2000;
int currentSpawnWait = 0;
boolean alive = true;

//-----------variables for LCD screen and buttons-----------
LiquidCrystal lcd(12,11,5,4,3,2);
const int dButton = 6;
const int uButton = 7;
//----------------------
void setup() {
  //initialize enemies
  for (int i = 0; i<20; i++){
    enemies[i][0] = -1;
    enemies[i][1] = -1;
  }
  //start timing
  currentMoveWait = millis(); 
  currentSpawnWait = millis();
  //-----------Initialize buttons/LCD-----------
  lcd.begin(16, 2);
  lcd.clear();
  pinMode(dButton,INPUT);
  pinMode(uButton,INPUT);
  //----------------------
}

void loop() {
  if(digitalRead(dButton) == HIGH){
      if (player[1]<1){
        player[1]++;
      }
      reset();
    } else if(digitalRead(uButton) == HIGH){
      if (player[1]>0){
        player[1]--;
      }
      reset();
    }
  if(alive){
    //-----------if statements to control player-----------
    
    //----------------------
    lcd.clear();
    drawSprite(player,true); 
    //how long since last move
    int curWait = millis() - currentMoveWait; 
    for (int i = 0; i<20; i++) {
      drawSprite(enemies[i],false); 
      //if it's time to move then move the enemy backwards or put it in null position if out of bounds
      if (curWait > enemyMoveWait) {
        if (enemies[i][0]>=0) {
          enemies[i][0]--;
        } else {
          enemies[i][0] = -1;
          enemies[i][1] = -1;
        }
        //reset timer
        currentMoveWait = millis();
      }
      //if hit then kill the player
      if(enemies[i][0] == player[0] && enemies[i][1] == player[1]){
        alive = false;
      }
    }
    //check if it's time to spawn a new enemy
    if (millis() - currentSpawnWait > enemySpawnWait) {
      addEnemy();
      currentSpawnWait = millis();
    }
  } else {
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("YOU DEAD. PRESS");
    lcd.setCursor(0,1);
    lcd.print("BUTTON FOR LIVE");
  }
  delay(10);
}
void drawSprite(int sprite[],bool plays) {
  //-----------draw characters here-----------
  //plays means it's the player and sprite contains an x and y that are the players location
  //there is a possibility that the x or y will be negative
  //----------------------
  if(sprite[0]>=0 && sprite[1]>=0){
    lcd.setCursor(sprite[0],sprite[1]);
    lcd.write(plays?'P':'E');
  }
}

void addEnemy() {
  //finds null enemy and uses that space for a new enemy
  for (int i = 0; i < 20; i++) {
    if (enemies[i][0]== -1 && enemies[i][1] == -1) {
      enemies[i][0] = 16; 
      enemies[i][1] = (int)random(2);
      return;
    }
  }
}
void reset(){
  //if dead then we reset all values and restart the game
  if(!alive){
    alive = true;
    player[0] = 0;
    player[1] = 0;
    for (int i = 0; i<20; i++){
      enemies[i][0] = -1;
      enemies[i][1] = -1;
    }
    currentMoveWait = millis(); 
    currentSpawnWait = millis();
  }
}
