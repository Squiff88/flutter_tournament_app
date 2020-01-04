Function findPlayerInStandings = (list ,selectedPlayer , index ){


    var looser = list.where((playerInfo){

      final playerBio = playerInfo.split(' index: ');
      final playerName = playerBio[0];
      final playerIndex = playerBio[1];

      // print(playerName);
      // print(selectedPlayer);
      // print(playerIndex);
      // print(index);
      // print(playerName == selectedPlayer && int.parse(playerIndex) == index);
      // print('playerInfo');

      if(playerName == selectedPlayer && int.parse(playerIndex) == index){

        return true;
      } else return false;
    }).where((el) => el != null).toString();


    final playerBio = looser.split(' index: ');
    var playerNameDirty = playerBio[0];
    var playerName1 = playerNameDirty.split('(')[1];

    // print(playerName1 == selectedPlayer);
    // print(playerName1);
    // print(selectedPlayer);
    // print('playerName1---------------');

    return playerName1 == selectedPlayer;
};