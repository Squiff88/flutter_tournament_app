import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'dart:math';

import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/screens/cup_match_screen.dart';
import 'package:tournament_app/widgets/cup_draw.dart';

import '../models/player_bio.dart';
import '../store/player_bio_model.dart';
import '../widgets/player_selector.dart';
import '../widgets/action_button.dart';
import '../theme/theme.dart' as AppTheme;

class CupSeedScreen extends StatefulWidget {
  @override
  _CupSeedScreenState createState() => _CupSeedScreenState();
}

class _CupSeedScreenState extends State<CupSeedScreen> {
  List<Map<String, String>> selectedPlayers = List();
  List shuffledPlayers = List();
  Map<String, List<String>> seededPlayers;
  bool showPlayers = false;

  _showReportDialog(players) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: AlertDialog(
              title: Text("Report Video"),
              content: Container(
                alignment: Alignment.center,
                // color: Colors.blue,
                child: PlayerSelector(
                  players: players,
                  onSelectionChanged: (selectedList) {
                    final List<String> convertPlayerList =
                        selectedList.map((item) {
                      final String playerEmoji = item['emoji'];
                      final String playerName = item['name'];

                      return '${playerEmoji} ${playerName}';
                    }).toList();

                    setState(() {
                      selectedPlayers = selectedList;
                      shuffledPlayers = convertPlayerList;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Choose "),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
        });
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    setState(() {
      shuffledPlayers = items;
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
          title: Text('Cup Mode'), gradient: AppTheme.AppBarColor.linear),
      floatingActionButton: ActionButton('home_page'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        alignment: Alignment.topCenter,
        // margin: EdgeInsets.only(top: 35),
        child: ScopedModelDescendant<PlayerBioModel>(
          builder: (context, child, model) {
            final List<PlayerBio> players = model.playerBio;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      // color: Colors.blue,
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: RaisedButton(
                        elevation: 0,
                        highlightElevation: 0,
                        color: Colors.transparent,
                        splashColor: Colors.amber,
                        // focusColor: Colors.red,
                        highlightColor: Colors.transparent,
                        onPressed: () => _showReportDialog(players),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Choose \n Slammers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.group_add),
                                onPressed: () => _showReportDialog(players),
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Shuffle \n Slammers",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.autorenew),
                            onPressed: () => shuffle(shuffledPlayers),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Start \n Slammin\'",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.center,
                            icon: Icon(Icons.done_all),
                            onPressed: (){
                              final newPlayes = cupDraw(shuffledPlayers);
                              setState(() {
                                seededPlayers = newPlayes;
                                showPlayers = true;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      shuffledPlayers.join('\n'),
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    )),
                if (showPlayers)
                  Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: CupMatchScreen(seededPlayers),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
