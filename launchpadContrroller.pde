import themidibus.*; //http://www.smallbutdigital.com/docs/themidibus/themidibus/MidiBus.html
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.SysexMessage;
import javax.sound.midi.ShortMessage;


String prePath = "pages\\";

//String pagePaths[] = loadStrings("files.txt");
String pagePaths[] = {
  "test1.txt"
};

//wee

boolean defaultToggle = false;
String currentPagePath = pagePaths[0];
String pageFile[];

String[] notes;

boolean prevPressed;

int defTime = 10;

String LPBs_mode[][] = new String[9][8];
int LPBs_time[][] = new int[9][8];
int LPBs_stdCol[][] = new int[9][8];
int LPBs_highlightCol[][] = new int[9][8];
int LPBs_data[][] = new int[9][8];
Boolean LPBs_pressed[][] = new Boolean[9][8];
Boolean LPBs_prevPressed[][] = new Boolean[9][8];

int ModeSel_;

int page = 0;

String[] InputList;
String[] OutputList;
boolean right = false;
boolean prev = false;
int indexI = 0;
int indexO = 0;

boolean connected = false;


int selColRHigh = 0;
int selColGHigh = 0;
int selColRLow = 0;
int selColGLow = 0;



boolean selecting = true;


MidiBus launchpad;

int[][] lightmap = new int[9][8];
Boolean changeLight[][] = new Boolean[9][8];




void setup() {

  for(int iy = 0; iy < 8; iy++){
    for(int ix = 0; ix < 9; ix++){
      LPBs_mode[ix][iy] = "";
      LPBs_time[ix][iy] = 0;
      LPBs_stdCol[ix][iy] = 0;
      LPBs_highlightCol[ix][iy] = 0;
      LPBs_data[ix][iy] = 0;
      LPBs_pressed[ix][iy] = false;
      LPBs_prevPressed[ix][iy] = false;
    }
  }


    //LPBs_mode[0][0] = "toggle";
    //LPBs_time[0][0] = 300;
    //LPBs_stdCol[0][0] = RG(3,0);
    //LPBs_highlightCol[0][0] = RG(0,3);



 pageFile = loadStrings(prePath+currentPagePath);
 MidiBus.list();
  clear(0,0);
 
  //oldlightmap = lightmap;
  
  
  size(1000, 900);
  background(0);
  
 InputList = MidiBus.availableInputs();
 OutputList = MidiBus.availableOutputs();
    
    delay(100);

  //updateLight(true);

}


void draw() {
  
  if(connected){

    background(0);

    //drawGrid();
    SelectorList(pagePaths,page,20,20);


    if(keyPressed){
      if(keyCode == UP && !prev){
        if(page > 0){
          page--;
        }
      }
      if(keyCode == DOWN && !prev){
        if(page < pagePaths.length-1){
          page++;
        }
      }
      if(key == '\n' && !prev){
        
        currentPagePath = pagePaths[page];
        //println(CurrentPagePath);
         pageFile = loadStrings(prePath+currentPagePath);
        loadToLP(pageFile);
        printArray(lightmap[0]);



      }
    }



    for(int iy = 0; iy < 8; iy++){
      for(int ix = 0; ix < 9; ix++){
        setColorRaw(lightmap,ix,iy,update(ix,iy));
        
      }
    }
    prev = keyPressed;


    modeSel(600,50);
    //colorSel(200,200,false);
    modeSettings();

    //println(selColRLow);
    //println(selColGLow);
    //println();

    drawLP();
    
    updateLight(false);


  }else{
    connect();
    
  }
}



void midiMessage(MidiMessage message) { 

  int Cmd = int(message.getMessage()[0]);
  int Param1 = int(message.getMessage()[1]);
  int Param2 = int(message.getMessage()[2]);

  if(Cmd == 128 ||Cmd == 144){
    //println(str(getX(Param1)) + "  " + str(getY(Param1)));
    LPBs_pressed[getX(Param1)][getY(Param1)] = Param2 > 0;
  }

}




