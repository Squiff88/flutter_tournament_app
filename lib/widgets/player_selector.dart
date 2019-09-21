import 'package:flutter/material.dart';
import 'package:tournament_app/models/player_bio.dart';
import 'dart:math';

import '../theme/theme.dart' as AppTheme;

class PlayerSelector extends StatefulWidget {
  final List<PlayerBio> players;
  final List selectedPlayers;
  final Function(List<Map<String, String>>) onSelectionChanged; // +add

  PlayerSelector({this.players, this.selectedPlayers, this.onSelectionChanged});
  @override
  _PlayerSelectorState createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  List<Map<String, String>> selectedChoices = List();


  // this function will build and return the choice list
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.players.forEach((item) {
      final rng = new Random();
      final randomMargin = rng.nextInt(38 - 1);

      final String playerName = item.name;
      final String firstName = playerName.split(' ')[0].split('')[0];
      final String lastName = playerName.split(' ')[1].split('')[0];

      Iterable<Map<String, String>> searchList = selectedChoices.where((yo) {
        return yo['name'].contains(item.name);
      });

      String searchPlater = searchList.map((arr) {
        return arr.containsValue(item.name);
      }).toString();

      bool heyYo(List oldPLayers , List selectedChoice) {
        if (oldPLayers != null) {
          var yo = oldPLayers.map((oldChoice) {
            // print(oldChoice['name']);
            // print('oldChoice');
            return oldChoice['name'];
            //  => arr.containsValue(oldChoice)
          }).toString();

          if (yo != null && yo.contains(item.name)) {
            print('(${item.name})');
            print(yo);
            print('yo');
            return true;
          }
        };

      var searchPlayerNameList = selectedChoice.where((yo) {
        return yo['name'].contains(item.name);
      });

      String searchPlater = searchPlayerNameList.map((arr) {
        return arr.containsValue(item.name);
      }).toString();

      return searchPlater == '(true)' ? true : false;
      };

      // print(heyYo(widget.selectedPlayers));

      choices.add(Container(
        // alignment: Alignment.top,
        // height: 20,
        // margin: EdgeInsets.fromLTRB(double.parse(randomMargin.toString()) ,double.parse(randomMargin.toString()) , 0 ,0),
        // alignment: Alignment.center,
        // height: 25,
        // color:Colors.black,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ChoiceChip(
          backgroundColor: Colors.white,
          elevation: 1,
          selectedColor: AppTheme.AppColors.sand.withAlpha(100),
          selectedShadowColor: Colors.orange,
          label: Container(
            // color:Colors.red,
            // height: 200,
            alignment: Alignment.center,
            width: 37,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${item.emoji}',
                  style: TextStyle(fontSize: 36),
                ),
                Text(
                  '${firstName}.${lastName}',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: AppTheme.FontFamilies.curvy,
                      color: Colors.black),
                ),
              ],
            ),
          ),

          //this moster should be fixed
          // searchPlater == '(true)' ? true : false
          selected: heyYo(widget.selectedPlayers , selectedChoices),
          onSelected: (selected) {
            setState(() {
              searchPlater == '(true)'
                  ? selectedChoices.remove(item.name)
                  : selectedChoices
                      .add({'emoji': item.emoji, 'name': item.name});
            });
            widget.onSelectionChanged(selectedChoices);
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
