import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/store/tournament_info_model.dart';
import '../theme/theme.dart' as AppTheme;


class SeasonNumber extends StatelessWidget {
  int seasonCounter;

  SeasonNumber(this.seasonCounter);

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: TournamentInfoModel(),

        child: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          child: ScopedModelDescendant<TournamentInfoModel>(
            builder: (context, child, model) {
              int seasonNum = model.getSeasonNumber + seasonCounter;

              return Text(
                'Season ${seasonNum}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 33,
                    fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                    fontWeight: FontWeight.w600),
              );
            },
          ),
        ));
  }
}
