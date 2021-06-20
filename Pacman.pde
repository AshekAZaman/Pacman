/*
*/

//The variables that control everything known about the pacman
float pacmanX, pacmanY;         //The position of the pacman
final int PACMAN_DIAMETER = 50; //The diameter of the pacman
float pacmanAngle = 0.0;        //The direction the pacman is facing
float pacmanMouth = 0.0;        //The angle that the mouth is open

/*Constants*/
final int SPEED = 2;//constant speed for the pacman
//Constants for direction
final int MOVERIGHT = 0;
final int MOVEDOWN = 1;
final int MOVELEFT = 2;
final int MOVEUP = 3;
//Constants for Enemy
final int ENEMY_WIDTH = PACMAN_DIAMETER + PACMAN_DIAMETER / 2;



/*Variables*/
int direction = 0;
float randomColor = 0;
float randomShape = 0;
float treatX = 0.0;
float treatY = 0.0;
int score = 0;

//Variables for Enemy
float enemyX,enemyY;
float eyeballAngle = 0.0;
float xSpeed = 2;
float ySpeed = 0;
int counter;
float speedAngle = 0;
boolean gameOver = false;




 
void moveEnemy() {
    
    counter = (counter + 1) % 501;
    
    if (counter ==  500) {
        speedAngle = random(0,TWO_PI);
        xSpeed = 2 * sin(speedAngle);
        ySpeed = 2 * cos(speedAngle);
    }
    
    if (enemyX > width) {
        enemyX = 0;
    } else if (enemyX < 0) {
        enemyX = width;
    }
    
    if (enemyY > height) {
        enemyY = 0;
    } else if (enemyY < 0) {
        enemyY = height;
    }
    
    enemyX = (enemyX + xSpeed);
    enemyY = (enemyY + ySpeed);
    
}
void drawEnemy() {
    
    strokeWeight(4);
    fill(3, 252, 252);
    square(enemyX,enemyY,ENEMY_WIDTH);
    
    //eye
    int whiteDiam = ENEMY_WIDTH / 3;
    
    
    float whiteDiamLeftX = enemyX + whiteDiam / 1.5;
    float whiteDiamLeftY = enemyY + whiteDiam / 1.5;
    float whiteDiamRightX = enemyX + 2.2 * whiteDiam;
    float whiteDiamRightY = whiteDiamLeftY;
    
    
    
    fill(255,255,255);
    ellipse(whiteDiamLeftX,whiteDiamLeftY,whiteDiam,whiteDiam);
    ellipse(whiteDiamRightX,whiteDiamRightY,whiteDiam,whiteDiam);
    //eyeball
    eyeballAngle = atan2(pacmanY - 2 * enemyY,pacmanX - 2 * enemyX);
    int blackDiam = whiteDiam / 4;
    float blackDiamLeftX = whiteDiamLeftX;
    float blackDiamLeftY = whiteDiamLeftY;
    float blackDiamRightX = blackDiamLeftX + (6.5 * blackDiam);
    float blackDiamRightY = blackDiamLeftY;
    eyeballAngle = atan2(pacmanY - blackDiamLeftY,pacmanX - blackDiamLeftX);
    fill(0);
    ellipse(blackDiamRightX - eyeballAngle,blackDiamRightY + eyeballAngle,blackDiam,blackDiam);
    ellipse(blackDiamLeftX - eyeballAngle,blackDiamLeftY + eyeballAngle,blackDiam,blackDiam);
    
    
}

void drawScore() {
    final int MARGIN = 30;
    textSize(20);
    fill(0);
    text("Score : " + score, MARGIN, MARGIN);
}

void eatTreat() {
    
    float distance = sqrt(sq(pacmanX - treatX) + sq(pacmanY - treatY));
    if (distance < PACMAN_DIAMETER / 2) {
        generateTreat();
        score++;
    }
    
    
} //eatTreat

// Draw a treat roughly centred at the treat’s x and y coordinates
void drawTreat() {
    fill(randomColor);  
    if ((int)randomShape == 0) {
        circle(treatX, treatY, PACMAN_DIAMETER / 2);
    } else if ((int)randomShape == 1) {
        square(treatX, treatY, PACMAN_DIAMETER / 2);
    }
    else if ((int)randomShape == 2) {   
        triangle(treatX, treatY,treatX + PACMAN_DIAMETER / 2, treatY + PACMAN_DIAMETER / 2, treatX - PACMAN_DIAMETER / 2, treatY + PACMAN_DIAMETER / 2);
    }
    
} //drawTreat


