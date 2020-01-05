import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../store/player_bio_model.dart';
import '../../theme/theme.dart' as AppTheme;
   
   
   
    Future<String> infoReminder(message, context) async {
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