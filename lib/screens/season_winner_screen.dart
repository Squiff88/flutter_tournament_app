import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/player_bio.dart';
import '../store/player_bio_model.dart';
import '../store/tournament_info_model.dart';
import '../widgets/action_button.dart';
import '../theme/theme.dart' as AppTheme;

class SeasonWinner extends StatelessWidget {
  final int seasonCounter;
  final PlayerBio winner;

  SeasonWinner(this.winner, this.seasonCounter);

  @override
  Widget build(BuildContext context) {
    final int seasonNum =
        ScopedModel.of<TournamentInfoModel>(context, rebuildOnChange: true)
            .getSeasonNumber;
    final int currentSeason = seasonNum + seasonCounter - 1;
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            'Season ${currentSeason}',
            style: TextStyle(
                fontFamily: AppTheme.FontFamilies.regular,
                fontWeight: FontWeight.w700,
                fontSize: 27),
          ),
          gradient: AppTheme.AppBarColor.linear,
        ),
        // floatingActionButton: ActionButton('Winner !'),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(0),
          child: ScopedModelDescendant<PlayerBioModel>(
            builder: (context, child, model) {
              winner.achievements['season'].add('Season ${currentSeason}');
              return Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 30),
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
                      margin: EdgeInsets.only(top: 40),
                      child: Text(winner.emoji,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'KaushanScript-Regular',
                          )),
                    ),
                    Text(
                      '${winner.name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'KaushanScript-Regular',
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        child: Image.network(
                          'https://media.giphy.com/media/5xtDarEWbFEH1JUC424/source.gif',
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