void modeSettings(){
  switch(ModeSel_){
    case 0: //none
  
      //ITS NOTHING OKAY  {"none","consts","temp","toggle","fadeOut","flash"}

    break;
    case 1: //const
      colorSel(600,220,false);

    break;
    case 2: //temp
      colorSel(600,220,false);
      colorSel(780,220,true);

    break;
    case 3: //toggle
      colorSel(600,220,false);
      colorSel(780,220,true);
      setDef(600,140);

    break;
    case 4: //FO
      colorSel(600,220,false);
      colorSel(780,220,true);
      setTime(600,140);

    break;
    case 5: // flash
      colorSel(600,220,false);
      colorSel(780,220,true);
      setTime(600,140);

    break;
  }
}




int getX(int input){
  return input%16;
}
int getY(int input){
  return int(input/16);
}



void colorSel(float posX, float posY, boolean high){

  noStroke();
  for(int iy = 0; iy < 4; iy++){
    for(int ix = 0; ix < 4; ix++){
      fill(map(ix,0,3,0,255),map(iy,0,3,0,255),0);
      rect(ix*35+posX+3.5,iy*35+posY+3.5,30,30);
    }
  }

  if(high){
    stroke(127,127,255);
    noFill();
    strokeWeight(3);
    rect(posX+selColRHigh*35,posY+selColGHigh*35,35,35);
  }else{
    stroke(127,127,255);
    noFill();
    strokeWeight(3);
    rect(posX+selColRLow*35,posY+selColGLow*35,35,35);
  }


  colSelHandler(posX,posY,high);


}



void setTime(float xPos,float yPos){

  stroke(0);
  strokeWeight(2);
  fill(127,0,0);
  rect(xPos,yPos,40,40);
  rect(xPos+40,yPos,40,40);
  fill(80);
  rect(xPos+80,yPos,120,40);
  fill(0,127,0);
  rect(xPos+200,yPos,40,40);
  rect(xPos+240,yPos,40,40);



  if(ButtonSelector(xPos,yPos,40,40) && mousePressed && !prevPressed){
    defTime -= 10;
  }
  if(ButtonSelector(xPos+40,yPos,40,40) && mousePressed && !prevPressed){
    defTime -= 1;
  }
  if(ButtonSelector(xPos+200,yPos,40,40) && mousePressed && !prevPressed){
    defTime += 1;
  }
  if(ButtonSelector(xPos+240,yPos,40,40) && mousePressed && !prevPressed){
    defTime += 10;
  }

  prevPressed = mousePressed;

  if(defTime <= 0){
    defTime = 1;
  }

  fill(255);
  textAlign(CENTER,CENTER);
  textSize(25);

  text(str(defTime*100)+" ms", xPos+140,yPos+15);
  
  text("--", xPos+20,yPos+15);
  text("-", xPos+60,yPos+15);
  text("+", xPos+220,yPos+15);
  text("++", xPos+260,yPos+15);
}
























void drawLP(){
  fill(80);
  stroke(255);
  strokeWeight(2);
  rect(600-10,395-10,325+20,290+20,8);
  noStroke();
  for(int iy = 0; iy < 8; iy++){
    for(int ix = 0; ix < 9; ix++){

      //map(get2Bit( lightmap[ix][iy]  ,0),0,3,0,255);//red
      //map(get2Bit( lightmap[ix][iy]  ,4),0,3,0,255);//green
      
      fill(map(get2Bit( lightmap[ix][iy]  ,0),0,3,0,255),map(get2Bit( lightmap[ix][iy]  ,4),0,3,0,255),0);

      if(ix == 8){
        ellipse(ix*35+620,iy*35+415,30,30);
      }else{
        rect(ix*35+605,iy*35+400,30,30);
      }
      
    }
  }
}
























