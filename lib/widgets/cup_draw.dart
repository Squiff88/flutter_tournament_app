import 'package:flutter/material.dart';


Map<String ,List<String>> cupDraw (playerList) {

  Map<String ,List<String>> cupSchema = {
    'leftSide': [],
    'rightSide': []

  } ;

  final int listLen = playerList.length;

  final myList = playerList.asMap().forEach((index, value) => {
        if( index % 2 == 0){

        cupSchema['rightSide'].add(value)
      }else{
        cupSchema['leftSide'].add(value)
      }
});

  if(listLen == 2 || listLen == 4 || listLen == 8 || listLen == 16){
    return cupSchema;
  }else{
    print('no correct len of players');
    return {"fail" : ['Select at least 4 players to start the Cup']};
  }
}



