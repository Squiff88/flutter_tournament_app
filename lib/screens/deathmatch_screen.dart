import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/screens/cup_match_screen.dart';
import 'package:tournament_app/screens/cup_seed_screen.dart';
import 'package:tournament_app/store/player_bio_model.dart';
import '../theme/theme.dart' as AppTheme;

String deathMatchOponent(Map<String, List> totalPlayers, String selectedPlayer,
    int selectedPlayerIndex, chosenSide) {

    if(chosenSide == 'leftSide'){
      return totalPlayers['rightSide'][selectedPlayerIndex];
    }
   else {
    return totalPlayers['leftSide'][selectedPlayerIndex];
  }
}

class DeathMatchScreen extends StatefulWidget {
  final String _deatchMatchPlayer;
  final Map<String, List> _cupPlayers;
  final int _playerIndex;
  final _getWinner;
  final String _side;
  
  DeathMatchScreen(this._cupPlayers, this._deatchMatchPlayer, this._playerIndex,
      this._getWinner, this._side);
  @override
  _DeathMatchScreenState createState() => _DeathMatchScreenState();
}

class _DeathMatchScreenState extends State<DeathMatchScreen> {
  int playerLeftScore = 0;
  int playerRightScore = 0;

  bool playerLeftFlash = false;
  bool playerRightFlash = false;

  double initialDist = 0;

  String matchWinner;

  Timer _timer;