void setDef(float xPos,float yPos){
  stroke(0);
  strokeWeight(2);
  if(defaultToggle){
    fill(80,0,0);
  }else{
    fill(255,0,0);
  }
  
  rect(xPos,yPos,60,40);
  if(defaultToggle){
    fill(0,255,0);
  }else{
    fill(0,80,0);
  }
  rect(xPos+60,yPos,60,40);

  fill(255);
  textAlign(CENTER,CENTER);
  textSize(25);
  text("Low",xPos+30,yPos+15);
  text("High",xPos+90,yPos+15);

  if(ButtonSelector(xPos,yPos,60,40) && mousePressed){
    defaultToggle = false;
  }
  if(ButtonSelector(xPos+60,yPos,60,40) && mousePressed){
    defaultToggle = true;
  }



}



boolean ButtonSelector(float xPos, float yPos, float WID, float HEI ){
  if(mouseX <= xPos || mouseX >= xPos+WID){
    return false;
  }
  if(mouseY <= yPos || mouseY >= yPos+HEI){
    return false;
  }
  
  return true;
} 



void colSelHandler(float posX, float posY, boolean high){
  if(!mousePressed){
    return;
  }  
  
  if(mouseY <= posY || mouseY > posY+139){
    return;
  }
   
  if(mouseX <= posX || mouseX > posX+139){
    return;
  }

  if(high){
    selColRHigh = int((mouseX-posX) / 35);
    selColGHigh = int((mouseY-posY) / 35);
  }else{
    selColRLow = int((mouseX-posX) / 35);
    selColGLow = int((mouseY-posY) / 35);
  }
  
  
  return;
}



void connect(){

    background(0);
    
    
 
    if(keyPressed){
      
      if(keyCode == LEFT){
        right = false;
      }
      if(keyCode == RIGHT){
        right = true;
      }
      if(keyCode == UP && !prev){
        if(!right){
          if(indexO > 0){
          indexO--;
          }
        }else{
          if(indexI > 0){
          indexI--;
          }
        }
      }
      if(keyCode == DOWN && !prev){
        if(!right){
          if(indexO < OutputList.length-1){
          indexO++;
          } 
        }else{
          if(indexI < InputList.length-1){
          indexI++;
          }
        }
      }
      if(key == '\n'){
        launchpad = new MidiBus(this, indexI, indexO);
        connected = true;
        updateLight(true);
        clear(3,0);
        updateLight(true);
        delay(400);
        clear(0,3);
        updateLight(true);
        delay(400);
        clear(3,3);
        updateLight(true);
        delay(400);
        clear(0,0);
        updateLight(true);
      }
      
    }
    prev = keyPressed;
    
    
    
    
    

    noFill();
    stroke(0,255,0);


    if(right){
      rect(520,20,440,InputList.length*20 + 20);
    }else{
      rect(20,20,440,OutputList.length*20 + 20);
    }

    SelectorList(InputList, indexI , 530, 50);
    SelectorList(OutputList, indexO, 30, 50);

    delay(10);
  //MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  //launchpad = new MidiBus(this, "Launchpad S", "Launchpad S"); // Create a new MidiBus object
}





void SelectorList(String[] options, int index,float posX, float posY){
  fill(255,255,255);
  noStroke();
  textSize(20);
  

  //printArray(options);
  int optionsNum = options.length;
  
  for(int i = 0; i < optionsNum; i++){
    text(options[i],posX + 20, posY + i * 20 );
  }

  text(">", posX , posY + index * 20);

}


void drawGrid(){

  for(int iy = 0; iy < 8; iy++){
    for(int ix = 0; ix < 9; ix++){
      print(lightmap[ix][iy]);
    }
    print("\n");
  }
  print("\n\n");
}



void Rect(int[][] array, int x, int y, int w, int h, int Red, int Green){
  for(int ix = x; ix < w+x; ix++){
    for(int iy = y; iy < h+y; iy++){
      array[ix][iy] = RG(Red,Green);
    }
  }
}



