import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournament_app/screens/deathmatch_screen.dart';
import '../theme/theme.dart' as AppTheme;
import '../helpers/functions/find_player_in_standings.dart';

List<Widget> playerColumn(Map<String , List> playerColumn, side, winnersList, losersList,
    updateMatchScore, deathmatchScore, context, getWinner) {
  
  return playerColumn[side]
      .asMap()
      .map((index, player) {

        var playerLost = findPlayerInStandings(losersList, player, index);

        // print(playerLost);
        // print('playerLost');

        updateMatchScore(deathmatchScore, player, index);

        final List splittedName = player.split(' ');
        final String shortName = splittedName[0] +
            '  ' +
            splittedName[1] +
            '.' +
            splittedName[2].split('')[0];

        bool playedAndLost = findPlayerInStandings(losersList, player, index);
        bool playedAndWon = findPlayerInStandings(winnersList, player, index);

        bool isMatchPlayed = playedAndLost || playedAndWon;

        return MapEntry(
          index,
          GestureDetector(
            onTap: isMatchPlayed
                ? () {}
                : () {
                    if (losersList.contains(player)) {
                      return null;
                    }

                    if (winnersList.contains(player)) {
                      return null;
                    }

                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRightWithFade,
                          curve: Curves.easeInOutSine,
                          alignment: Alignment.bottomRight,
                          duration: Duration(milliseconds: 350),
                          child: DeathMatchScreen(
                              playerColumn, player, index, getWinner, side),
                        ));
                  },
            child: Container(
                // color: Colors.blue,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  shortName,
                  textAlign: side == 'leftSide' ? TextAlign.left : TextAlign.right,
                  style: TextStyle(
                      fontSize: 19,
                      fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                      decoration: playerLost
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )),
          ),
        );
      })
      .values
      .toList();
}
