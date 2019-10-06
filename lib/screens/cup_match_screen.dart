import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'package:tournament_app/screens/cup_seed_screen.dart';
import 'package:tournament_app/screens/deathmatch_screen.dart';
// import 'package:tournament_app/screens/home_screen.dart';
import 'package:tournament_app/store/player_bio_model.dart';
// import 'package:tournament_app/widgets/action_button.dart';
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
  Map<String, dynamic> winner = {};
  List<String> losersList = List();
  List winnersList = List();
  Map<String, Map<String, String>> deathmatchScore;

  int cupPlayersLen;

  Map<String, Map<String, Object>> playedMatches;
  Timer _timer;

  List<String> leftScore = [];
  List<String> rightScore = [];

  String matchWinner = '';

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class

    print('cupPlayersLen');

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

  @override
  void didUpdateWidget(CupMatchScreen oldWidget) {
    if (oldWidget.cupPlayers != widget.cupPlayers) {
      // _init();
      print('hey yoyo oy oy oyo ');
    }
    super.didUpdateWidget(oldWidget);
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

    print(message);
    print('message..........');
    
    print(playersLen);
    print('playersLen');
    final tournamentPhase = (int playersLen, List listOfWinners) {
      int tournamentFormat;

      tournamentFormat = playersLen;

      double nextPhase = tournamentFormat / 2;

      print('getting here ...........');
      // check if next phase

      if (listOfWinners.length == nextPhase) {
        print('NEXT PHase....');
        nextPhase = nextPhase / 2;
        print(nextPhase);
    
        if (nextPhase <= 2) {
          print('finallls ________________');
          print(nextPhase);
        widget.invokeNextRound(winnersList);

          return;
        }

        widget.invokeNextRound(winnersList);

        double winnersLen = widget.cupPlayers['leftSide'].length / 2;
        int nextPhasePlayers = winnersLen.toInt();

        print(winnersList);
        print(playersLen);
        print('winnersList.length');

        leftScore = List.generate(nextPhasePlayers, (i) {
          return '0';
        });

        rightScore = List.generate(nextPhasePlayers, (i) {
          return '0';
        });
        
      }
    };

    void getWinnerDelayed(info) {
      _timer = new Timer(const Duration(milliseconds: 100), () {
        var winnerName = info['winner']['name'].split('\n').join(' ');
        var loserName = info['loser']['name'].split('\n').join(' ');
        setState(() {
          winnersList.add('${info['winner']['emoji']} ${winnerName}');
          losersList.add('${info['loser']['emoji']} ${loserName}');

          playedMatches = info;
        });
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
        tournamentPhase(playersLen, winnersList);
      });
    }

    void getWinner(matchInfo) {
      getWinnerDelayed(matchInfo);
    }

    dynamic updateMatchList(leftSideScore, rightSideScore, matchIndex) {
      var parsedIndex = int.parse(matchIndex);

      leftScore.replaceRange(parsedIndex, parsedIndex + 1, [leftSideScore]);
      rightScore.replaceRange(parsedIndex, parsedIndex + 1, [rightSideScore]);
    }

    return Container(
      width: double.infinity,
      child: ScopedModelDescendant<PlayerBioModel>(
        builder: (context, child, model) {
          final List<PlayerBio> players = model.playerBio;

          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Text('${message}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: widget.cupPlayers['leftSide']
                              .asMap()
                              .map((index, player) {
                                var winner = winnersList.contains(player);
                                var loser = losersList.contains((player));

                                final List splittedName = player.split(' ');
                                final String shortName = splittedName[0] +
                                    '  ' +
                                    splittedName[1] +
                                    '.' +
                                    splittedName[2].split('')[0];

                                return MapEntry(
                                  index,
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: DeathMatchScreen(
                                                  widget.cupPlayers,
                                                  player,
                                                  index,
                                                  getWinner),
                                              curve: Curves.fastOutSlowIn));
                                    },
                                    child: Container(
                                        // color: Colors.blue,
                                        width: double.infinity,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 10),
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
                                  var winner = winnersList.contains(player);
                                  var loser = losersList.contains((player));

                                  if (deathmatchScore != null &&
                                      deathmatchScore['index']['indexMatch'] ==
                                          index.toString()) {
                                    var leftInfo =
                                        deathmatchScore['score']['leftSide'];
                                    var rightInfo =
                                        deathmatchScore['score']['rightSide'];
                                    var matchIndex =
                                        deathmatchScore['index']['indexMatch'];

                                    if (matchWinner != player) {
                                      matchWinner = player;
                                      updateMatchList(
                                          leftInfo, rightInfo, matchIndex);
                                    }
                                  }

                                  return MapEntry(
                                    index,
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: DeathMatchScreen(
                                                  widget.cupPlayers,
                                                  player,
                                                  index,
                                                  getWinner),
                                              curve: Curves.fastOutSlowIn),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 21),
                                        child: Text(
                                          '${leftScore[index]}'
                                          ' : '
                                          "${rightScore[index]}",
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
                      flex: 2,
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: widget.cupPlayers['rightSide']
                              .asMap()
                              .map((index, player) {
                                var winner = winnersList.contains(player);
                                var loser = losersList.contains((player));

                                final List splittedName = player.split(' ');
                                final String shortName = splittedName[1] +
                                    '.' +
                                    splittedName[2].split('')[0] +
                                    '  ' +
                                    splittedName[0];

                                return MapEntry(
                                    index,
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeftWithFade,
                                                  child: DeathMatchScreen(
                                                      widget.cupPlayers,
                                                      player,
                                                      index,
                                                      getWinner),
                                                  curve: Curves.fastOutSlowIn));
                                        },
                                        child: Container(

                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 10),
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
