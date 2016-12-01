import processing.sound.*;

ArrayList<Integer> x = new ArrayList<Integer>();
ArrayList<Integer> y = new ArrayList<Integer>();
ArrayList<Integer> eX = new ArrayList<Integer>();
ArrayList<Integer> eY = new ArrayList<Integer>();
ArrayList<String> spawner = new ArrayList<String>();
public SoundFile file, enemySpawn, beginNoise;
int w = 64, h = 36, bs = 20, dir = 2, applex = 23, appley = 10, viewportWidth, viewportHeight;
int[] dx = {0, 0, 1, -1}, dy = {1, -1, 0, 0};
boolean gameover = false, start = false;
PFont mono;
void setup(){
  size(1280, 720);
  x.add(5);
  y.add(5);
  viewportWidth = 1280;
  viewportHeight = 720;
  
  mono = createFont("C:\\Users\\Owner\\Desktop\\Fonts\\VCR_OSD_MONO_1.001.ttf", (1280/720) * 150, true);
  
  file = new SoundFile(this, "C:\\Users\\Owner\\Downloads\\Laser_Cannon-Mike_Koenig-797224747.mp3");
  enemySpawn = new SoundFile(this, "C:\\Users\\Owner\\Downloads\\Mario_Jumping-Mike_Koenig-989896458.mp3");
  beginNoise = new SoundFile(this, "C:\\Users\\Owner\\Downloads\\Electrical_Sweep-Sweeper-1760111493.mp3");
  
}

float timer = 0;
void draw(){
  
  if(!gameover){
    if(start){
  background(0, 0, 50);
  for(int i = 0; i < w; i++) line(i*bs, 0, i*bs, height);
  for(int i = 0; i < h; i++) line(0, i*bs, width, i*bs);
  for(int i = 0; i < x.size();i++){
    
    fill(0, 255, 0);
    rect(x.get(i)*bs, y.get(i)*bs, bs, bs);
  }
  for(int i = 0; i < eX.size();i++){
    fill(90, 30, 0);
    rect(eX.get(i)*bs, eY.get(i)*bs, bs, bs);
  }
    checkOutOfBounds();
    checkCollisionWithSelf();
  
   checkCollisionWithEnemy();
   timer += frameRate / 100;
   
  if(frameCount % 5 == 0){
    x.add(0, x.get(0) + dx[dir]);
    y.add(0, y.get(0) + dy[dir]);
    for(int i = 0; i < spawner.size(); i++){
      if(spawner.size() > 0){
        if(spawner.get(i).equals("bottom")){
          eY.set(i, eY.get(i) + dy[1]);
          
        }
         else if(spawner.get(i).equals("top")){
          eY.set(i, eY.get(i) + dy[0]);
          
         }
      }
    }
    fill(255, 0, 0);
      spawnByDifficulty(difficulty);
    }
    }else{
      drawStartScene();
    }
}else{
  background(0);
    drawGameOverScene();
    eY.clear();
          eX.clear();
          eX.add(0);
          eY.add(0);
          spawner.clear();
          spawner.add("top");
    }
  }
  
  
  void spawnByDifficulty(String difficultyyy){
    switch(difficultyyy){
    case "Easy": {
     spawnTimer = 100;
     break;
    }
    
    case "Medium": {
     spawnTimer = 50;
     break;
    }
    
    case "Hard": {
     spawnTimer = 25;
     break;
    }
    
    case "Impossible": {
     spawnTimer = 5;
     break;
    }
    
    
    }
    
    
    spawn();
  }
  float spawnTimer = 1000;
  void spawn(){
  int xx;
  if(timer > spawnTimer){
      
        
        eX.add((int)random(0, width / bs));
        
        xx = (int)random(0, 2);
        
        println(xx);
        if(xx == 1){
          eY.add(((int) (height) / bs) - 1);
          spawner.add("bottom");
         enemySpawn.play();
        }
         else{
          eY.add((int) 0);
           spawner.add("top");
           enemySpawn.play();
         }
      
    
      timer = 0;
    }else{
    
    x.remove(x.size()-1);
    y.remove(y.size()- 1);
    }
  }
  
