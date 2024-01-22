
void updateLight(boolean all){
  if(all){
    for(int ix = 0; ix < 9; ix++){
      for(int iy = 0; iy < 8; iy++){
        launchpad.sendNoteOn(0,ix+(iy*16),lightmap[ix][iy]);
        //println(str(ix)+","+str(iy)+"  :  "+str(lightmap[ix][iy]));
        changeLight[ix][iy] = false;
        //print("why");
      }
    }
  }else{
    for(int ix = 0; ix < 9; ix++){
      for(int iy = 0; iy < 8; iy++){
        
        if(changeLight[ix][iy]){
          launchpad.sendNoteOn(0,ix+(iy*16),lightmap[ix][iy]);
          changeLight[ix][iy] = false;
          //println(lightmap[ix][iy]);
        }
      }
    }
  }
  //oldlightmap = lightmap;
}