int RG(int Red, int Green){
  int ret = 0;
  ret += int(Red   == 1 || Red   == 3);
  ret += int(Red   == 2 || Red   == 3)*2;
  ret += int(Green == 1 || Green == 3)*16;
  ret += int(Green == 2 || Green == 3)*32;
  return ret;
}



int get2Bit(int n, int k) {
    return ((n >> k) & 3);
}



void setColor(int[][] array, int x, int y, int Red, int Green){
  int prevCol = array[x][y];

  //changeLight[x][y] = RG(Red,Green) != array[x][y];
  array[x][y] = RG(Red,Green);
  changeLight[x][y] = prevCol != array[x][y];
}

void setColorRaw(int[][] array, int x, int y, int val){

  int prevCol = array[x][y];
  //changeLight[x][y] = val != array[x][y];
  array[x][y] = val;
  changeLight[x][y] = prevCol != array[x][y];
}



void clear(int r, int g){
  for(int i = 0; i < 9; i++){
    for(int o = 0; o < 8; o++){
      lightmap[i][o] = RG(r,g);
    }
  }
}




void loadToLP(String blocks[]){
  //String[] blocks = mainStr;
  String data[][] = new String[73][4];

  notes = blocks[0].split("-");
  //printArray(data[0]);
  for(int i = 1; i<73;i++){
    data[i] = blocks[i].split(",");
    //printArray(data[i]);
  }

  //printArray(blocks[71].split(","));
  for(int o = 0; o < 8; o++){
  for(int i = 0; i < 9; i++){
    
      //println(str(i)+"  "+str(o)+"  "+str(i+o*9+1));
      int dataNum = i+(o*9)+1;
      //println("X:"+str(i)+"  Y:"+str(o)+"  I:"+str(dataNum));
      LPBs_mode[i][o] = data[dataNum][0];
      LPBs_time[i][o] = Integer.valueOf(data[dataNum][1]);
      LPBs_stdCol[i][o] = Integer.valueOf(data[dataNum][2]);

      //println(Integer.valueOf(data[i+(o*9)+1][2]));, 
      LPBs_highlightCol[i][o] = Integer.valueOf(data[dataNum][3]);
    }
    //println(i);
    //printArray(LPBs_mode[i]);
  }
  
  updateLight(true);
}

//none temp toggle flash fade out const

void modeSel(float posX, float posY){

  MODE_selector(posX,posY);

  String a[] = {"none","consts","temp","toggle","fadeOut","flash"};
  
  noFill();
  stroke(0,255,0);
  strokeWeight(4);
  
  rect(ModeSel_*50 +posX-1,posY-1,50,35);


  posX += 2.5;
  posY += 2.5;


  logo_none(posX,posY);
  logo_const(posX+50,posY);
  logo_temp(posX+100,posY);
  logo_toggle(posX+150,posY);
  logo_fadeOut(posX+200,posY);
  logo_flash(posX+250,posY);

}

void MODE_selector(float posX, float posY){

  if(!mousePressed){
    return;
  }  
  
  if(mouseY <= posY || mouseY > posY+35){
    return;
  }
   
  if(mouseX <= posX || mouseX > posX+299){
    return;
  }

  ModeSel_ = int((mouseX - posX)/50);
  return;
}


void compile(){

}

void logo_none(float LogoPosX, float LogoPosY){
  noStroke();
  fill(127);
  rect(LogoPosX,LogoPosY,45,30);

  stroke(255,0,0);
  strokeWeight(3);
  

  line(LogoPosX,LogoPosY,LogoPosX+45,LogoPosY+30);
  line(LogoPosX,LogoPosY+30,LogoPosX+45,LogoPosY);


} 


