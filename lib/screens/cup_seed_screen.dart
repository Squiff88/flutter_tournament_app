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
  bool startCup = false;

  _showReportDialog(List<PlayerBio> players) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          int playersLen = players.length;
          bool longList = playersLen > 8;
          return Container(
            // color: Colors.blue,
            height: longList ? 400 : 320,
            child: AlertDialog(
              title: Text(
                "Available Slammers :",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.AppColors.intenseFire,
                  fontFamily: AppTheme.FontFamilies.regular,
                  fontSize: 22,
                  fontWeight: FontWeight.w500
                  ),
                ),
              content: Container(
                alignment: Alignment.center,
                // color: Colors.blue,
                height: longList ? 400 : 300,
                child: PlayerSelector(
                  players: players,
                  selectedPlayers: selectedPlayers,
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
                      
                      startCup = false;
                      showPlayers = true;
                    });
                  },
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Done" , style: TextStyle(color: Colors.black),),
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
    if (shuffledPlayers.length > 0) {
      int playersLen = shuffledPlayers.length;

      shuffledPlayers.map((item) => {
            print(playersLen),
            print('playersLen'),
          });
    }

    return Scaffold(
      appBar: GradientAppBar(
          title: Text(
            'Slammer\'s Cup',
            style: TextStyle(
                fontFamily: AppTheme.FontFamilies.regular,
                fontWeight: FontWeight.w600,
                fontSize: 27),
          ),
          gradient: AppTheme.AppBarColor.linear),
      floatingActionButton: ActionButton('home_page'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 35),
        decoration: BoxDecoration(
          image: DecorationImage(
              // colorFilter: ColorFilter.mode(Colors.blueGrey, BlendMode.screen),
              image: AssetImage("assets/images/table_tennis.jpg"),
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomRight),
        ),
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
                        splashColor: AppTheme.AppColors.fire.withGreen(160),
                        // focusColor: Colors.red,
                        highlightColor: Colors.transparent,
                        onPressed: () => _showReportDialog(players),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                'Choose Slammers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppTheme.FontFamilies.curvy,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                ),
                              ),
                              IconButton(
                                color: AppTheme.AppColors.fire.withGreen(160),
                                splashColor: AppTheme.AppColors.fire.withGreen(160),

                                iconSize: 34,
                                icon: Icon(Icons.group_add),
                                onPressed: () => {_showReportDialog(players)},
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: RaisedButton(
                        elevation: 0,
                        highlightElevation: 0,
                        color: Colors.transparent,
                        splashColor: AppTheme.AppColors.fire,
                        // focusColor: Colors.red,
                        highlightColor: Colors.transparent,
                        onPressed: () => shuffle(shuffledPlayers),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Shuffle Slammers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppTheme.FontFamilies.curvy,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                            IconButton(
                              color: AppTheme.AppColors.fire,
                              iconSize: 32,
                              splashColor: AppTheme.AppColors.fire,
                              
                              icon: Icon(Icons.autorenew),
                              onPressed: () => shuffle(shuffledPlayers),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Start Slammin\'",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.FontFamilies.curvy,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                          IconButton(
                            color: AppTheme.AppColors.intenseFire,
                            iconSize: 32,
                            alignment: Alignment.center,
                            icon: Icon(Icons.done_all),
                            onPressed: () {
                              final newPlayes = cupDraw(shuffledPlayers);
                              setState(() {
                                seededPlayers = newPlayes;
                                showPlayers = false;
                                startCup = true;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                if (showPlayers)
                  Container(
                      // padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 35),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        shuffledPlayers.join('\n'),
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: AppTheme.FontFamilies.regular,
                        ),
                        textAlign: TextAlign.left,
                      )),
                if (startCup)
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