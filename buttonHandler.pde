
    int update(int indexX,int indexY){


       


         //println(str(LPBs_mode[indexX][indexY] == "const") + " = " +  STB("const")+ "(const)" + " == "+ STB(LPBs_mode[indexX][indexY])+"("+LPBs_mode[indexX][indexY]+")");
        //println(LPBs_mode[indexX][indexY] +" = "+ str(LPBs_stdCol[indexX][indexY]));
       
        if(LPBs_mode[indexX][indexY] == 0){ //none
            return 0;
        }

        if(LPBs_mode[indexX][indexY] == 2){ //temp
            if(LPBs_pressed[indexX][indexY]){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }


        if(LPBs_mode[indexX][indexY] == 3){ //toggle
            if(LPBs_pressed[indexX][indexY] && !LPBs_prevPressed[indexX][indexY]){
                LPBs_data[indexX][indexY] = int(LPBs_data[indexX][indexY] == 0);
            }
            LPBs_prevPressed[indexX][indexY] = LPBs_pressed[indexX][indexY];
            if(LPBs_data[indexX][indexY] > 0){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }

        if(LPBs_mode[indexX][indexY] == 5){ //flash
            if(LPBs_pressed[indexX][indexY] && !LPBs_prevPressed[indexX][indexY]){
                LPBs_data[indexX][indexY] = millis();
            }
            LPBs_prevPressed[indexX][indexY] = LPBs_pressed[indexX][indexY];
            if(millis()-LPBs_time[indexX][indexY] < LPBs_data[indexX][indexY]){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }

        if(LPBs_mode[indexX][indexY] == 4){ //fade
            //println("handling fade");
            if(LPBs_pressed[indexX][indexY]){
                LPBs_data[indexX][indexY] = millis();
            }
            if(millis()-LPBs_time[indexX][indexY] < LPBs_data[indexX][indexY]){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }
        //println(str(LPBs_mode[indexX][indexY] == "const") + " = " +  "(const)" + " == "+ "("+LPBs_mode[indexX][indexY]);
        if(LPBs_mode[indexX][indexY] == 1){ //const
           //print("<<<<");
            return LPBs_stdCol[indexX][indexY]; 
        }

        LPBs_prevPressed[indexX][indexY] = LPBs_pressed[indexX][indexY];
        return 0;
    }
