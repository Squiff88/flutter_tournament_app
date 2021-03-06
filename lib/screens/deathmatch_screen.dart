import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/store/player_bio_model.dart';
import '../theme/theme.dart' as AppTheme;

String deathMatchOponent(Map<String, List> totalPlayers, String selectedPlayer,
    int selectedPlayerIndex) {
  if (totalPlayers['leftSide'].contains(selectedPlayer)) {
    return totalPlayers['rightSide'][selectedPlayerIndex];
  } else {
    return totalPlayers['leftSide'][selectedPlayerIndex];
  }
}

class DeathMatchScreen extends StatefulWidget {
  final String _deatchMatchPlayer;
  final Map<String, List> _cupPlayers;
  final int _playerIndex;
  final _getWinner;

  DeathMatchScreen(
      this._cupPlayers, this._deatchMatchPlayer, this._playerIndex, this._getWinner);
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

  @override
  Widget build(BuildContext context) {
    final String playerOponent = deathMatchOponent(
        widget._cupPlayers, widget._deatchMatchPlayer, widget._playerIndex);

    List initPlayerLeft = widget._deatchMatchPlayer.split(' ');
    String playerLeftName = initPlayerLeft[1] + '\n' + initPlayerLeft[2];
    String playerLeftEmoji = initPlayerLeft[0];

    // right player name and emoji
    List initPlayerRight = playerOponent.split(' ');
    String playerRightEmoji = initPlayerRight[0];
    String playerRightName = initPlayerRight[1] + '\n' + initPlayerRight[2];

    if (playerLeftScore == 11) {
      final matchInfo = {
        'winner': {
          'name': playerLeftName,
          'emoji': playerLeftEmoji,
          'score': playerLeftScore
        },
        'loser': {
          'name': playerRightName,
          'emoji': playerRightEmoji,
          'score': playerRightScore
        }
      };

      widget._getWinner(matchInfo);
      print(playerLeftName);
      print('playerLeftName');
      setState(() {
        matchWinner = playerLeftName;
      });
    }

    if (playerRightScore == 11) {
      print(playerRightName);
      print('playerRightName');

      setState(() {
        matchWinner = playerRightName;
      });
    }

    return Scaffold(
      appBar: GradientAppBar(
          title: Text('Cup Mode'), gradient: AppTheme.AppBarColor.linear),
      // floatingActionButton: ActionButton('home_page'),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        // color: Colors.white,
        width: double.infinity,

        child: ScopedModelDescendant<PlayerBioModel>(
          builder: (context, child, model) {
            var initial;
            double distance = 0;

            // left player name and emoji

            // dynamic playerLeftIndicator = playerScore ? 500 : 120;

            return Container(
              alignment: Alignment.center,
              // margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              // color: Colors.red,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height,
                    // color: Colors.amber,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // color: Colors.blueAccent,
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(top:0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.875,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 50, 0, 5),
                                  child: Text(
                                    playerLeftEmoji,
                                    style: TextStyle(fontSize: 45),
                                  ),
                                ),
                                Text(
                                  playerLeftName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 23),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 125),
                                  child: Text('Score:',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily:
                                              AppTheme.FontFamilies.regular)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 12),
                                  child: Text('${playerLeftScore}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily:
                                              AppTheme.FontFamilies.curvy)),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.black,
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
                                  // color: Colors.red,

                                  spreadRadius: playerLeftFlash ? 10 : 8,
                                  offset: Offset(
                                      15.0,
                                      playerLeftFlash
                                          ? (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              140)
                                          : (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              115)),
                                  blurRadius: playerLeftFlash ? 40.0 : 35.0,
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
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height,
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
                        // textDirection: TextDirection.rtl,
                        mainAxisSize: MainAxisSize.max,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            // color: Colors.white,
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.875,
                            // color: Colors.yellow,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 50, 0, 5),
                                  child: Text(
                                    playerRightEmoji,
                                    style: TextStyle(fontSize: 45),
                                  ),
                                ),
                                Text(
                                  playerRightName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 23),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 125),
                                  child: Text('Score:',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily:
                                              AppTheme.FontFamilies.regular)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 12),
                                  child: Text('${playerRightScore}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontFamily:
                                              AppTheme.FontFamilies.curvy)),
                                ),
                              ],
                            ),

                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: playerRightFlash
                                      ? AppTheme.AppColors.sand.withBlue(20)
                                      : AppTheme.AppColors.sand,
                                  // color: Colors.red,

                                  spreadRadius: playerRightFlash ? 10 : 8,
                                  offset: Offset(
                                      0.0,
                                      playerRightFlash
                                          ? (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              145)
                                          : (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              130)),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
