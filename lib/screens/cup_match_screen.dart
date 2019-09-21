import 'package:flutter/material.dart';
// import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'package:tournament_app/screens/deathmatch_screen.dart';
// import 'package:tournament_app/screens/home_screen.dart';
import 'package:tournament_app/store/player_bio_model.dart';
// import 'package:tournament_app/widgets/action_button.dart';
import '../theme/theme.dart' as AppTheme;

class CupMatchScreen extends StatefulWidget {
  final Map<String, List> cupPlayers;

  CupMatchScreen(this.cupPlayers);

  @override
  _CupMatchScreenState createState() => _CupMatchScreenState();
}

class _CupMatchScreenState extends State<CupMatchScreen> {
  @override
  Widget build(BuildContext context) {

    final playersLen = widget.cupPlayers['leftSide'].length + widget.cupPlayers['rightSide'].length; 

    print(widget.cupPlayers);
    print(playersLen);
    print('widget.cupPlayers.length');
    // GET THE PLAYERS LEN , AND SUBTRACT THE LIST FOR EVERY WIN,
    // UNTIL ONLY ONE PLAYER IS LEFT
    // SHOULD BE A LIST OF ALL PLAYERS THAT ARE STARTING THE TOURNAMENT , NAME AND EMOJI

  Map<String, Map<String, Object>> getWinner(matchInfo){
    print(matchInfo);
    print('matchInfo');
      return matchInfo;
    }


    return Container(
      width: double.infinity,
      // color: Colors.red,
      // color: Colors.yellow,
      // alignment: Alignment.center,
      child: ScopedModelDescendant<PlayerBioModel>(
        builder: (context, child, model) {
          final List<PlayerBio> players = model.playerBio;
          // print("widget.cupPlayers.length");
          // print(widget.cupPlayers['leftSide'].length);
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Row(
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
                                              widget.cupPlayers, player, index, getWinner),
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
                                    )),
                              ),
                            );
                          })
                          .values
                          .toList()),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    // margin: EdgeInsets.only(top: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: widget.cupPlayers['leftSide']
                            .asMap()
                            .map((index, player) {
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
                                                widget.cupPlayers, player, index, getWinner),
                                            curve: Curves.fastOutSlowIn));
                                  },
                                  child: Container(
                                    // color: Colors.red,

                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 20),
                                    child: Text('0 : 0'),
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
                                                  widget.cupPlayers, player, index, getWinner),
                                              curve: Curves.fastOutSlowIn));
                                    },
                                    child: Container(
                                      // color: Colors.yellow,

                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      alignment: Alignment.centerRight,

                                      margin: EdgeInsets.only(top: 15),
                                      child: Text(
                                        shortName,
                                        textAlign: TextAlign.right,
                                      ),
                                    )));
                          })
                          .values
                          .toList()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
