import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';

import '../store/player_bio_model.dart';
import '../store/tournament_info_model.dart';
import '../theme/theme.dart' as AppTheme;

class SeasonWinner extends StatelessWidget {
  final String title;
  final dynamic winner;
  final int counter;
  final String winnerImage;

  SeasonWinner(
      {Key key,
      @required this.winner,
      @required this.title,
      this.counter,
      @required this.winnerImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int seasonNum =
        ScopedModel.of<TournamentInfoModel>(context, rebuildOnChange: true)
            .getSeasonNumber;
    final numToSeason = counter != null ? counter : null;
    final currentSeason = numToSeason != null ? (seasonNum + counter - 1) : '';

    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            title + ' ' + currentSeason.toString(),
            style: TextStyle(
                fontFamily: AppTheme.FontFamilies.regular,
                fontWeight: FontWeight.w700,
                fontSize: 27),
          ),
          gradient: AppTheme.AppBarColor.linear,
        ),
        body: Stack(children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            widthFactor: double.infinity,
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
                decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(this.winnerImage),
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomRight),
              ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(0),
            child: ScopedModelDescendant<PlayerBioModel>(
              builder: (context, child, model) {
                return Container(
                  margin: EdgeInsets.only(top: 30,),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          'Grand Slammer\'s \n Champion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Slabo',
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: Text(winner.emoji,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'KaushanScript-Regular',
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          '${winner.name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'KaushanScript-Regular',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
