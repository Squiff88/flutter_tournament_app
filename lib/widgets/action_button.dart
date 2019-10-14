import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tournament_app/screens/league_screen.dart';
import '../screens/cup_seed_screen.dart';
import 'package:unicorndial/unicorndial.dart';
import 'dart:math';

import '../helpers/hex_colors.dart';
import '../screens/home_screen.dart';
import '../theme/theme.dart' as AppTheme;

class ActionButton extends StatefulWidget {
  final heroTagAddition = '';
  ActionButton(heroTagAddition);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  final floatingButtons = List<UnicornButton>();
  var rng = new Random();
  @override
  Widget build(BuildContext context) {
    if (floatingButtons.length < 3) {
      floatingButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "League Standings",
        currentButton: FloatingActionButton(
          heroTag:
              'home ${rng.nextInt(100 - 1)} + ${widget.heroTagAddition} + ${DateTime.now()}',
          backgroundColor: AppTheme.AppColors.fire,
          mini: false,
          child: Icon(Icons.assessment),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  curve: Curves.easeInOutSine,
                  alignment: Alignment.bottomRight,
                  duration: Duration(milliseconds: 350),
                  child: LeagueScreen(),
                ));
          },
        ),
      ));

      floatingButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Cup Mode",
        currentButton: FloatingActionButton(
          heroTag:
              'cup ${rng.nextInt(100 - 1)} + ${widget.heroTagAddition} + ${DateTime.now()}',
          backgroundColor: Color(0xFFec9c73),
          mini: true,
          child: Icon(Icons.turned_in_not),
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  curve: Curves.easeInOutSine,
                  alignment: Alignment.bottomRight,
                  duration: Duration(milliseconds: 350),
                  child: CupSeedScreen([]),
                ));
          },
        ),
      ));

      floatingButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Home",
        currentButton: FloatingActionButton(
            heroTag:
                'Home ${rng.nextInt(100 - 1)} + ${widget.heroTagAddition} + ${DateTime.now()}',
            backgroundColor: Color(0xFFefbc87),
            mini: true,
            child: Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    curve: Curves.easeInOutSine,
                    alignment: Alignment.bottomRight,
                    duration: Duration(milliseconds: 350),
                    child: HomeScreen(),
                  ));
            }),
      ));
    }

    return UnicornDialer(
      backgroundColor: Colors.transparent,
      parentButtonBackground: AppTheme.AppColors.sand,
      finalButtonIcon: Icon(Icons.graphic_eq),
      parentButton: Icon(
        Icons.dehaze,
        color: Colors.red,
      ),
      // orientation: UnicornOrientation.HORIZONTAL,
      hasBackground: false,
      childButtons: floatingButtons,
    );
  }
}