int r = 0, g = 0, b = 0, tmpR, tmpG, tmpB;
float elapsed = 0, waiter = 0, drawAcross = 0, flicker = 0;
boolean tryOnce = true;
void drawStartScene(){
  if(tryOnce)
    beginNoise.play();
    tryOnce = false;
  elapsed+=frameCount / 100;
  waiter+=frameRate / 100;
  if(waiter > 10){
    tmpR = (int)random(0, 255);
    tmpG = (int)random(0,255);
    tmpB = (int)random(0,255);
    waiter = 0;
  }
  background(0, 10, 0);
  if(tmpR < r) r--;
  else r++;
  if(tmpG < g) g--;
  else g++;
  if(tmpB < b) b--;
  else b++;
      
  fill(r, g, b, elapsed);
  textSize(width / height);
  textFont(mono);
  textAlign(CENTER);
  text("SNAKE DODGE", width / 2, height / 3.5f);
  int timeDraw = 10;
  if(key == ' ' && canStart){
        start = true;
        gameover = false;
  }
  if(elapsed > 255){
    drawAcross += frameRate / 100;
      fill(255-r, 255-g, 255-b, elapsed);
      textSize(30);
      textFont(mono);
      textAlign(CENTER);
    if(drawAcross < timeDraw){
     
      text("P", width / 2, height / 1.3f);
    }else if(drawAcross < timeDraw * 2){
      
      text("PL", width / 2, height / 1.3f);
    }else if(drawAcross < timeDraw * 3){
      
     
      text("PLA", width / 2, height / 1.3f);
    }else{
      
      startScene();
     
    }
  }
  
}
boolean canStart = false;



String difficulty = "Medium";
int difficultyCounter = 1;
boolean keyDown;
void startScene(){
      text("PLAY", width / 2, height / 1.33f);
      
      textSize(30);
      
      text("Press space to begin", width / 2, height / 1.25f);
      canStart = true;
      
      
      
      text("Difficulty: < " + difficulty + " > ", width / 2, height / 2f);
     
      if(key == '1')
        difficulty = "Easy";
      if(key == '2')
        difficulty = "Medium";
      if(key == '3')
        difficulty = "Hard";
      if(key == '4')
        difficulty = "Impossible";
      
      
}
int frameSec = 0, secondTime = 0;
void drawGameOverScene(){
    frameSec += frameCount / 100;
    fill(255, 0, 0, frameSec );
    textSize(30);
    textFont(mono);
    textAlign(CENTER);
    text("GAME OVER", width / 2, height / 3);
    if(frameSec > 200){
    fill(0, 100, 0, frameSec );
    textSize(10);
    textFont(mono);
    textAlign(CENTER);
    text("SCORE:" + x.size(), width / 2, height / 1.75);
    
    }
    if(frameSec > 300){
      secondTime += frameCount / 100;
      textFont(mono);
      textSize(15);
      fill(0,255,0, secondTime);
      textAlign(CENTER);
      text("Press R to continue", width / 2, height / 1.5);
    }
    
    if(secondTime > 255)
    if(key == 'r'){
      restart();
    }
    
}
void checkOutOfBounds(){
  if(x.get(0) < 0 || y.get(0) < 0 || x.get(0) >= w || y.get(0) >= h){
    gameover = true;
    file.play();
  }
}
void restart(){
    x.clear();
    y.clear();
    x.add(5);
    y.add(5);
    gameover = false;
    start = false;
  }
void keyPressed(){
    int newDir = key == 's' ? 0 : (key == 'w' ? 1 : (key == 'd' ? 2 : (key == 'a' ? 3 : -1)));
    if(newDir != -1 &&(x.size() <=1 || !(x.get(1) == x.get(0) + dx[newDir] && y.get(1) == y.get(0) + dy[newDir]))) dir = newDir;
  }
  
  void checkCollisionWithSelf(){
   
  for(int i = 1; i < x.size(); i++){
    if(x.get(0) == x.get(i) && y.get(0) == y.get(i)){
      gameover = true;
      file.play();
    }
      
  }
  }
  
  void checkCollisionWithEnemy(){
    for(int i = 0; i < x.size(); i++){
      for(int k = 0; k < eX.size(); k++){
        if(x.get(i) == eX.get(k) && y.get(i) == eY.get(k)){
          gameover = true;
          eY.clear();
          eX.clear();
          eX.add(0);
          eY.add(0);
          file.play();
        }
      }
    }
  }
  