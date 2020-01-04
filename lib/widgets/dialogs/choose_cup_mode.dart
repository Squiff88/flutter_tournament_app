import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../theme/theme.dart' as AppTheme;

  
  Future<String> chooseCupMode(context , String message) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                fontSize: 24
                ),
              ),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Extended');
                  },
                  child: Text(
                    'Extended (all vs all)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                      color: AppTheme.AppColors.intenseFire
                      ),
                    ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, 'Short');
                  },
                  child: Text(
                    'Regular',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppTheme.FontFamilies.slightlyCurvy,
                      color: AppTheme.AppColors.intenseFire
                      ),
                    ),
                ),
              ],)

            ],
          );
        })) {
      case 'Extended':
        return 'Extended';
      case 'Short':
        return 'Short';
        // ...
        break;
    }
  }