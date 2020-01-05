import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/player_columns.dart';
import '../helpers/functions/find_player_in_standings.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'package:tournament_app/screens/deathmatch_screen.dart';
import 'package:tournament_app/screens/season_winner_screen.dart';
import 'package:tournament_app/store/player_bio_model.dart';
import 'dart:io';
import '../store/auth_model.dart';
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
  List<String> leftScoreNew = List<String>.generate(30,(el) => "0");
  List<String> rightScoreNew = List<String>.generate(30,(el) => "0");

  bool newRound = false;
  bool winner = false;
  String cupWinnerId;

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

  void incrementSeason() {
    bool isAnonymousUser =ScopedModel.of<AuthModel>(context).isUserAnonymous;
    if(isAnonymousUser){
      return null;
    }
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

      String userID = ScopedModel.of<PlayerBioModel>(context).getUserId;
      int cupNum = ScopedModel.of<TournamentInfoModel>(context).getCupNumber;

      _timer = new Timer(const Duration(milliseconds: 400), () {
        final userAnonymous = ScopedModel.of<AuthModel>(context).isUserAnonymous;
        print(userAnonymous);
        print('here userAnonymous');

        if(!userAnonymous){
        ScopedModel.of<PlayerBioModel>(context)
            .setAchievement('cup', userID, cupNum, cupWinnerId);
        }
        print(userID);
        print(cupNum);
        print(cupWinnerId);
        print('dataaa');
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
                ),
                winnerImage:
                    'https://media.giphy.com/media/l0Ex3vQtX5VX2YtAQ/giphy.gif',
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

      final uniqueWinners = (){
        var convertedWinners = [];
        if(convertedWinners.length == 0){
          var myConvertedWinners = [];
           listOfWinners.forEach((players){
                final winners = players.split(' index: ');
                final winnerName = winners[0];
                myConvertedWinners.add(winnerName);
          });
          return myConvertedWinners; 
        }
        return convertedWinners;
      };

      final compareUniqueWinners = uniqueWinners().toSet();

      if (listOfWinners.length > 1 && listOfWinners.length == nextPhase && (playersLen ~/ 2).toInt() == compareUniqueWinners.length ) {
    
            this.setState(() {
              leftScore = List.generate(compareUniqueWinners.length, (i) {
                return '0';
              });

              rightScore = List.generate(compareUniqueWinners.length, (i) {
                return '0';
              });

              losersList = List();

              newRound = true;

            });

            widget.invokeNextRound(winnersList);
            return winnersList = List();   
      }

      if (listOfWinners.length == nextPhase) {

        nextPhase = (tournamentFormat ~/ 2).toInt();
        
        int winnersLen = widget.cupPlayers['leftSide'].length ~/ 2;
        
        int nextPhasePlayers = winnersLen.toInt() * 2;

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

        widget.invokeNextRound(compareUniqueWinners.toList());

        // Reset winnersList for the new round
        winnersList = List();
        losersList = List();
      }
    };

    void getWinnerDelayed(info, winnerId) {
      _timer = new Timer(const Duration(milliseconds: 100), () {
        var winnerName = info['winner']['name'].split('\n').join(' ');
        var loserName = info['loser']['name'].split('\n').join(' ');

        setState(() {
          winnersList.add(
              '${info['winner']['emoji']} ${winnerName} index: ${info['winner']['index']} ');
          losersList.add(
              '${info['loser']['emoji']} ${loserName} index: ${info['loser']['index']} ');
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
      String winnerName = matchInfo['winner']['name'];
      var getIdFromName =
          ScopedModel.of<PlayerBioModel>(context).findPlayerByName(winnerName);
      var getId1 = getIdFromName.replaceAll('[', '');
      var getId2 = getId1.replaceAll(']', '');
      var getId3 = getId2.replaceAll(',', '');
      var getId4 = getId3.replaceAll(' ', '');

      cupWinnerId = getId4.toString();
      getWinnerDelayed(matchInfo, cupWinnerId);
    }

    dynamic updateMatchList(leftSideScore, rightSideScore, matchIndex) {
      if(!newRound){
        var parsedIndex = int.parse(matchIndex);

        leftScore.replaceRange(parsedIndex, parsedIndex + 1, [leftSideScore]);
        rightScore.replaceRange(parsedIndex, parsedIndex + 1, [rightSideScore]);
      }
    }

    void updateMatchScore(matchScore, player, index) {
      if (matchScore != null && matchScore['index']['indexMatch'] == index.toString()) {

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
                Container(
                  height: MediaQuery.of(context).size.height * 0.365,
                  child: ListView(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: playerColumn(widget.cupPlayers, 'leftSide', winnersList, losersList, updateMatchScore, deathmatchScore, context, getWinner)
                          ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              // margin: EdgeInsets.only(top: 15),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: widget.cupPlayers['leftSide']
                                      .asMap()
                                      .map((index, player) {
                                        var leftScoreCurrent = newRound
                                            ? '${leftScoreNew[index]}'
                                            : '${leftScore[index]}';
                                        var rightScoreCurrent = newRound
                                            ? "${rightScoreNew[index]}"
                                            : "${rightScore[index]}";

                                        updateMatchScore(
                                            deathmatchScore, player, index);

                                        double platformMargin =
                                            Platform.isIOS ? 21 : 15;

                                        bool playedAndLost =
                                            findPlayerInStandings(
                                                losersList, player, index);
                                        bool playedAndWon =
                                            findPlayerInStandings(
                                                winnersList, player, index);

                                        bool isMatchPlayed =
                                            playedAndLost || playedAndWon;

                                        String side = 'leftSide';

                                        return MapEntry(
                                          index,
                                          GestureDetector(
                                            onTap: isMatchPlayed
                                                ? () {}
                                                : () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeftWithFade,
                                                        curve: Curves
                                                            .easeInOutSine,
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        duration: Duration(
                                                            milliseconds: 350),
                                                        child: DeathMatchScreen(
                                                            widget.cupPlayers,
                                                            player,
                                                            index,
                                                            getWinner,
                                                            side),
                                                      ),
                                                    );
                                                  },
                                            child: Container(
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  top: platformMargin),
                                              child: Text(
                                                '${leftScoreCurrent}'
                                                ' : '
                                                '${rightScoreCurrent}',
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontFamily: AppTheme
                                                        .FontFamilies
                                                        .slightlyCurvy),
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                      .values
                                      .toList()
                                      ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: playerColumn(widget.cupPlayers, 'rightSide', winnersList, losersList, updateMatchScore, deathmatchScore, context, getWinner)
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Text(''),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(5.0, -12.0),
                            blurRadius: 15,
                            spreadRadius: 5)
                      ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
