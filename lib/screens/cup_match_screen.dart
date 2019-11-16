import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'package:tournament_app/screens/deathmatch_screen.dart';
import 'package:tournament_app/screens/season_winner_screen.dart';
import 'package:tournament_app/store/player_bio_model.dart';
import 'dart:io';
import '../store/tournament_info_model.dart';
import '../theme/theme.dart' as AppTheme;

class CupMatchScreen extends StatefulWidget {
  final Map<String, List> cupPlayers;
  final Function invokeNextRound;

  CupMatchScreen({Key key, this.cupPlayers, this.invokeNextRound})
      : super(key: key);

  @override
  _CupMatchScreenState createState() => _CupMatchScreenState();
}

class _CupMatchScreenState extends State<CupMatchScreen> {
  List<String> losersList = List();
  List winnersList = List();
  Map<String, Map<String, String>> deathmatchScore;

  int cupPlayersLen;

  Timer _timer;

  // Actual Array with the players score;
  List<String> leftScore = [];
  List<String> rightScore = [];

  // Dummy Array for the beggining of each new round
  List<String> leftScoreNew = ['0', '0', '0', '0', '0', '0', '0'];
  List<String> rightScoreNew = ['0', '0', '0', '0', '0', '0', '0'];

  bool newRound = false;
  bool winner = false;

  String matchWinner = '';

  @override
  void dispose() {
    super.dispose();

    _timer.cancel();

    print('disposing ......');
  }

  @override
  initState() {
    super.initState();

    int cupLen = widget.cupPlayers['leftSide'].length;

    setState(() {
      cupPlayersLen = widget.cupPlayers['leftSide'].length +
          widget.cupPlayers['rightSide'].length;

      leftScore = List.generate(cupLen, (i) {
        return '0';
      });

      rightScore = List.generate(cupLen, (i) {
        return '0';
      });

    });
  }

  void incrementSeason(){
    print('incrementing');
    ScopedModel.of<TournamentInfoModel>(context).setSeasonNumber('cup');
  }

