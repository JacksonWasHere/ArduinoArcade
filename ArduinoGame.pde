int scale = 50; //<>//

//variables for game mechanics
int player[] = {0, 0};
int enemies[][] = new int[20][2];
int enemyMoveWait = 250;
int currentMoveWait = 0;
int enemySpawnWait = 500;
int currentSpawnWait = 0;
boolean alive = true;
//-----------variables for LCD screen and buttons-----------

//----------------------

void setup() {
  //initialize enemies
  for (int i = 0; i<enemies.length; i++){
    enemies[i][0] = -1;
    enemies[i][1] = -1;
  }
  //start timing
  currentMoveWait = millis(); 
  currentSpawnWait = millis();
  //-----------Initialize buttons/LCD-----------
  
  //----------------------
}

void loop() {
  if(alive){
    //-----------if statements to control player-----------
    /*
    if(upButtonPressed){
      if (player[1]>0)  player[1]--;
      reset();
    } else if(downButtonPressed){
      if (player[1]<3)  player[1]++;
      reset();
    }
    */
    //----------------------
    drawSprite(player,true); 
    //how long since last move
    int curWait = millis() - currentMoveWait; 
    for (int i = 0; i<enemies.length; i++) {
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
    text("YOU DEAD\nPRESS BUTTON FOR LIVE",width/2,height/2);
  }
}

void drawSprite(int[] sprite,boolean plays) {
  //-----------draw characters here-----------
  //plays means it's the player and sprite contains an x and y that are the players location
  //there is a possibility that the x or y will be negative
  //----------------------
}

void addEnemy() {
  //finds null enemy and uses that space for a new enemy
  for (int i = 0; i < enemies.length; i++) {
    if (enemies[i][0]== -1 && enemies[i][1] == -1) {
      enemies[i][0] = 16; 
      enemies[i][1] = (int)random(4.0);
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
    for (int i = 0; i<enemies.length; i++){
      enemies[i][0] = -1;
      enemies[i][1] = -1;
    }
    currentMoveWait = millis(); 
    currentSpawnWait = millis();
  }
}