void logo_temp(float LogoPosX, float LogoPosY){
  noStroke();
  fill(127,0,0);
  rect(LogoPosX,LogoPosY,10,30);
  rect(LogoPosX+25,LogoPosY,20,30);
  fill(0,127,0);
  rect(LogoPosX+10,LogoPosY,15,30);

  stroke(255);
  strokeWeight(2);

  line(LogoPosX,LogoPosY+20,LogoPosX+10,LogoPosY+20);
  line(LogoPosX+10,LogoPosY+20,LogoPosX+10,LogoPosY+10);
  line(LogoPosX+10,LogoPosY+10,LogoPosX+25,LogoPosY+10);
  line(LogoPosX+25,LogoPosY+20,LogoPosX+25,LogoPosY+10);
  line(LogoPosX+25,LogoPosY+20,LogoPosX+45,LogoPosY+20);

} 
void logo_toggle(float LogoPosX, float LogoPosY){
  noStroke();
    fill(127,0,0);
  rect(LogoPosX,LogoPosY,10,30);
  rect(LogoPosX+25,LogoPosY,20,30);
  fill(0,127,0);
  rect(LogoPosX+10,LogoPosY,15,30);

  stroke(255);
  strokeWeight(2);

  line(LogoPosX,LogoPosY+20,LogoPosX+10,LogoPosY+20);
  line(LogoPosX+15,LogoPosY+20,LogoPosX+45,LogoPosY+20);
  line(LogoPosX+10,LogoPosY+20,LogoPosX+15,LogoPosY+10);
  line(LogoPosX+15,LogoPosY+20,LogoPosX+10,LogoPosY+10);
  line(LogoPosX,LogoPosY+10,LogoPosX+10,LogoPosY+10);
  line(LogoPosX+15,LogoPosY+10,LogoPosX+45,LogoPosY+10);

} 
void logo_flash(float LogoPosX, float LogoPosY){
  noStroke();
      fill(127,0,0);
  rect(LogoPosX,LogoPosY,10,30);
  rect(LogoPosX+25,LogoPosY,20,30);
  fill(0,127,0);
  rect(LogoPosX+10,LogoPosY,15,30);

  stroke(255);
  strokeWeight(2);

  line(LogoPosX,LogoPosY+20,LogoPosX+10,LogoPosY+20);
  line(LogoPosX+10,LogoPosY+20,LogoPosX+10,LogoPosY+10);
  line(LogoPosX+10,LogoPosY+10,LogoPosX+35,LogoPosY+20);
  line(LogoPosX+35,LogoPosY+20,LogoPosX+45,LogoPosY+20);

} 
void logo_fadeOut(float LogoPosX, float LogoPosY){
  noStroke();
    fill(127,0,0);
  rect(LogoPosX,LogoPosY,10,30);
  rect(LogoPosX+25,LogoPosY,20,30);
  fill(0,127,0);
  rect(LogoPosX+10,LogoPosY,15,30);

  stroke(255);
  strokeWeight(2);

  line(LogoPosX,LogoPosY+20,LogoPosX+10,LogoPosY+20);
  line(LogoPosX+10,LogoPosY+20,LogoPosX+10,LogoPosY+10);
  line(LogoPosX+10,LogoPosY+10,LogoPosX+25,LogoPosY+10);
  line(LogoPosX+25,LogoPosY+10,LogoPosX+40,LogoPosY+20);
  line(LogoPosX+40,LogoPosY+20,LogoPosX+45,LogoPosY+20);

} 
void logo_const(float LogoPosX, float LogoPosY){
  noStroke();
    fill(127,0,0);
  rect(LogoPosX,LogoPosY,10,30);
  rect(LogoPosX+25,LogoPosY,20,30);
  fill(0,127,0);
  rect(LogoPosX+10,LogoPosY,15,30);

  stroke(255);
  strokeWeight(2);

  line(LogoPosX,LogoPosY+10,LogoPosX+45,LogoPosY+10);


} 