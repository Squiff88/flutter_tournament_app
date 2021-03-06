import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tournament_app/models/tournament_info.dart';
import './store/player_bio_model.dart';
import './store/tournament_info_model.dart';

import './screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<PlayerBioModel>(
      model: PlayerBioModel(),
      child: ScopedModel<TournamentInfoModel>(
        model: TournamentInfoModel(),
        child: MaterialApp(
          home: Container(
              color: Colors.white,
              child: SplashScreen.navigate(
                name: 'assets/animations/intro_anim.flr',
                next: HomePage(),
                until: () => Future.delayed(Duration(milliseconds: 5500)),
                startAnimation: 'splash',
                backgroundColor: Color(0xfffcfcfc),
              )),
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
        ),
      ),
    );
  }
}