  void goBackDelayed() {
    _timer = new Timer(const Duration(milliseconds: 100), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final String playerOponent = deathMatchOponent(
        widget._cupPlayers, widget._deatchMatchPlayer, widget._playerIndex, widget._side);

    bool playerLeftSide = widget._side == 'leftSide';

    List initPlayerLeft;
    String playerLeftName;
    String playerLeftEmoji;

    List initPlayerRight;
    String playerRightName;
    String playerRightEmoji;

    if (playerLeftSide) {
      // left player name and emoji
      initPlayerLeft = widget._deatchMatchPlayer.split(' ');
      playerLeftName = initPlayerLeft[1] + '\n' + initPlayerLeft[2];
      playerLeftEmoji = initPlayerLeft[0];

      // right player name and emoji
      initPlayerRight = playerOponent.split(' ');
      playerRightName = initPlayerRight[1] + '\n' + initPlayerRight[2];
      playerRightEmoji = initPlayerRight[0];
    } else {
      // right player name and emoji
      initPlayerRight = widget._deatchMatchPlayer.split(' ');
      playerRightName = initPlayerRight[1] + '\n' + initPlayerRight[2];
      playerRightEmoji = initPlayerRight[0];

      // left player name and emoji
      initPlayerLeft = playerOponent.split(' ');
      playerLeftName = initPlayerLeft[1] + '\n' + initPlayerLeft[2];
      playerLeftEmoji = initPlayerLeft[0];
    }

    if (playerLeftScore == 11) {
      final matchInfo = {
        'winner': {
          'name': playerLeftName,
          'emoji': playerLeftEmoji,
          'score': playerLeftScore,
          'side': 'leftSide',
          'index': widget._playerIndex
        },
        'loser': {
          'name': playerRightName,
          'emoji': playerRightEmoji,
          'score': playerRightScore,
          'side': 'rightSide',
          'index': widget._playerIndex
        }
      };

      widget._getWinner(matchInfo);
      goBackDelayed();
    }

    if (playerRightScore == 11) {
      final matchInfo = {
        'winner': {
          'name': playerRightName,
          'emoji': playerRightEmoji,
          'score': playerRightScore,
          'side': 'rightSide',
          'index': widget._playerIndex
        },
        'loser': {
          'name': playerLeftName,
          'emoji': playerLeftEmoji,
          'score': playerLeftScore,
          'side': 'leftSide',
          'index': widget._playerIndex
        }
      };

      widget._getWinner(matchInfo);

      goBackDelayed();
    }

    final appBar = GradientAppBar(
          title: Text('Slammers Deathmatch'),
          gradient: AppTheme.AppBarColor.linear
        );

    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBar,
      body: Container(
        // color: Colors.white,
        width: double.infinity,

        child: ScopedModelDescendant<PlayerBioModel>(
          builder: (context, child, model) {
            var initial;
            double distance = 0;

            return Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: mediaQuery.width * 0.5,
                  height: mediaQuery.height,
                  
                  child: GestureDetector(
                    onPanStart: (DragStartDetails details) {
                      initial = details.globalPosition.dx;

                      setState(() {
                        initialDist = initial;
                      });
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      distance = details.globalPosition.dx - initialDist;
                      if (distance < 0 && playerLeftFlash == false) {
                        setState(() {
                          playerLeftFlash = true;
                        });
                      }
                    },
                    onPanEnd: (DragEndDetails details) {
                      initial = 0.0;
                      if (distance < 0) {
                        setState(() {
                          playerLeftFlash = false;
                          playerLeftScore = playerLeftScore + 1;
                        });
                      } else {
                        setState(() {
                          playerLeftFlash = false;
                        });
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 0),
                          width: double.infinity,
                          height: (mediaQuery.height - appBar.preferredSize.height) * 0.94,
                          child: Column(
                          
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  height: mediaQuery.height *
                                      0.2,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        playerLeftEmoji,
                                        style: TextStyle(fontSize: 45),
                                      ),
                                      Text(
                                        playerLeftName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontFamily: AppTheme
                                                .FontFamilies.slightlyCurvy),
                                      ),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: mediaQuery.height * 0.1),
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Score:',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: AppTheme
                                                  .FontFamilies.regular)),
                                      Text(playerLeftScore.toString(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: AppTheme
                                                  .FontFamilies.curvy)),
                                    ],
                                  )),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                              color: Colors.black.withOpacity(0.04),
                              width: 4,
                            )),
                            boxShadow: [
                              BoxShadow(
                                color: playerLeftFlash
                                    ? Colors.redAccent
                                    : AppTheme.AppColors.fire,
                                spreadRadius: playerLeftFlash ? 6 : 5,
                                offset: Offset(
                                    0.0,
                                    playerLeftFlash
                                        ? (mediaQuery.height - mediaQuery.height * 0.17)
                                        : (mediaQuery.height - mediaQuery.height * 0.15)),
                                blurRadius: playerLeftFlash ? 40.0 : 25.0,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  width: mediaQuery.width * 0.5,
                  height: mediaQuery.height,
                  child: GestureDetector(
                    onPanStart: (DragStartDetails details) {
                      initial = details.globalPosition.dx;

                      setState(() {
                        initialDist = initial;
                      });
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      distance = details.globalPosition.dx - initialDist;
                      if (distance > 0 && playerRightFlash == false) {
                        setState(() {
                          playerRightFlash = true;
                        });
                      }
                    },
                    onPanEnd: (DragEndDetails details) {
                      initial = 0.0;
                      if (distance > 0) {
                        setState(() {
                          playerRightFlash = false;
                          playerRightScore = playerRightScore + 1;
                        });
                      } else {
                        setState(() {
                          playerRightFlash = false;
                        });
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          
                          height: (mediaQuery.height - appBar.preferredSize.height) * 0.940,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: mediaQuery.height * 0.2,
                                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        playerRightEmoji,
                                        style: TextStyle(fontSize: 45),
                                      ),
                                      Text(
                                        playerRightName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontFamily: AppTheme
                                                .FontFamilies.slightlyCurvy),
                                      ),
                                    ],
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: mediaQuery.height * 0.10),
                                  child: Column(
                                    children: <Widget>[
                                      Text('Score:',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: AppTheme
                                                  .FontFamilies.regular)),
                                      Text(playerRightScore.toString(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontFamily: AppTheme
                                                  .FontFamilies.curvy)),
                                    ],
                                  )),
                            ],
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: playerRightFlash
                                    ? AppTheme.AppColors.sand.withBlue(20)
                                    : AppTheme.AppColors.sand,

                                spreadRadius: playerRightFlash ? 10 : 5,
                                offset: Offset(
                                   playerRightFlash ? 5.0 : -5.0,
                                    playerRightFlash
                                        ? (mediaQuery.height - mediaQuery.height * 0.17)
                                        : (mediaQuery.height - mediaQuery.height * 0.155)),
                                blurRadius: playerRightFlash ? 40.0 : 25.0,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
