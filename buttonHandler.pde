
    int update(int indexX,int indexY){
        if(LPBs_mode[indexX][indexY] == "none"){
            return 0;
        }

        if(LPBs_mode[indexX][indexY] == "temp"){
            if(LPBs_pressed[indexX][indexY]){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }


        if(LPBs_mode[indexX][indexY] == "toggle"){
            if(LPBs_pressed[indexX][indexY] && !LPBs_prevPressed[indexX][indexY]){
                LPBs_data[indexX][indexY] = int(LPBs_data[indexX][indexY] == 0);
            }
            LPBs_prevPressed[indexX][indexY] = LPBs_pressed[indexX][indexY];
            if(LPBs_data[indexX][indexY] > 0){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }

        if(LPBs_mode[indexX][indexY] == "flash"){
            if(LPBs_pressed[indexX][indexY] && !LPBs_prevPressed[indexX][indexY]){
                LPBs_data[indexX][indexY] = millis();
            }
            LPBs_prevPressed[indexX][indexY] = LPBs_pressed[indexX][indexY];
            if(millis()-LPBs_time[indexX][indexY] < LPBs_data[indexX][indexY]){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }

        if(LPBs_mode[indexX][indexY] == "fadeOut"){
            //println("handling fade");
            if(LPBs_pressed[indexX][indexY]){
                LPBs_data[indexX][indexY] = millis();
            }
            if(millis()-LPBs_time[indexX][indexY] < LPBs_data[indexX][indexY]){
                return LPBs_highlightCol[indexX][indexY];
            }
            return LPBs_stdCol[indexX][indexY];
        }

        if(LPBs_mode[indexX][indexY] == "const"){
            return LPBs_stdCol[indexX][indexY];
        }

        LPBs_prevPressed[indexX][indexY] = LPBs_pressed[indexX][indexY];
        return 0;
    }