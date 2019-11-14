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
import '../helpers/pull_refresh.dart';
import '../store/auth_model.dart';


import '../theme/theme.dart' as AppTheme;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String playerId;
  int playerPoints;
  Timer _timer;
  bool loadingPlayers = false;
  bool loadingPlayersError = false;

  @override
  void initState() {
    super.initState();

    final totalPlayers = ScopedModel.of<PlayerBioModel>(context).getPlayers;
    final userToken = ScopedModel.of<AuthModel>(context).userToken;
    final userId =  ScopedModel.of<AuthModel>(context).userId;

    ScopedModel.of<PlayerBioModel>(context).saveUserToken(userToken);
    ScopedModel.of<PlayerBioModel>(context).saveUserId(userId);

    ScopedModel.of<TournamentInfoModel>(context).saveUserToken(userToken);
    ScopedModel.of<TournamentInfoModel>(context).saveUserId(userId);

    ScopedModel.of<TournamentInfoModel>(context).seasonCounter();
    

    if (totalPlayers == null || totalPlayers.length < 1) {
      setState(() {
        loadingPlayers = true;
      });

      ScopedModel.of<PlayerBioModel>(context)
          .fetchPlayers(userId)
          .catchError((error) {
            print(error);
            print('home screen error');
        setState(() {
          loadingPlayersError = true;
          loadingPlayers = false;
        });
      }).then((_) {
        setState(() {
          loadingPlayers = false;
        });
      });
    }

    ScopedModel.of<PlayerBioModel>(context).getPlayers;

    final scopedReminder =
        ScopedModel.of<PlayerBioModel>(context).reminderAccepted;

    Future<String> infoReminder(message) async {
      switch (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Image.asset(
                  'assets/images/info_avatar.gif',
                  fit: BoxFit.scaleDown,
                  width: MediaQuery.of(context).size.width,
                ),
                SimpleDialogOption(
                  onPressed: () {
                    ScopedModel.of<PlayerBioModel>(context)
                        .reminderAccepter(true);

                    Navigator.pop(context, 'OK');
                  },
                  child: Text(
                    'OK',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppTheme.FontFamilies.curvy,
                        color: AppTheme.AppColors.intenseFire),
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

    final acceptedReminder = scopedReminder != null ? scopedReminder : false;

    this._timer = acceptedReminder
        ? null
        : new Timer(const Duration(milliseconds: 2000), () {
            infoReminder('my message');
          });
  }

  @override
  Widget build(BuildContext context) {
    Future<String> messageDialog(message, userId) async {
      var popupMessage = message;
      switch (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text(
                popupMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppTheme.FontFamilies.curvy, fontSize: 28),
              ),
              children: <Widget>[
                MyCustomForm(userId),
                SimpleDialogOption(
                  onPressed: () {
                    ScopedModel.of<PlayerBioModel>(context,
                            rebuildOnChange: true)
                        .sortPlayers();

                    Navigator.pop(context, 'OK');
                  },
                  child: Text(
                    'OK',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppTheme.FontFamilies.curvy,
                        color: AppTheme.AppColors.intenseFire),
                  ),
                ),
              ],
            );
          })) {
        case 'OK':
          return 'OK';
        default:
          break;
      }
    }
    return Scaffold(
      appBar: GradientAppBar(gradient: AppTheme.AppBarColor.linear),
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
        child: RefreshIndicator(
          onRefresh: () => refreshPlayers(context).catchError((error) {
            print(error);
            print('home screen redresh error');
            setState(() {
              loadingPlayersError = true;
              loadingPlayers = false;
            });
          }).then((_) {
            setState(() {
              loadingPlayers = false;
            });
          }),
          child: this.loadingPlayers
              ? Center(child: CircularProgressIndicator())
              : this.loadingPlayersError
                  ? Center(
                      child: Text('Something went wrong'),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Text(
                            'Welcome Racket Slammers!',
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: AppTheme.FontFamilies.curvy),
                          ),
                        ),
                        ScopedModelDescendant<PlayerBioModel>(
                          builder: (context, child, model) {
                            return Column(children: <Widget>[
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                child: ListView(
                                  children: model.getPlayers
                                      .asMap()
                                      .map((index, info) {
                                        return MapEntry(
                                          index,
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 1)),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                model.selectPlayer(
                                                    model.getPlayers[index].id);
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeftWithFade,
                                                      curve:
                                                          Curves.easeInOutSine,
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      duration: Duration(
                                                          milliseconds: 350),
                                                      child: PlayerDetails(),
                                                    ));
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  AwesomeEmojiPicker(
                                                      playerEmoji: model
                                                          .getPlayers[index]
                                                          .emoji,
                                                      playerId: info.id,
                                                      playerName: info.name),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                      .values
                                      .toList(),
                                ),
                              )
                            ]);
                          },
                        ),
                        ScopedModel(
                          model: TournamentInfoModel(),
                          child: Stack(children: <Widget>[
                            if(!loadingPlayers && !loadingPlayersError)
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
                            Container(
                              child: ScopedModelDescendant<TournamentInfoModel>(
                                  builder: (context, child, model) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 25),
                                      alignment: Alignment.center,
                                      // height: MediaQuery.of(context).size.height * 0.05,
                                      child: RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        color: AppTheme.AppColors.fire
                                            .withGreen(140),
                                        child: Text('Add Slammer',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppTheme
                                                    .FontFamilies.regular)),
                                        onPressed: () {
                                          var userID =  ScopedModel.of<AuthModel>(context).userId;
                                          messageDialog('Slam it !', userID);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ]),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