  @override
  Widget build(BuildContext context) {
    final playersLen = widget.cupPlayers['leftSide'].length +
        widget.cupPlayers['rightSide'].length;

    String message = '';
    final playerLength = playersLen;
    switch (playerLength) {
      case 2:
        message = 'Final';
        break;
      case 4:
        message = 'Semi Finals';
        break;
      case 8:
        message = 'Quarter Finals';
        break;
      case 16:
        message = 'Best of 16';
        break;
      default:
        message = 'Cup Draw';
    }

    void routeToWinner() {
      var playerBio = winnersList[0].split(' ');

      _timer = new Timer(const Duration(milliseconds: 400), () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                curve: Curves.easeInOutSine,
                alignment: Alignment.bottomRight,
                duration: Duration(milliseconds: 350),
                child: SeasonWinner(
                  winner: PlayerBio(
                    date: DateTime.now(),
                    name: playerBio[1],
                    emoji: playerBio[0],
                    achievements: {
                      'cup': ['Season 6'],
                    },
                  ),
                  winnerImage: 'https://media.giphy.com/media/l0Ex3vQtX5VX2YtAQ/giphy.gif',
                  title: 'Slammer\'s Cup',
                  counter: incrementSeason,
                  venue: 'cup',
                ),
                ));
      });
    }

    // Trigger new round
    final tournamentPhase = (int playersLen, List listOfWinners) {
      int tournamentFormat;

      tournamentFormat = playersLen;

      int nextPhase = (tournamentFormat ~/ 2).toInt();


      // if all matches in the current round are player , proceed with next round
      if (listOfWinners.length == nextPhase) {

        nextPhase = (tournamentFormat ~/ 2).toInt();
        double winnersLen = widget.cupPlayers['leftSide'].length / 2;
        int nextPhasePlayers = winnersLen.toInt();

        this.setState(() {

          newRound = true;

          leftScore = List.generate(nextPhasePlayers, (i) {
            return '0';
          });

          rightScore = List.generate(nextPhasePlayers, (i) {
            return '0';
          });

        });

        // Determine when is the final match
        if (nextPhase < 2) {

          this.setState(() {
            leftScore = List.generate(1, (i) {
              return '0';
            });

            rightScore = List.generate(1, (i) {
              return '0';
            });
          });

          this.setState(() {
            newRound = false;
          });

          routeToWinner();
          return null;
        }

        widget.invokeNextRound(winnersList);

        // Reset winnersList for the new round
        winnersList = List();
      }
    };



    void getWinnerDelayed(info) {
      _timer = new Timer(const Duration(milliseconds: 100), () {

        var winnerName = info['winner']['name'].split('\n').join(' ');
        var loserName = info['loser']['name'].split('\n').join(' ');

        setState(() {
          winnersList.add('${info['winner']['emoji']} ${winnerName}');
          losersList.add('${info['loser']['emoji']} ${loserName}');
        });

        // if we have a result from a match assign it to deathMatchScore
        if (winnersList.length > 0 && losersList.length > 0) {
          deathmatchScore = {
            "score": {
              "leftSide": '${info['winner']['side']}' == 'leftSide'
                  ? '${info['winner']['score']}'
                  : '${info['loser']['score']}',
              "rightSide": '${info['loser']['side']}' == 'rightSide'
                  ? '${info['loser']['score']}'
                  : '${info['winner']['score']}'
            },
            'index': {'indexMatch': '${info['loser']['index']}'},
          };
        }

        // When new round starts , reset the newRound variable to false
        
          this.setState(() {
            newRound = false;
          });
        

        tournamentPhase(playersLen, winnersList);

      });
    }

    void getWinner(matchInfo) {
      getWinnerDelayed(matchInfo);
    }

    bool matchPlayed(currentPlayer){
      if(winnersList.contains(currentPlayer)){
        return true;
      }
      if(losersList.contains(currentPlayer)){
        return true;
      }
      else {
        return false;
      }
    };

    dynamic updateMatchList(leftSideScore, rightSideScore, matchIndex) {
      var parsedIndex = int.parse(matchIndex);

      leftScore.replaceRange(parsedIndex, parsedIndex + 1, [leftSideScore]);
      rightScore.replaceRange(parsedIndex, parsedIndex + 1, [rightSideScore]);
    }

    void updateMatchScore(matchScore, player, index) {
      if (matchScore != null &&
          matchScore['index']['indexMatch'] == index.toString()) {
        var leftInfo = matchScore['score']['leftSide'];
        var rightInfo = matchScore['score']['rightSide'];
        var matchIndex = matchScore['index']['indexMatch'];

        if (matchWinner != player) {
          
          matchWinner = player;
        }

        updateMatchList(leftInfo, rightInfo, matchIndex);
      }
    }

    return Container(
      width: double.infinity,
      child: ScopedModelDescendant<PlayerBioModel>(
        builder: (context, child, model) {
          final List<PlayerBio> players = model.getPlayers;

          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Text(
                  '${message}',
                  style: TextStyle(
                    fontFamily: AppTheme.FontFamilies.curvy,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: widget.cupPlayers['leftSide']
                              .asMap()
                              .map((index, player) {
                                bool loser = losersList.contains((player));

                                updateMatchScore(
                                    deathmatchScore, player, index);

                                final List splittedName = player.split(' ');
                                final String shortName = splittedName[0] +
                                    '  ' +
                                    splittedName[1] +
                                    '.' +
                                    splittedName[2].split('')[0];

                                bool isMatchPlayed = matchPlayed(player);
                                
                                return MapEntry(
                                  index,
                                  GestureDetector(
                                    onTap: isMatchPlayed ? (){} : (){

                                      if(losersList.contains(player)){
                        
                                        return null;
                                      }

                                      if(winnersList.contains(player)){
                   
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
                                                  widget.cupPlayers,
                                                  player,
                                                  index,
                                                  getWinner),
                                              ));
                                    },
                                    child: Container(
                                        // color: Colors.blue,
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          shortName,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontFamily: AppTheme
                                                  .FontFamilies.slightlyCurvy,
                                              decoration: loser
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none),
                                        )),
                                  ),
                                );
                              })
                              .values
                              .toList()),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        // margin: EdgeInsets.only(top: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: widget.cupPlayers['rightSide']
                                .asMap()
                                .map((index, player) {

                                  var leftScoreCurrent = newRound
                                      ? '${leftScoreNew[index]}'
                                      : '${leftScore[index]}';
                                  var rightScoreCurrent = newRound
                                      ? "${rightScoreNew[index]}"
                                      : "${rightScore[index]}";

                                  
                                  updateMatchScore(deathmatchScore, player, index);


                                  double platformMargin = Platform.isIOS ? 21 : 15 ;

                                  bool isMatchPlayed = matchPlayed(player);

                                  return MapEntry(
                                    index,
                                    GestureDetector(
                                      onTap: isMatchPlayed ? (){} : (){
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.rightToLeftWithFade,
                                              curve: Curves.easeInOutSine,
                                              alignment: Alignment.bottomRight,
                                              duration: Duration(milliseconds: 350),
                                              child: DeathMatchScreen(
                                                  widget.cupPlayers,
                                                  player,
                                                  index,
                                                  getWinner),
                                              ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: platformMargin),
                                        child: Text(
                                          '${leftScoreCurrent}'
                                          ' : '
                                          '${rightScoreCurrent}',
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontFamily: AppTheme
                                                  .FontFamilies.slightlyCurvy),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .values
                                .toList()),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.cupPlayers['rightSide']
                              .asMap()
                              .map((index, player) {
                                var loser = losersList.contains((player));

                                updateMatchScore(
                                    deathmatchScore, player, index);

                                final List splittedName = player.split(' ');
                                final String shortName = splittedName[1] +
                                    '.' +
                                    splittedName[2].split('')[0] +
                                    '  ' +
                                    splittedName[0];

                                bool isMatchPlayed = matchPlayed(player);

                                return MapEntry(
                                    index,
                                    GestureDetector(
                                        onTap: isMatchPlayed ? (){} : (){
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                              type: PageTransitionType.leftToRightWithFade,
                                              curve: Curves.easeInOutSine,
                                              alignment: Alignment.bottomRight,
                                              duration: Duration(milliseconds: 350),
                                                  child: DeathMatchScreen(
                                                      widget.cupPlayers,
                                                      player,
                                                      index,
                                                      getWinner),
                                                  ));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(top: 15),
                                          child: Text(
                                            shortName,
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontFamily: AppTheme
                                                    .FontFamilies.slightlyCurvy,
                                                decoration: loser
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none),
                                          ),
                                        )));
                              })
                              .values
                              .toList()),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
