import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../theme/theme.dart' as AppTheme;

  
  Future<String> messageDialog(context , message) async {
    var popupMessage = message[0];
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              popupMessage.toString(),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                fontSize: 24
                ),
              ),
            children: <Widget>[
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