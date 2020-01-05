import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/widgets/add_player.dart';
import '../../store/player_bio_model.dart';

import '../../theme/theme.dart' as AppTheme;   
   
    Future<String> addPlayerDialog(message, userId, context) async {
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
                        .sortPlayersByName();

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