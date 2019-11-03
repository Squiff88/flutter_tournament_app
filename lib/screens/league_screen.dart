import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';

import '../helpers/pull_refresh.dart';
import '../models/player_bio.dart';
import '../store/tournament_info_model.dart';

import '../screens/season_winner_screen.dart';
import '../store/player_bio_model.dart';
import '../widgets/season_number.dart';

import '../screens/player_details_screen.dart';
import '../widgets/emoji_picker.dart';
import '../widgets/action_button.dart';
import '../theme/theme.dart' as AppTheme;

class LeagueScreen extends StatefulWidget {
  @override
  _LeagueScreenState createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  String playerId;
  int playerPoints;
  int seasonCounter = 0;
  bool loadingPlayers = false;
  bool loadingPlayersError = false;

  @override
  void initState() {
    super.initState();
    ScopedModel.of<PlayerBioModel>(context).sortPlayers();
  }

  @override
  Widget build(BuildContext context) {
    ScopedModel.of<PlayerBioModel>(context).sortPlayers();

    return Scaffold(
      appBar: GradientAppBar(
          title: Text(
            'Slammers Standings',
            style: TextStyle(
                fontFamily: AppTheme.FontFamilies.regular,
                fontWeight: FontWeight.w600,
                fontSize: 27),
          ),
          gradient: AppTheme.AppBarColor.linear),
      floatingActionButton: ActionButton('league_screen'),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        onRefresh: () => refreshPlayers(context).catchError((error) {
          setState(() {
            loadingPlayersError = true;
            loadingPlayers = false;
          });
        }).then((_) {
          setState(() {
            loadingPlayers = false;
          });
        }),
        child: this.loadingPlayersError
            ? Center(
                child: Text('Something went wrong'),
              )
            : Container(
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
                    SeasonNumber(seasonCounter),
                    ScopedModelDescendant<PlayerBioModel>(
                      builder: (context, child, model) {
                        return Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.55,
                              child: ListView(
                                children: model.getPlayers
                                    .asMap()
                                    .map((index, info) {
                                      String updatedPoints =
                                          playerPoints != null
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
                                                    curve: Curves.easeInOutSine,
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    duration: Duration(
                                                        milliseconds: 350),
                                                    child: PlayerDetails(
                                                        this.seasonCounter),
                                                  ));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2,
                                                  child: AwesomeEmojiPicker(
                                                      playerEmoji: model
                                                          .getPlayers[index]
                                                          .emoji,
                                                      playerId: info.id),
                                                ),
                                                Container(
                                                  // margin: EdgeInsets.only(right: 45),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.all(0),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.6,
                                                  child: Text(
                                                    info.name,
                                                    style: TextStyle(
                                                        fontFamily: AppTheme
                                                            .FontFamilies
                                                            .regular,
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
                                                  child: Text(
                                                    updatedPoints,
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        fontFamily: AppTheme
                                                            .FontFamilies.curvy,
                                                        fontSize: 24),
                                                  ),
                                                ),
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
                          ],
                        );
                      },
                    ),
                    ScopedModel(
                      model: TournamentInfoModel(),
                      child: Container(
                        child: ScopedModelDescendant<TournamentInfoModel>(
                            builder: (context, child, model) {
                          return Stack(
                              children:<Widget>[
                              Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 45),
                                  alignment: Alignment.center,
                                  child: RaisedButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    color:
                                        AppTheme.AppColors.fire.withGreen(140),
                                    child: Text('End Season',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            fontFamily:
                                                AppTheme.FontFamilies.regular)),
                                    onPressed: () {
                                      setState(() {
                                        seasonCounter += 1;
                                      });

                                      final firstPlayer =
                                          ScopedModel.of<PlayerBioModel>(
                                                  context,
                                                  rebuildOnChange: true)
                                              .getPlayers;
                                      final PlayerBio winner =
                                          firstPlayer.elementAt(0);
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType
                                                .leftToRightWithFade,
                                            curve: Curves.easeInOutSine,
                                            alignment: Alignment.bottomRight,
                                            duration:
                                                Duration(milliseconds: 350),
                                            child: SeasonWinner(
                                              winner: winner,
                                              winnerImage:
                                                  'https://media.giphy.com/media/5xtDarEWbFEH1JUC424/source.gif',
                                              title: 'Season',
                                              counter: seasonCounter,
                                            ),
                                          ));

                                      model.setSeasonNumber(seasonCounter);
                                      ScopedModel.of<PlayerBioModel>(context,
                                              rebuildOnChange: true)
                                          .resetSeason();
                                    },
                                  ),
                                ),
                              ],
                            ),
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

                              ] 
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
