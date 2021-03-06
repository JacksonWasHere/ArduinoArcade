#include <LiquidCrystal.h>

//variables for game mechanics
int player[] = {
  0, 0};
int enemies[20][2];
int coins[20][2];
int enemyMoveWait = 600;
int currentMoveWait = 0;
int enemySpawnWait = 2500;
int currentSpawnWait = 0;
boolean alive = true;
int distance = 0;
int score = 0;

byte customChar1[8] {
  B10000,
  B11000,
  B10100,
  B11111,
  B10100,
  B11000,
  B10000,
  B00000,
};

byte customChar2[8] {
  B00000,
  B01110,
  B11111,
  B11111,
  B11111,
  B11111,
  B01110,
  B00000,
};

byte customChar3[8] {
  B00000,
  B00000,
  B00000,
  B00100,
  B01110,
  B00100,
  B00000,
  B00000,
};


//-----------variables for LCD screen and buttons-----------
LiquidCrystal lcd(A0,A1,A2,A3,A4,A5);
const int dButton = 12;
const int uButton = 11;
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
  } 
  else if(digitalRead(uButton) == HIGH){
    if (player[1]>0){
      player[1]--;
    }
    reset();
  }
  if(alive){
    update();
  }
  else {
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("YOU DEAD. PRESS");
    lcd.setCursor(0,1);
    lcd.print("BUTTON FOR LIVE");
  }

  delay(10);
}

void update(){
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


        lcd.createChar(1, customChar1);
        lcd.createChar(2, customChar2);
      } 
      else {
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
}

void drawSprite(int sprite[],bool plays) {
  //-----------draw characters here-----------
  //plays means it's the player and sprite contains an x and y that are the players location
  //there is a possibility that the x or y will be negative  

  lcd.createChar(1, customChar1);
  lcd.createChar(2, customChar2);

  if(sprite[0]>=0 && sprite[1]>=0){
    lcd.setCursor(sprite[0],sprite[1]);

    if (plays){
      lcd.write(1);
    }
    else{
      lcd.write(2);

      //
      //      distance++;
      //      if (distance%2)
      //        score++;
      //      byte digits = (score > 9999) ? 5 : (score > 999) ? 4 : (score > 99) ? 3 : (score > 9) ? 2 : 1;  
      //      lcd.setCursor(16 - digits, 0);
      //      lcd.print(score);



    }
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
    //score = 0;
    for (int i = 0; i<20; i++){
      enemies[i][0] = -1;
      enemies[i][1] = -1;
    }
    currentMoveWait = millis(); 
    currentSpawnWait = millis();
  }
}

