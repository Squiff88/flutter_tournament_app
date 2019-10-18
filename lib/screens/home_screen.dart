import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournament_app/widgets/add_player.dart';


import '../store/tournament_info_model.dart';
import '../store/player_bio_model.dart';
import '../screens/player_details_screen.dart';
import '../widgets/emoji_picker.dart';
import '../widgets/action_button.dart';

import 'package:logger/logger.dart';
import '../theme/theme.dart' as AppTheme;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String playerId;
  int playerPoints;
  int seasonCounter = 0;
  Timer _timer;



  @override
  void initState() {
    super.initState();

    //init pretty logs
    var logger = Logger(printer: PrettyPrinter(colors: true,));

    ScopedModel.of<PlayerBioModel>(context).sortPlayers();

  Future<String> infoReminder(message) async {

    var popupMessage = message;

logger.v("Verbose log");

logger.d("Debug log");

logger.i("Info log");

logger.w("Warning log");

logger.e("Error log");

logger.wtf("What a terrible failure log");

    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
                Image.asset(
                  'assets/images/info_avatar.gif',
                  fit: BoxFit.scaleDown,
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.3,
                ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                },
                child: Text(
                  'OK',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppTheme.FontFamilies.curvy,
                    color: AppTheme.AppColors.intenseFire
                    ),
                  ),
              ),
            ],
          );
        })) {
      case 'OK':
        return 'OK';
        // ...
        break;
    }
  }
    _timer = new Timer(const Duration(milliseconds: 2000), () {
      infoReminder('my message');
    });
  }


  @override
  Widget build(BuildContext context) {
    ScopedModel.of<PlayerBioModel>(context).sortPlayers();

  Future<String> messageDialog(message) async {
    var popupMessage = message;
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              '${popupMessage}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.FontFamilies.curvy,
                fontSize: 28
                ),
              ),
            children: <Widget>[
              MyCustomForm(),
              SimpleDialogOption(
                onPressed: () {
                  ScopedModel.of<PlayerBioModel>(context,rebuildOnChange: true).sortPlayers();

                  Navigator.pop(context, 'OK');
                },
                child: Text(
                  'OK',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppTheme.FontFamilies.curvy,
                    color: AppTheme.AppColors.intenseFire
                    ),
                  ),
              ),
            ],
          );
        })) {
      case 'OK':
        return 'OK';
        // ...
        break;
    }
  }

    return Scaffold(
      appBar: GradientAppBar(
          gradient: AppTheme.AppBarColor.linear),
      floatingActionButton: ActionButton('home_page'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/table_tennis.jpg"),
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomRight),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // SeasonNumber(seasonCounter),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 25),
              child: Text(
                'Welcome Racket Slammers!',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: AppTheme.FontFamilies.curvy
                ),

              ),
            ),
            ScopedModelDescendant<PlayerBioModel>(
              builder: (context, child, model) {
                return Column(
                  children: model.playerBio
                      .asMap()
                      .map((index, info) {
                        String updatedPoints = playerPoints != null
                            ? playerPoints.toString()
                            : info.points.toString();

                        return MapEntry(
                          index,
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black, width: 1)),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                model.selectPlayer(model.playerBio[index].id);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeftWithFade,
                                        curve: Curves.easeInOutSine,
                                        alignment: Alignment.bottomRight,
                                        duration: Duration(milliseconds: 350),
                                        child:PlayerDetails(this.seasonCounter),
                                        )
                                      );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AwesomeEmojiPicker(
                                      playerEmoji: model.playerBio[index].emoji,
                                      playerId: info.id,
                                      playerName: info.name
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      .values
                      .toList(),
                );
              },
            ),
            ScopedModel(
              model: TournamentInfoModel(),
              child: Container(
                child: ScopedModelDescendant<TournamentInfoModel>(
                    builder: (context, child, model) {
                  return Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 45),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            color: AppTheme.AppColors.fire.withGreen(140),
                            child: Text('Add Slammer',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppTheme.FontFamilies.regular)),
                            onPressed: () {
                              messageDialog('Slam it !');
                        
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


