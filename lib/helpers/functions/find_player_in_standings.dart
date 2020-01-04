Function findPlayerInStandings = (list ,selectedPlayer , index ){


    var looser = list.where((playerInfo){

      final playerBio = playerInfo.split(' index: ');
      final playerName = playerBio[0];
      final playerIndex = playerBio[1];

      var playerBio1;
      var playerName1 = selectedPlayer;

      if(selectedPlayer.contains(' index: ')){
        playerBio1 = selectedPlayer.split(' index: ');
        playerName1 = playerBio1[0];
      }

      if(playerName == playerName1 && int.parse(playerIndex) == index){

        return true;
      } else return false;
    }).where((el) => el != null).toString();

    final playerBio = looser.split(' index: ');
    var playerNameDirty = playerBio[0];
    var playerName1 = playerNameDirty.split('(')[1];

    var playerBio1;
    var playerNameFiltered = selectedPlayer;

    if(playerNameFiltered.contains(' index: ')){
        playerBio1 = playerNameFiltered.split(' index: ');
        playerNameFiltered = playerBio1[0];
      }

    return playerName1 == playerNameFiltered;
};