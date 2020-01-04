import 'package:flutter/material.dart';


Map<String ,List<String>> cupDraw (playerList, [ mode ] ) {

  print(playerList);
  print(playerList.length);
  print(mode);
  print('about to draw');

  Map<String ,List<String>> cupSchema = {
    'leftSide': [],
    'rightSide': [],
  } ;

  final int listLen = playerList.length;

  if(listLen % 2 == 0){
    
    playerList.asMap().forEach((index, value) => {
        if( index % 2 == 0){
          cupSchema['rightSide'].add(value)
        }else{
          cupSchema['leftSide'].add(value)
        }
    });

    return cupSchema;

  }

  if(listLen < 2){

    return {"fail" : ['Select at least 2 players to start the Cup Mode']};
  }

  if(mode != null && mode == 'Extended'){
     playerList.asMap().forEach((index , player) {
      int playerLen = playerList.length;

      int currentIndex = index;

      for(var i = currentIndex; i < playerLen; i++){
          if(i != playerLen - i && playerLen > i + 1 ){
            cupSchema['leftSide'].add(playerList[currentIndex]);
          }

          if(i != currentIndex && i < playerList.length){
            cupSchema['rightSide'].add(playerList[i]);
          }
        }
        return cupSchema;
    });
    cupSchema['mode'].add('allVsAll');
    return cupSchema;
  }

  if(mode != null && mode == 'Short'){
      playerList.asMap().forEach((index , player) {
      int playerLen = playerList.length;

      int currentIndex = index;

      if(index == 0){
        for(var i = currentIndex; i < 2; i++){
          
          if(i != playerLen - i && playerLen > i + 1 ){
            cupSchema['leftSide'].add(playerList[currentIndex]);
            cupSchema['rightSide'].add(playerList[i + 1]);
          }
        }
      }

        if( index % 2 == 0 && index != 0){
          cupSchema['rightSide'].add(player);

        }else{
          if(index != 0){
            cupSchema['leftSide'].add(player);
          }
        }

        return cupSchema;
    });

    return cupSchema;
  }

}