void endGame() {
    
    float distance = sqrt(sq(pacmanX - (enemyX + ENEMY_WIDTH / 2)) + sq(pacmanY - (enemyY + ENEMY_WIDTH / 2)));
    boolean condition = distance <((PACMAN_DIAMETER / 2) + (ENEMY_WIDTH / 2));    
    
    if (condition) {
        gameOver = true;
        fill(0);
        textSize(100);
        textAlign(CENTER,CENTER);
        text("Game Over!",width / 2,height / 2);
    }
}


//Sets treatX and treatY to a random value that is
//never closer than PACMAN_DIAMETER pixels to any edge of the canvas.
void generateTreat() {
    
    treatX = random(0 + PACMAN_DIAMETER,width - PACMAN_DIAMETER);
    treatY = random(0 + PACMAN_DIAMETER,height - PACMAN_DIAMETER);
    randomShape = random(0,3);
    randomColor = random(0,255);
    
} //generateTreat

void setup() {
    size(500,500);
    pacmanX = width / 2;  //Start the pacman in the
    pacmanY = height / 2; //centre of the canvas
    enemyX = (width / 2) - (width / 3);
    enemyY = (height / 2) - (height / 4);    
    generateTreat();    
}


void draw() {
    background(128); //draw a fresh frame eachtime
    drawTreat();
    eatTreat();
    if (gameOver == false) {
        movePacman();    //Move the pacman toward the mouse
        moveEnemy();
        turnPacman();    //Turn it to face the mouse
        animateMouth();  //Make the mouth open and close        
    }
    drawPacman();    //And draw it
    drawScore();
    drawEnemy();
    endGame();    
}

void drawPacman() {
    /* Draw an arc filled with yellow to represent a "pacman".It will
    be drawn at position(pacmanX,pacmanY) with a diameter of
    PACMAN_DIAMETER.It will face in the direction
    given by pacmanAngle, and the mouth will be open atan angle of
    pacmanMouth.Thisangle will increase by PACMAN_MOUTH_SPEED radians each
    frame, until it reaches PACMAN_MAX_MOUTH, and snapsshut.
    */  
    fill(255,255,0);//yellow pacman
    stroke(0);  //with a black outline
    strokeWeight(2); //that's a little thicker
    //Use the arc command to draw it
    arc(pacmanX,pacmanY, PACMAN_DIAMETER, PACMAN_DIAMETER,
        pacmanAngle + pacmanMouth / 2, pacmanAngle + TWO_PI - pacmanMouth / 2, PIE);
}

void animateMouth() {
    //This function changes the pacmanMouth variable so that it slowly
    //increases from0 to PACMAN_MAX_MOUTH, then snaps closed to 0 again.
    final float PACMAN_MOUTH_SPEED = 0.08;
    final float PACMAN_MAX_MOUTH = 1.5;
    //Increase the mouth opening each time, but snap it shut at the maximum
    pacmanMouth = (pacmanMouth + PACMAN_MOUTH_SPEED) % PACMAN_MAX_MOUTH;
}

//Moves Pacman in the intended direcion 
void movePacman() {    
    if (direction == MOVERIGHT) {
        pacmanX = pacmanX + SPEED;
    } else if (direction == MOVEDOWN) {
        pacmanY = pacmanY + SPEED;
    } else if (direction == MOVELEFT) {
        pacmanX = pacmanX - SPEED;
    } else if (direction == MOVEUP) {
        pacmanY = pacmanY - SPEED;
    }
}

//Inside this function, set the value of your global PacMan direction variable to the appropriate value
//(0, 1, 2, or 3) if the player presses an arrow key
void keyPressed() {
    if (keyCode == UP) {
        direction = MOVEUP;
    } else if (keyCode == DOWN) {
        direction = MOVEDOWN;
    } else if (keyCode == LEFT) {
        direction = MOVELEFT;
    } else if (keyCode == RIGHT) {
        direction = MOVERIGHT;
    }
    
    
}

//Using this function Pac - Man faces the direction he is moving
void turnPacman() {
    //Set the pacmanAngle variable to be the angle from the pacman to the mouse
    
    if (direction == MOVERIGHT) {
        pacmanAngle = 0;
    } else if (direction == MOVELEFT) {
        pacmanAngle = PIE;
    } else if (direction == MOVEUP) {
        pacmanAngle = PIE + (0.5 * PIE);
    }
    else if (direction == MOVEDOWN) {
        pacmanAngle = -1 * (PIE + (0.5 * PIE));
    }
    
    
}
